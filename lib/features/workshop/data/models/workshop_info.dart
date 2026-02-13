class WorkshopInfo {
 const WorkshopInfo({
   required this.theme,
   required this.date,
   required this.time,
   required this.location,
   required this.capacity,
   required this.registered,
   required this.remainingSeat,
   required this.modules,
 });


 final String theme;
 final String date;
 final String time;
 final String location;
 final int capacity;
 final int registered;
 final int remainingSeat;
 final List<WorkshopModule> modules;


 factory WorkshopInfo.fromJson(Map<String, dynamic> json) {
   final rawModules = json['modules'];


   return WorkshopInfo(
     theme: json['theme']?.toString() ?? '',
     date: json['date']?.toString() ?? '',
     time: json['time']?.toString() ?? '',
     location: json['location']?.toString() ?? '',
     capacity: _parseInt(json['capacity']),
     registered: _parseInt(json['registered']),
     remainingSeat: _parseInt(json['remaining_seat']),
     modules: rawModules is List
         ? rawModules
               .whereType<Map>()
               .map((item) => WorkshopModule.fromJson(_stringKeyMap(item)))
               .toList()
         : const <WorkshopModule>[],
   );
 }


 static const WorkshopInfo fallback = WorkshopInfo(
   theme:
       'Workshop Mobile App Development with Flutter & Cyber Security Essentials',
   date: '2026-02-13',
   time: '08:30 - 16:30 WIB',
   location: 'Universitas Mahaputra Muhammad Yamin, Solok',
   capacity: 50,
   registered: 0,
   remainingSeat: 50,
   modules: <WorkshopModule>[
     WorkshopModule(
       title: 'Flutter UI Foundations',
       description:
           'Layout, widget composition, and responsive mobile interface.',
     ),
     WorkshopModule(
       title: 'Form & API Integration',
       description:
           'Input validation, API calls, and clean state handling in Flutter.',
     ),
     WorkshopModule(
       title: 'Cyber Security Essentials',
       description:
           'Secure coding practice and API/data protection fundamentals.',
     ),
   ],
 );


 Map<String, dynamic> toJson() {
   return <String, dynamic>{
     'theme': theme,
     'date': date,
     'time': time,
     'location': location,
     'capacity': capacity,
     'registered': registered,
     'remaining_seat': remainingSeat,
     'modules': modules.map((item) => item.toJson()).toList(),
   };
 }


 WorkshopInfo copyWith({
   String? theme,
   String? date,
   String? time,
   String? location,
   int? capacity,
   int? registered,
   int? remainingSeat,
   List<WorkshopModule>? modules,
 }) {
   return WorkshopInfo(
     theme: theme ?? this.theme,
     date: date ?? this.date,
     time: time ?? this.time,
     location: location ?? this.location,
     capacity: capacity ?? this.capacity,
     registered: registered ?? this.registered,
     remainingSeat: remainingSeat ?? this.remainingSeat,
     modules: modules ?? this.modules,
   );
 }


 static int _parseInt(Object? value) {
   if (value is int) {
     return value;
   }


   if (value is num) {
     return value.toInt();
   }


   return int.tryParse(value?.toString() ?? '') ?? 0;
 }


 static Map<String, dynamic> _stringKeyMap(Map item) {
   return item.map((key, value) => MapEntry(key.toString(), value));
 }
}


class WorkshopModule {
 const WorkshopModule({required this.title, required this.description});


 final String title;
 final String description;


 factory WorkshopModule.fromJson(Map<String, dynamic> json) {
   return WorkshopModule(
     title: json['title']?.toString() ?? '',
     description: json['description']?.toString() ?? '',
   );
 }


 Map<String, dynamic> toJson() {
   return <String, dynamic>{'title': title, 'description': description};
 }
}


