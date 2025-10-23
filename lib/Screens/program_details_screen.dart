import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgramDetails_Screen extends StatefulWidget {
  final String courseId;

  const ProgramDetails_Screen({
    super.key,
    required this.courseId,
  });

  @override
  State<ProgramDetails_Screen> createState() => _ProgramDetails_ScreenState();
}

class _ProgramDetails_ScreenState extends State<ProgramDetails_Screen> {
  bool isLoading = true;
  Map<String, dynamic>? courseData;

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://68f92c82deff18f212b8dd59.mockapi.io/api/data/Courses/${widget.courseId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          courseData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading course details: $e')),
      );
    }
  }

  void _showEnrollmentForm() {
    final _formKey = GlobalKey<FormState>();
    // ignore: unused_local_variable
    String _name = '';
    // ignore: unused_local_variable
    String _email = '';
    // ignore: unused_local_variable
    String _phone = '';
    bool _isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Course Registration'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value ?? '';
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value ?? '';
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _phone = value ?? '';
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                _isSubmitting
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4C94DC),
                        ),
                        child: Text('Submit'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });

                            _formKey.currentState!.save();

                            // Simulate API call with delay
                            await Future.delayed(Duration(seconds: 2));

                            // Close the dialog
                            Navigator.pop(context);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Enrollment submitted successfully, we shall contact you soon',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                      ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCourseImage(String? url) {
    const double imageHeight = 200;

    if (url == null || url.isEmpty) {
      return Container(
        height: imageHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
      );
    }

    final lower = url.toLowerCase();

    try {
      // Handle base64 data URI (e.g. data:image/png;base64,....)
      if (lower.startsWith('data:image/') && lower.contains('base64,')) {
        final payload = url.split('base64,').last;
        final bytes = base64Decode(payload);
        return Image.memory(
          bytes,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
            );
          },
        );
      }

      // Fallback for percent-encoded non-base64 data URIs (rare)
      if (lower.startsWith('data:image/') && !lower.contains('base64,')) {
        final parts = url.split(',');
        if (parts.length > 1) {
          final payload = parts.sublist(1).join(',');
          final decoded = Uri.decodeComponent(payload);
          final bytes = base64Decode(base64Encode(utf8.encode(decoded)));
          return Image.memory(bytes, height: imageHeight, width: double.infinity, fit: BoxFit.cover);
        }
      }

      // Remote raster image (http/https)
      return Image.network(
        url,
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: imageHeight,
            child: Center(
              child: SpinKitCubeGrid(color: const Color(0xFF4C94DC), size: 30),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
          );
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print('Image render error: $e');
      return Container(
        height: imageHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseData?['courseName'] ?? 'Course Details'),
        backgroundColor: const Color(0xFF4C94DC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitCubeGrid(
                color: Color(0xFF4C94DC),
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildCourseImage(courseData?['courseImage']),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    courseData?['courseName'] ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Instructor: ${courseData?['lecturer'] ?? ''}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Apply before: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: DateTime.parse(courseData?['enrollDeadline'] ?? '')
                              .toString()
                              .split(' ')[0],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    courseData?['summary'] ?? '',
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Course Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    courseData?['courseDescription'] ?? '',
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C94DC),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.school),
                      label: const Text(
                        'Enroll Now',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _showEnrollmentForm,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
