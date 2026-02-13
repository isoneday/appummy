import 'package:flutter/material.dart';

import '../../data/models/workshop_info.dart';

class WorkshopHeroCard extends StatelessWidget {
  const WorkshopHeroCard({required this.workshopInfo, super.key});

  final WorkshopInfo workshopInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF0D9488)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3322263A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workshopInfo.theme.isNotEmpty
                ? workshopInfo.theme
                : 'Workshop Mobile App Development with Flutter & Cyber Security Essentials',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _chipLabel(
            Icons.calendar_today_rounded,
            workshopInfo.date.isNotEmpty ? workshopInfo.date : '-',
          ),
          const SizedBox(height: 8),
          _chipLabel(
            Icons.access_time_rounded,
            workshopInfo.time.isNotEmpty ? workshopInfo.time : '-',
          ),
          const SizedBox(height: 8),
          _chipLabel(
            Icons.location_on_outlined,
            workshopInfo.location.isNotEmpty ? workshopInfo.location : '-',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _statBadge(
                  'Seat Tersisa',
                  workshopInfo.remainingSeat.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statBadge(
                  'Sudah Daftar',
                  workshopInfo.registered.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipLabel(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x29FFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x48FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFE2E8F0))),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
