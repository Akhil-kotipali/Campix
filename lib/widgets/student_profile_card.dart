import 'package:flutter/material.dart';
import '../models/student_model.dart'; // Adjust path as needed

class StudentProfileCard extends StatefulWidget {
  final StudentModel student; // <-- pass student directly

  const StudentProfileCard({
    super.key,
    required this.student,
  });

  @override
  State<StudentProfileCard> createState() => _StudentProfileCardState();
}

class _StudentProfileCardState extends State<StudentProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getPrimaryColor(BuildContext context) =>
      Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    // Access student via widget.student
    final student = widget.student;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                getPrimaryColor(context).withOpacity(0.8),
                Colors.white.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: getPrimaryColor(context).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : "?",
                  style: TextStyle(
                    fontSize: 40,
                    color: getPrimaryColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                student.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text('ID: ${student.studentId}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Email: ${student.email}',
                  style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Points: ${student.points}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
