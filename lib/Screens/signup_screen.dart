import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedProfession;

  // 🔹 Simulated local users list (same structure as login)
  static final List<Map<String, String>> _localUsers = [];

  final List<String> _professions = [
    'Learner (Student)',
    'Educator (Teacher/Tutor)'
  ];

  bool _isLoading = false;

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate processing delay

    final email = _emailController.text.trim();
    final existingUser = _localUsers.any((u) => u['email'] == email);

    if (existingUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User already exists! Please log in.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    _localUsers.add({
      'fname': _nameController.text.trim(),
      'email': email,
      'password': _passwordController.text.trim(),
      'profession': _selectedProfession ?? 'Learner (Student)',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully! Please log in.')),
    );

    // 🔹 Navigate to Login page
    Navigator.pushReplacementNamed(context, '/');

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create Your Account'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.person_add, size: 80, color: Colors.indigo),
              const SizedBox(height: 15),
              const Text(
                "Join StudySync",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value != null && value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_reset),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Profession Dropdown
              DropdownButtonFormField<String>(
                value: _selectedProfession,
                items: _professions.map((profession) {
                  return DropdownMenuItem<String>(
                    value: profession,
                    child: Text(profession),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedProfession = value);
                },
                decoration: InputDecoration(
                  labelText: 'I am a...',
                  prefixIcon: const Icon(Icons.work_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value == null ? 'Select your profession' : null,
              ),
              const SizedBox(height: 28),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Already have account
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
