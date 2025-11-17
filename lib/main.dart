
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasemailauthtest/providers/lead_provider.dart';
import 'package:firebasemailauthtest/screens/add_lead_screen.dart';
import 'package:firebasemailauthtest/screens/all_lead_screen.dart';
import 'package:firebasemailauthtest/screens/search_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeadProvider()),
      ],
      child: MaterialApp(
        title: 'Mini CRM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SearchScreen(),
    const AddLeadScreen(),
    const AllLeadsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Lead',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Leads',
          ),
        ],
      ),
    );
  }
}