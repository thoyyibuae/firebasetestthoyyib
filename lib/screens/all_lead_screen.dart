
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

import '../models/lead_model.dart';
import '../providers/lead_provider.dart';

class AllLeadsScreen extends StatefulWidget {
  const AllLeadsScreen({super.key});

  @override
  State<AllLeadsScreen> createState() => _AllLeadsScreenState();
}

class _AllLeadsScreenState extends State<AllLeadsScreen> {
  List<Lead> _leads = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  String _selectedFilter = 'All';
  String? _errorMessage;

  final List<String> _filterOptions = ['All', 'New', 'Follow-up', 'Closed'];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Lead> newLeads;

      if (_selectedFilter == 'All') {
        newLeads = await context.read<LeadProvider>().getLeadsPaginated(
          startAfter: _lastDocument,
        );
      } else {
        newLeads = await context.read<LeadProvider>().getLeadsByStatus(
          _selectedFilter,
          startAfter: _lastDocument,
        );
      }

      if (newLeads.length < 50) {
        _hasMore = false;
      }

      if (newLeads.isNotEmpty) {
        _lastDocument = await _getLastDocument(newLeads.last);
      }

      setState(() {
        _leads.addAll(newLeads);
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading leads: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<DocumentSnapshot> _getLastDocument(Lead lead) async {
    return await FirebaseFirestore.instance
        .collection('leads')
        .doc(lead.id)
        .get();
  }

  Future<void> _refreshLeads() async {
    setState(() {
      _leads.clear();
      _lastDocument = null;
      _hasMore = true;
      _errorMessage = null;
    });
    await _loadLeads();
  }

  void _onFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedFilter = newValue;
        _leads.clear();
        _lastDocument = null;
        _hasMore = true;
        _errorMessage = null;
      });
      _loadLeads();
    }
  }

  Widget _buildIndexErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Index Required',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Firestore needs to create an index for this query. This may take a few minutes.',
            style: TextStyle(color: Colors.orange),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // You can open the URL programmatically if needed
              // or just inform the user to check the console
            },
            child: const Text('Check Index Status'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('All Leads'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              onChanged: _onFilterChanged,
              items: _filterOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLeads,
        child: Column(
          children: [
            if (_errorMessage != null && _errorMessage!.contains('index'))
              _buildIndexErrorMessage(),
            Expanded(
              child: _leads.isEmpty && !_isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      const Text(
                        'No leads found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _leads.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _leads.length) {
                    return _buildLoadMoreButton();
                  }
                  return _LeadListItem(lead: _leads[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    if (_errorMessage != null) {
      return Container(); // Don't show load more if there's an error
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _hasMore ? _loadLeads : null,
          child: const Text('Load More'),
        ),
      ),
    );
  }
}

class _LeadListItem extends StatelessWidget {
  final Lead lead;

  const _LeadListItem({required this.lead});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(
          lead.leadName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mobile: ${lead.mobile}'),
            Text('Project: ${lead.projectName}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(lead.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lead.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(lead.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            lead.leadName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'follow-up':
        return Colors.orange;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}