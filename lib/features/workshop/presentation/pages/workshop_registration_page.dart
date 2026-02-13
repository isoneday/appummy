import 'package:flutter/material.dart';

import '../../data/models/registration.dart';
import '../../data/services/workshop_api_service.dart';
import '../widgets/workshop_registration_form.dart';

class WorkshopRegistrationPage extends StatefulWidget {
  const WorkshopRegistrationPage({super.key});

  @override
  State<WorkshopRegistrationPage> createState() =>
      _WorkshopRegistrationPageState();
}

class _WorkshopRegistrationPageState extends State<WorkshopRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _institutionController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _allTopics = const [
    'Flutter Layout & Widget',
    'State Management',
    'Secure API Integration',
    'Authentication & Authorization',
    'OWASP Mobile Top 10',
  ];

  final Set<String> _selectedTopics = <String>{};

  String _experienceLevel = 'beginner';
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _institutionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTopics.isEmpty) {
      _showSnack('Pilih minimal satu topik workshop.', isError: true);
      return;
    }

    if (!_agreedToTerms) {
      _showSnack('Anda harus menyetujui kebijakan workshop.', isError: true);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final registration = Registration(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        institution: _institutionController.text.trim(),
        experienceLevel: _experienceLevel,
        selectedTopics: _selectedTopics.toList(),
        notes: _notesController.text.trim(),
        agreedToTerms: _agreedToTerms,
      );

      final message = await WorkshopApiService.submitRegistration(registration);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFB91C1C)
            : const Color(0xFF065F46),
      ),
    );
  }

  void _onExperienceLevelChanged(String? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _experienceLevel = value;
    });
  }

  void _onTopicSelected(String topic, bool selected) {
    setState(() {
      if (selected) {
        _selectedTopics.add(topic);
      } else {
        _selectedTopics.remove(topic);
      }
    });
  }

  void _onAgreedToTermsChanged(bool? value) {
    setState(() {
      _agreedToTerms = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Registrasi Peserta')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEFF4FF), Color(0xFFE7FBF5)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              WorkshopRegistrationForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                institutionController: _institutionController,
                notesController: _notesController,
                experienceLevel: _experienceLevel,
                onExperienceLevelChanged: _onExperienceLevelChanged,
                allTopics: _allTopics,
                selectedTopics: _selectedTopics,
                onTopicSelected: _onTopicSelected,
                agreedToTerms: _agreedToTerms,
                onAgreedToTermsChanged: _onAgreedToTermsChanged,
                isSubmitting: _isSubmitting,
                onSubmit: _submitRegistration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
