// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/lead_model.dart';
//
// class LeadProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Lead> _leads = [];
//   List<Lead> _searchResults = [];
//   bool _isLoading = false;
//
//   List<Lead> get leads => _leads;
//   List<Lead> get searchResults => _searchResults;
//   bool get isLoading => _isLoading;
//
//   // Add new lead
//   Future<void> addLead(Lead lead) async {
//     try {
//       await _firestore.collection('leads').add(lead.toMap());
//       notifyListeners();
//     } catch (error) {
//       throw Exception('Failed to add lead: $error');
//     }
//   }
//
//   // Search leads
//   Future<void> searchLeads(String query) async {
//     if (query.isEmpty) {
//       _searchResults.clear();
//       notifyListeners();
//       return;
//     }
//
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       // Search in name
//       final nameQuery = await _firestore
//           .collection('leads')
//           .where('leadName', isGreaterThanOrEqualTo: query)
//           .where('leadName', isLessThan: query + 'z')
//           .get();
//
//       // Search in mobile
//       final mobileQuery = await _firestore
//           .collection('leads')
//           .where('mobile', isGreaterThanOrEqualTo: query)
//           .where('mobile', isLessThan: query + 'z')
//           .get();
//
//       // Search in project name
//       final projectQuery = await _firestore
//           .collection('leads')
//           .where('projectName', isGreaterThanOrEqualTo: query)
//           .where('projectName', isLessThan: query + 'z')
//           .get();
//
//       Set<Lead> uniqueLeads = {};
//
//       // Add results from name search
//       for (var doc in nameQuery.docs) {
//         uniqueLeads.add(Lead.fromMap(doc.data(), doc.id));
//       }
//
//       // Add results from mobile search
//       for (var doc in mobileQuery.docs) {
//         uniqueLeads.add(Lead.fromMap(doc.data(), doc.id));
//       }
//
//       // Add results from project search
//       for (var doc in projectQuery.docs) {
//         uniqueLeads.add(Lead.fromMap(doc.data(), doc.id));
//       }
//
//       _searchResults = uniqueLeads.toList();
//     } catch (error) {
//       if (kDebugMode) {
//         print('Search error: $error');
//       }
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Get leads with pagination
//   Future<List<Lead>> getLeadsPaginated({int limit = 50, DocumentSnapshot? startAfter}) async {
//     try {
//       Query query = _firestore
//           .collection('leads')
//           .orderBy('createdAt', descending: true)
//           .limit(limit);
//
//       if (startAfter != null) {
//         query = query.startAfterDocument(startAfter);
//       }
//
//       final querySnapshot = await query.get();
//
//       return querySnapshot.docs.map((doc) {
//         return Lead.fromMap(doc.data(), doc.id);
//       }).toList();
//     } catch (error) {
//       throw Exception('Failed to fetch leads: $error');
//     }
//   }
//
//   // Get leads by status
//   Future<List<Lead>> getLeadsByStatus(String status, {int limit = 50, DocumentSnapshot? startAfter}) async {
//     try {
//       Query query = _firestore
//           .collection('leads')
//           .where('status', isEqualTo: status)
//           .orderBy('createdAt', descending: true)
//           .limit(limit);
//
//       if (startAfter != null) {
//         query = query.startAfterDocument(startAfter);
//       }
//
//       final querySnapshot = await query.get();
//
//       return querySnapshot.docs.map((doc) {
//         return Lead.fromMap(doc.data(), doc.id);
//       }).toList();
//     } catch (error) {
//       throw Exception('Failed to fetch leads by status: $error');
//     }
//   }
//
//   void clearSearch() {
//     _searchResults.clear();
//     notifyListeners();
//   }
// }






import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lead_model.dart';

class LeadProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Lead> _leads = [];
  List<Lead> _searchResults = [];
  bool _isLoading = false;

  List<Lead> get leads => _leads;
  List<Lead> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  // Add new lead
  Future<void> addLead(Lead lead) async {
    try {
      await _firestore.collection('leads').add(lead.toMap());
      notifyListeners();
    } catch (error) {
      throw Exception('Failed to add lead: $error');
    }
  }

  // Search leads
  Future<void> searchLeads(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Search in name
      final nameQuery = await _firestore
          .collection('leads')
          .where('leadName', isGreaterThanOrEqualTo: query)
          .where('leadName', isLessThan: query + 'z')
          .get();

      // Search in mobile
      final mobileQuery = await _firestore
          .collection('leads')
          .where('mobile', isGreaterThanOrEqualTo: query)
          .where('mobile', isLessThan: query + 'z')
          .get();

      // Search in project name
      final projectQuery = await _firestore
          .collection('leads')
          .where('projectName', isGreaterThanOrEqualTo: query)
          .where('projectName', isLessThan: query + 'z')
          .get();


      // Search in project name
      final statusWiseQuery = await _firestore
          .collection('leads')
          .where('status', isGreaterThanOrEqualTo: query)
          .where('status', isLessThan: query + 'z')
          .get();



      Set<Lead> uniqueLeads = {};



      // Add results from status Wise search
      for (var doc in statusWiseQuery.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          uniqueLeads.add(Lead.fromMap(data, doc.id));
        }
      }


      // Add results from name search
      for (var doc in nameQuery.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          uniqueLeads.add(Lead.fromMap(data, doc.id));
        }
      }

      // Add results from mobile search
      for (var doc in mobileQuery.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          uniqueLeads.add(Lead.fromMap(data, doc.id));
        }
      }

      // Add results from project search
      for (var doc in projectQuery.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          uniqueLeads.add(Lead.fromMap(data, doc.id));
        }
      }

      _searchResults = uniqueLeads.toList();
    } catch (error) {
      if (kDebugMode) {
        print('Search error: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get leads with pagination
  Future<List<Lead>> getLeadsPaginated({int limit = 50, DocumentSnapshot? startAfter}) async {
    try {
      Query query = _firestore
          .collection('leads')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Lead.fromMap(data, doc.id);
      }).toList();
    } catch (error) {
      throw Exception('Failed to fetch leads: $error');
    }
  }

  // Get leads by status
  // Future<List<Lead>> getLeadsByStatus(String status, {int limit = 50, DocumentSnapshot? startAfter}) async {
  //   try {
  //     Query query = _firestore
  //         .collection('leads')
  //         .where('status', isEqualTo: status)
  //         .orderBy('createdAt', descending: true)
  //         .limit(limit);
  //
  //     if (startAfter != null) {
  //       query = query.startAfterDocument(startAfter);
  //     }
  //
  //     final querySnapshot = await query.get();
  //
  //     return querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>? ?? {};
  //       return Lead.fromMap(data, doc.id);
  //     }).toList();
  //   } catch (error) {
  //     throw Exception('Failed to fetch leads by status: $error');
  //   }
  // }


  Future<List<Lead>> getLeadsByStatus(String status, {int limit = 50, DocumentSnapshot? startAfter}) async {
    try {
      // This will only work for small datasets
      final allLeads = await getLeadsPaginated(limit: 1000); // Increase limit temporarily
      return allLeads.where((lead) => lead.status == status).toList();
    } catch (error) {
      throw Exception('Failed to fetch leads by status: $error');
    }
  }

  void clearSearch() {
    _searchResults.clear();
    notifyListeners();
  }

}



