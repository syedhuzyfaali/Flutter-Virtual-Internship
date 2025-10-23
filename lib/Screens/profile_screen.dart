import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Defaults (used before API returns)
  String name = 'John Doe';
  String email = 'john.doe@example.com';

  // Static fields to retain
  final String studentId = 'STD-2023-001';
  final String course = 'Computer Science';
  final String semester = '3rd Semester';

  bool isLoading = true;
  String? errorMessage;

  String? _signedInUserId;
  String? _signedInUserEmail;
  String? _signedInUserName;

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    await _loadSignedInUser();
    // If we have stored name/email show them immediately and fetch in background
    final hasStored = (_signedInUserName != null && _signedInUserName!.isNotEmpty) ||
        (_signedInUserEmail != null && _signedInUserEmail!.isNotEmpty);

    if (hasStored) {
      setState(() {
        if (_signedInUserName != null && _signedInUserName!.isNotEmpty) name = _signedInUserName!;
        if (_signedInUserEmail != null && _signedInUserEmail!.isNotEmpty) email = _signedInUserEmail!;
        isLoading = false; // show stored data immediately
      });
      // fetch fresh data but don't show full-page loader
      _fetchUser(showLoader: false);
    } else {
      // no stored data -> show loader while fetching
      _fetchUser(showLoader: true);
    }
  }

  Future<void> _loadSignedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _signedInUserId = prefs.getString('userId'); // set this at login
      _signedInUserEmail = prefs.getString('userEmail'); // optional
      _signedInUserName = prefs.getString('userName'); // optional
    });
  }

  Future<void> _fetchUser({bool showLoader = true}) async {
    if (showLoader) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    } else {
      // keep current UI, but clear previous error
      setState(() {
        errorMessage = null;
      });
    }

    try {
      // If we have a stored user id, fetch that specific user
      if (_signedInUserId != null && _signedInUserId!.isNotEmpty) {
        final url = 'https://68f34f12fd14a9fcc428651a.mockapi.io/user/${_signedInUserId!}';
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final decoded = json.decode(res.body);
          if (decoded is Map<String, dynamic>) {
            _applyUserMap(decoded);
            return;
          }
        } else {
          // fallthrough to list fetch on non-200
        }
      }

      // No userId or fetch failed -> fetch list and try to match by email if available
      final listRes = await http.get(Uri.parse('https://68f34f12fd14a9fcc428651a.mockapi.io/user'));
      if (listRes.statusCode == 200) {
        final decoded = json.decode(listRes.body);
        Map<String, dynamic>? user;
        if (decoded is List && decoded.isNotEmpty) {
          if (_signedInUserEmail != null && _signedInUserEmail!.isNotEmpty) {
            // try to find user by email
            final match = decoded.cast<Map<String, dynamic>>().firstWhere(
                  (u) {
                    final e = (u['email'] ?? u['mail'] ?? '').toString().toLowerCase();
                    return e == _signedInUserEmail!.toLowerCase();
                  },
                  orElse: () => decoded.first as Map<String, dynamic>,
                );
            user = match;
          } else {
            // no email stored, pick first
            user = decoded.first as Map<String, dynamic>?;
          }
        } else if (decoded is Map<String, dynamic>) {
          user = decoded;
        }

        if (user != null) {
          _applyUserMap(user);
          return;
        }

        setState(() {
          errorMessage = 'No user data found';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load user (${listRes.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _applyUserMap(Map<String, dynamic> user) {
    final fetchedName = (user['name'] ?? user['fullName'] ?? user['firstName'] ?? '') as String;
    final fetchedEmail = (user['email'] ?? user['mail'] ?? '') as String;

    setState(() {
      if (fetchedName.isNotEmpty) name = fetchedName;
      if (fetchedEmail.isNotEmpty) email = fetchedEmail;
      isLoading = false;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: const Color(0xFF4C94DC),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchUser(showLoader: true),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitCubeGrid(
                color: const Color(0xFF4C94DC),
                size: 48,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchUser,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C94DC)),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Profile Picture (initials)
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              child: Text(
                                _initialsFromName(name),
                                style: const TextStyle(fontSize: 32, color: Color(0xFF4C94DC), fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4C94DC),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Change photo coming soon!')),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // User Information Cards (name and email from API)
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: const Text('NAME', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          subtitle: Text(name, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: const Text('EMAIL', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          subtitle: Text(email, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                        ),
                      ),

                      // Static fields retained
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: const Text('STUDENT ID', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          subtitle: Text(studentId, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: const Text('COURSE', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          subtitle: Text(course, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: const Text('SEMESTER', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                          subtitle: Text(semester, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                        ),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C94DC),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.settings),
                        label: const Text('Settings'),
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst == false ? true : true);
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('userId');
                          await prefs.remove('userEmail');
                          await prefs.remove('userName');
                          // navigate to login and clear navigation stack
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  String _initialsFromName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}