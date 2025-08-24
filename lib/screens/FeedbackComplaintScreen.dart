import 'package:flutter/material.dart';

class FeedbackComplaintScreen extends StatefulWidget {
  const FeedbackComplaintScreen({super.key});

  @override
  _FeedbackComplaintScreenState createState() => _FeedbackComplaintScreenState();
}

class _FeedbackComplaintScreenState extends State<FeedbackComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String message = '';

  // Local storage for demo
  final List<Map<String, String>> _submissions = [];

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final submission = {
        'name': name,
        'email': email,
        'message': message,
      };

      setState(() {
        _submissions.add(submission);
        _formKey.currentState!.reset();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted!')),
      );
    }
  }

  Widget _buildSubmissionList() {
    if (_submissions.isEmpty) {
      return const Text('No feedback submitted yet.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _submissions.length,
      itemBuilder: (context, index) {
        final sub = _submissions[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(sub['name']!),
            subtitle: Text(sub['message']!),
            trailing: Text(sub['email']!),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback & Complaints')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                    onSaved: (val) => name = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter your email';
                      if (!val.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                    onSaved: (val) => email = val!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Feedback / Complaint'),
                    maxLines: 4,
                    validator: (val) => val!.isEmpty ? 'Please enter feedback' : null,
                    onSaved: (val) => message = val!,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submitFeedback,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Submitted Feedback:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildSubmissionList(),
          ],
        ),
      ),
    );
  }
}
