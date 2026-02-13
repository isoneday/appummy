import 'package:flutter/material.dart';

class WorkshopRegistrationForm extends StatelessWidget {
  const WorkshopRegistrationForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.institutionController,
    required this.notesController,
    required this.experienceLevel,
    required this.onExperienceLevelChanged,
    required this.allTopics,
    required this.selectedTopics,
    required this.onTopicSelected,
    required this.agreedToTerms,
    required this.onAgreedToTermsChanged,
    required this.isSubmitting,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController institutionController;
  final TextEditingController notesController;
  final String experienceLevel;
  final ValueChanged<String?> onExperienceLevelChanged;
  final List<String> allTopics;
  final Set<String> selectedTopics;
  final void Function(String topic, bool selected) onTopicSelected;
  final bool agreedToTerms;
  final ValueChanged<bool?> onAgreedToTermsChanged;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form Registrasi Peserta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: _inputDecoration(
                'Nama lengkap',
                Icons.person_outline,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }

                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('Email', Icons.alternate_email),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi';
                }

                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Format email tidak valid';
                }

                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration(
                'No. telepon (opsional)',
                Icons.phone_outlined,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: institutionController,
              decoration: _inputDecoration(
                'Institusi / perusahaan',
                Icons.business_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Institusi wajib diisi';
                }

                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: ValueKey<String>(experienceLevel),
              initialValue: experienceLevel,
              decoration: _inputDecoration(
                'Level pengalaman',
                Icons.school_outlined,
              ),
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(
                  value: 'intermediate',
                  child: Text('Intermediate'),
                ),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: onExperienceLevelChanged,
            ),
            const SizedBox(height: 12),
            const Text(
              'Topik Minat',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allTopics.map((topic) {
                final isSelected = selectedTopics.contains(topic);

                return FilterChip(
                  selected: isSelected,
                  label: Text(topic),
                  checkmarkColor: Colors.white,
                  selectedColor: const Color(0xFF0D9488),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) => onTopicSelected(topic, selected),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: notesController,
              minLines: 2,
              maxLines: 4,
              decoration: _inputDecoration(
                'Catatan tambahan (opsional)',
                Icons.notes_outlined,
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: agreedToTerms,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Saya setuju data digunakan untuk kebutuhan workshop dan praktik keamanan data.',
              ),
              onChanged: onAgreedToTermsChanged,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isSubmitting ? null : onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(isSubmitting ? 'Mengirim...' : 'Daftar Workshop'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0D9488), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFFBFDFF),
    );
  }
}
