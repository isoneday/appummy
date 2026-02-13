class Registration {
 const Registration({
   this.id,
   required this.fullName,
   required this.email,
   required this.phone,
   required this.institution,
   required this.experienceLevel,
   required this.selectedTopics,
   required this.notes,
   required this.agreedToTerms,
   this.registeredAt,
 });


 final int? id;
 final String fullName;
 final String email;
 final String phone;
 final String institution;
 final String experienceLevel;
 final List<String> selectedTopics;
 final String notes;
 final bool agreedToTerms;
 final DateTime? registeredAt;


 factory Registration.fromJson(Map<String, dynamic> json) {
   final rawTopics = json['selected_topics'];


   return Registration(
     id: _parseInt(json['id']),
     fullName: json['full_name']?.toString() ?? '',
     email: json['email']?.toString() ?? '',
     phone: json['phone']?.toString() ?? '',
     institution: json['institution']?.toString() ?? '',
     experienceLevel: json['experience_level']?.toString() ?? 'beginner',
     selectedTopics: rawTopics is List
         ? rawTopics.map((item) => item.toString()).toList()
         : const <String>[],
     notes: json['notes']?.toString() ?? '',
     agreedToTerms: _parseBool(json['agreed_to_terms']),
     registeredAt: DateTime.tryParse(json['registered_at']?.toString() ?? ''),
   );
 }


 Map<String, dynamic> toRequestJson() {
   return <String, dynamic>{
     'full_name': fullName,
     'email': email,
     'phone': phone,
     'institution': institution,
     'experience_level': experienceLevel,
     'selected_topics': selectedTopics,
     'notes': notes,
     'agreed_to_terms': agreedToTerms,
   };
 }


 Registration copyWith({
   int? id,
   String? fullName,
   String? email,
   String? phone,
   String? institution,
   String? experienceLevel,
   List<String>? selectedTopics,
   String? notes,
   bool? agreedToTerms,
   DateTime? registeredAt,
 }) {
   return Registration(
     id: id ?? this.id,
     fullName: fullName ?? this.fullName,
     email: email ?? this.email,
     phone: phone ?? this.phone,
     institution: institution ?? this.institution,
     experienceLevel: experienceLevel ?? this.experienceLevel,
     selectedTopics: selectedTopics ?? this.selectedTopics,
     notes: notes ?? this.notes,
     agreedToTerms: agreedToTerms ?? this.agreedToTerms,
     registeredAt: registeredAt ?? this.registeredAt,
   );
 }


 static int? _parseInt(Object? value) {
   if (value == null) {
     return null;
   }


   if (value is int) {
     return value;
   }


   if (value is num) {
     return value.toInt();
   }


   return int.tryParse(value.toString());
 }


 static bool _parseBool(Object? value) {
   if (value is bool) {
     return value;
   }


   if (value is num) {
     return value != 0;
   }


   final normalized = value?.toString().trim().toLowerCase();
   return normalized == '1' || normalized == 'true' || normalized == 'yes';
 }
}
