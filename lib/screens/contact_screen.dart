import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/config/constants.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate submission delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Message sent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final background = isDark ? Colors.grey[900] : Colors.grey[100];

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Get in Touch',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter your name'
                              : null,
                ),
                const Gap(16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || !value.contains('@')
                              ? 'Enter a valid email'
                              : null,
                ),
                const Gap(16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.message_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null || value.length < 10
                              ? 'Message too short'
                              : null,
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitForm,
                    icon:
                        _isSubmitting
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(Icons.send_rounded),
                    label: Text(_isSubmitting ? 'Sending...' : 'Send Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
