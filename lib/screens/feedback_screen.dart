import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool recommend = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController enjoyController = TextEditingController();
  final TextEditingController suggestionController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    enjoyController.dispose();
    suggestionController.dispose();
    super.dispose();
  }

  Widget buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Submit Feedback'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFieldLabel('Name'),
              const SizedBox(height: 8),
              buildTextField(
                  hint: 'Enter your name',
                  controller: nameController),
              const SizedBox(height: 20),

              buildFieldLabel('Email Address'),
              const SizedBox(height: 8),
              buildTextField(
                  hint: 'Enter your email',
                  controller: emailController),
              const SizedBox(height: 20),

              buildFieldLabel('What did you enjoy most?'),
              const SizedBox(height: 8),
              buildTextField(
                  hint: 'Tell us what you enjoyed',
                  controller: enjoyController,
                  maxLines: 3),
              const SizedBox(height: 20),

              buildFieldLabel('Suggestions for improvement'),
              const SizedBox(height: 8),
              buildTextField(
                  hint: 'Share your suggestions',
                  controller: suggestionController,
                  maxLines: 3),
              const SizedBox(height: 20),

              Theme(
                data: Theme.of(context).copyWith(
                  checkboxTheme: CheckboxThemeData(
                    fillColor:
                        WidgetStateProperty.all(Colors.white),
                    checkColor:
                        WidgetStateProperty.all(Colors.black),
                  ),
                ),
                child: CheckboxListTile(
                  controlAffinity:
                      ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'I would recommend this event',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: recommend,
                  onChanged: (value) =>
                      setState(() => recommend = value ?? false),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        enjoyController.text.isEmpty ||
                        suggestionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please fill all fields')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Feedback Submitted Successfully!')),
                    );
                    nameController.clear();
                    emailController.clear();
                    enjoyController.clear();
                    suggestionController.clear();
                    setState(() => recommend = false);
                  },
                  child: const Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
