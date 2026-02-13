
import 'package:flutter/material.dart';
import 'package:ummy_app/features/workshop/data/models/registration.dart';
import 'package:ummy_app/features/workshop/data/models/workshop_info.dart';
import 'package:ummy_app/features/workshop/data/services/workshop_api_service.dart';

class WorkshopHomePage extends StatefulWidget {
  const WorkshopHomePage({super.key});

  @override
  State<WorkshopHomePage> createState() => _WorkshopHomePageState();
}

class _WorkshopHomePageState extends State<WorkshopHomePage> {
  final List<String> _allTopics = const [
    'Flutter Layout & Widget',
    'State Management',
    'Secure API Integration',
    'Authentication & Authorization',
    'OWASP Mobile Top 10',
  ];

  bool _isLoading = true;
  String? _apiErrorMessage;

  WorkshopInfo _workshopInfo = WorkshopApiService.fallbackWorkshopInfo;
  List<Registration> _recentRegistrations = <Registration>[];
  final Set<int> _processingRegistrationIds = <int>{};

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _apiErrorMessage = null;
    });

    try {
      final results = await Future.wait<Object>([
        WorkshopApiService.fetchWorkshopInfo(),
        WorkshopApiService.fetchRegistrations(),
      ], eagerError: true);

      final workshopInfo = results[0] as WorkshopInfo;
      final registrations = results[1] as List<Registration>;

      if (!mounted) {
        return;
      }

      setState(() {
        _workshopInfo = workshopInfo;
        _recentRegistrations = registrations;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _apiErrorMessage = error.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openRegistrationPage() async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const WorkshopRegistrationPage(),
      ),
    );

    if (!mounted) {
      return;
    }

    if (message != null && message.isNotEmpty) {
      _showSnack(message);
      await _loadDashboard();
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

  void _setRegistrationProcessing(int id, bool processing) {
    if (!mounted) {
      return;
    }

    setState(() {
      if (processing) {
        _processingRegistrationIds.add(id);
      } else {
        _processingRegistrationIds.remove(id);
      }
    });
  }

  Future<void> _onDeleteRegistration(Registration registration) async {
    final id = registration.id;
    if (id == null) {
      _showSnack('ID registrasi tidak valid.', isError: true);
      return;
    }

    if (_processingRegistrationIds.contains(id)) {
      return;
    }

    final participantName = registration.fullName.isNotEmpty
        ? registration.fullName
        : 'peserta ini';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Registrasi'),
          content: Text('Yakin ingin menghapus data $participantName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    _setRegistrationProcessing(id, true);
    try {
      final message = await WorkshopApiService.deleteRegistration(id);
      if (!mounted) {
        return;
      }

      _showSnack(message);
      await _loadDashboard();
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnack(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      _setRegistrationProcessing(id, false);
    }
  }

  Future<void> _onEditRegistration(Registration registration) async {
    final id = registration.id;
    if (id == null) {
      _showSnack('ID registrasi tidak valid.', isError: true);
      return;
    }

    if (_processingRegistrationIds.contains(id)) {
      return;
    }

    final editFormKey = GlobalKey<FormState>();
    String fullName = registration.fullName;
    String email = registration.email;
    String phone = registration.phone;
    String institution = registration.institution;
    String notes = registration.notes;

    String experienceLevel = registration.experienceLevel;
    if (!['beginner', 'intermediate', 'advanced'].contains(experienceLevel)) {
      experienceLevel = 'beginner';
    }

    final selectedTopics = registration.selectedTopics.toSet();
    bool agreedToTerms = registration.agreedToTerms;
    bool isSubmitting = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            Future<void> submitEdit() async {
              if (!editFormKey.currentState!.validate()) {
                return;
              }

              if (selectedTopics.isEmpty) {
                _showSnack('Pilih minimal satu topik workshop.', isError: true);
                return;
              }

              if (!agreedToTerms) {
                _showSnack(
                  'Anda harus menyetujui kebijakan workshop.',
                  isError: true,
                );
                return;
              }

              setModalState(() {
                isSubmitting = true;
              });
              _setRegistrationProcessing(id, true);

              try {
                final updatedRegistration = Registration(
                  id: registration.id,
                  fullName: fullName.trim(),
                  email: email.trim(),
                  phone: phone.trim(),
                  institution: institution.trim(),
                  experienceLevel: experienceLevel,
                  selectedTopics: selectedTopics.toList(),
                  notes: notes.trim(),
                  agreedToTerms: agreedToTerms,
                  registeredAt: registration.registeredAt,
                );

                final message = await WorkshopApiService.updateRegistration(
                  id,
                  updatedRegistration,
                );

                if (!mounted) {
                  return;
                }

                if (!modalContext.mounted) {
                  return;
                }

                Navigator.of(modalContext).pop();
                _showSnack(message);
                await _loadDashboard();
              } catch (error) {
                if (!mounted) {
                  return;
                }

                _showSnack(
                  error.toString().replaceFirst('Exception: ', ''),
                  isError: true,
                );
              } finally {
                if (modalContext.mounted) {
                  setModalState(() {
                    isSubmitting = false;
                  });
                }
                _setRegistrationProcessing(id, false);
              }
            }

            final bottomInset = MediaQuery.of(modalContext).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, bottomInset + 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: editFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Edit Registrasi Peserta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: fullName,
                          decoration: const InputDecoration(
                            labelText: 'Nama lengkap',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => fullName = value,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => email = value,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }

                            final emailRegex = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Format email tidak valid';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: phone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'No. telepon',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => phone = value,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: institution,
                          decoration: const InputDecoration(
                            labelText: 'Institusi / perusahaan',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => institution = value,
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
                          decoration: const InputDecoration(
                            labelText: 'Level pengalaman',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'beginner',
                              child: Text('Beginner'),
                            ),
                            DropdownMenuItem(
                              value: 'intermediate',
                              child: Text('Intermediate'),
                            ),
                            DropdownMenuItem(
                              value: 'advanced',
                              child: Text('Advanced'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }

                            setModalState(() {
                              experienceLevel = value;
                            });
                          },
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
                          children: _allTopics.map((topic) {
                            final isSelected = selectedTopics.contains(topic);
                            return FilterChip(
                              selected: isSelected,
                              label: Text(topic),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    selectedTopics.add(topic);
                                  } else {
                                    selectedTopics.remove(topic);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: notes,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Catatan tambahan',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => notes = value,
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          value: agreedToTerms,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Saya setuju kebijakan workshop.'),
                          onChanged: (value) {
                            setModalState(() {
                              agreedToTerms = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: isSubmitting ? null : submitEdit,
                            child: Text(
                              isSubmitting
                                  ? 'Menyimpan...'
                                  : 'Simpan Perubahan',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRegistrationCtaCard() {
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
            'Daftar Sebagai Peserta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Form registrasi dipindahkan ke halaman khusus agar lebih nyaman diisi.',
            style: TextStyle(color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _openRegistrationPage,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.app_registration_rounded),
              label: const Text('Buka Form Registrasi'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEFF4FF), Color(0xFFE7FBF5)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadDashboard,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                WorkshopHeroCard(workshopInfo: _workshopInfo),
                const SizedBox(height: 16),
                if (_apiErrorMessage != null)
                  WorkshopErrorCard(errorMessage: _apiErrorMessage!),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: LinearProgressIndicator(minHeight: 4),
                  ),
                WorkshopModuleSection(modules: _workshopInfo.modules),
                const SizedBox(height: 16),
                _buildRegistrationCtaCard(),
                const SizedBox(height: 16),
                WorkshopRegistrationList(
                  registrations: _recentRegistrations,
                  processingIds: _processingRegistrationIds,
                  onEdit: _onEditRegistration,
                  onDelete: _onDeleteRegistration,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
