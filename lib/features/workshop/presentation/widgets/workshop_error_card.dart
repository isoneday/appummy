import 'package:flutter/material.dart';

class WorkshopErrorCard extends StatelessWidget {
  const WorkshopErrorCard({required this.errorMessage, super.key});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDA4AF)),
      ),
      child: Text(
        'Gagal sinkronisasi API: $errorMessage\nAplikasi tetap menampilkan data fallback.',
        style: const TextStyle(color: Color(0xFF9F1239)),
      ),
    );
  }
}
