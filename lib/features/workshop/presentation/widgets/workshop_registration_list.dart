import 'package:flutter/material.dart';

import '../../data/models/registration.dart';

class WorkshopRegistrationList extends StatelessWidget {
  const WorkshopRegistrationList({
    required this.registrations,
    required this.processingIds,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<Registration> registrations;
  final Set<int> processingIds;
  final ValueChanged<Registration> onEdit;
  final ValueChanged<Registration> onDelete;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Peserta Terbaru',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (registrations.isEmpty)
            const Text(
              'Belum ada data registrasi.',
              style: TextStyle(color: Color(0xFF64748B)),
            )
          else
            ...registrations.map((item) {
              final topics = item.selectedTopics.isNotEmpty
                  ? item.selectedTopics.join(', ')
                  : '-';
              final id = item.id;
              final isProcessing = id != null && processingIds.contains(id);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDDE5F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.fullName.isNotEmpty ? item.fullName : '-',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isProcessing)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else ...[
                          IconButton(
                            tooltip: 'Edit peserta',
                            onPressed: () => onEdit(item),
                            icon: const Icon(Icons.edit_outlined, size: 20),
                          ),
                          IconButton(
                            tooltip: 'Hapus peserta',
                            onPressed: () => onDelete(item),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: Color(0xFFB91C1C),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Institusi: ${item.institution.isNotEmpty ? item.institution : '-'}',
                    ),
                    Text(
                      'Level: ${item.experienceLevel.isNotEmpty ? item.experienceLevel : '-'}',
                    ),
                    Text('Topik: $topics'),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
