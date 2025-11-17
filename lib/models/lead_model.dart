// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Lead {
//   String? id;
//   String leadName;
//   String mobile;
//   String projectName;
//   String status;
//   DateTime createdAt;
//
//
//
//   Lead({
//     this.id,
//     required this.leadName,
//     required this.mobile,
//     required this.projectName,
//     required this.status,
//     required this.createdAt,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'leadName': leadName,
//       'mobile': mobile,
//       'projectName': projectName,
//       'status': status,
//       'createdAt': Timestamp.fromDate(createdAt),
//     };
//   }
//
//   static Lead fromMap(Map<String, dynamic> map, String id) {
//     return Lead(
//       id: id,
//       leadName: map['leadName'] ?? '',
//       mobile: map['mobile'] ?? '',
//       projectName: map['projectName'] ?? '',
//       status: map['status'] ?? 'New',
//       createdAt: (map['createdAt'] as Timestamp).toDate(),
//     );
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';

class Lead {
  String? id;
  String leadName;
  String mobile;
  String projectName;
  String status;
  DateTime createdAt;

  Lead({
    this.id,
    required this.leadName,
    required this.mobile,
    required this.projectName,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'leadName': leadName,
      'mobile': mobile,
      'projectName': projectName,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static Lead fromMap(Map<String, dynamic> map, String id) {
    return Lead(
      id: id,
      leadName: map['leadName']?.toString() ?? '',
      mobile: map['mobile']?.toString() ?? '',
      projectName: map['projectName']?.toString() ?? '',
      status: map['status']?.toString() ?? 'New',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(), // fallback to current time if null
    );
  }
}