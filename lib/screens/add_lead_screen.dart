import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart' ;

import '../models/lead_model.dart';
import '../providers/lead_provider.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  String _selectedStatus = 'New';
  bool _isSubmitting = false;

  bool ? validate= false;

  final List<String> _statusOptions = ['New', 'Follow-up', 'Closed'];

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    setState(() {
      validate=true;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final lead = Lead(
        leadName: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        projectName: _projectController.text.trim(),
        status: _selectedStatus,
        createdAt: DateTime.now(),
      );

      await context.read<LeadProvider>().addLead(lead);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lead added successfully!'),
            backgroundColor: Colors.green,
          ),
        );


       _nameController.clear();
    _mobileController.clear();
    _projectController.text.trim();
        _selectedStatus = 'New';
        setState(() {
          validate=false;

        });
        // Clear form
        _formKey.currentState!.reset();

      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding lead: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add New Lead'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode:

          validate! ?
          AutovalidateMode.always:
          AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  labelText: 'Lead Name',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lead name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration:  InputDecoration(

                  labelText: 'Mobile Number',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.length !=10) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _projectController,
                decoration:  InputDecoration(
                  labelText: 'Project Name',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isSmallScreen = constraints.maxWidth < 600;

                return DropdownButton2<String>(
                  value: _selectedStatus,
                  hint: const Center(
                    child: Text(
                      'Select Status',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  selectedItemBuilder: (context) {
                    return _statusOptions.map(
                          (status) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 25,),

                              Center(
                                                      child: Text(
                              status,
                              style: const TextStyle(fontSize: 14),
                                                      ),
                                                    ),
                            ],
                          ),
                    ).toList();
                  },
                  underline: const SizedBox(),
                  items: _statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 25,),
                          Text(
                            status,
                            // textAlign: TextAlign.center, // Center inside dropdown items
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },

                  buttonStyleData: ButtonStyleData(

                    padding: const EdgeInsets.only(right: 16),
                    height: 60,
                    width: isSmallScreen ? double.infinity : 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    iconSize: 14,
                    iconEnabledColor: Colors.black,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    width: isSmallScreen ? constraints.maxWidth : null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    elevation: 8,
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 80),
                );
              },
            ),const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : const Text(
                    'Add Lead',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}