import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      userName = user?.displayName;
      isLoading = false;
    });
  }

  Widget _buildStartMessage() {
    return Column(
      children: [
        Text(
          'Olá, ${userName ?? 'Usuário'}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'O que vamos cozinhar hoje?',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }


  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: CustomColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/occasion');
      },
      child: const Text(
        'Descobrir Receitas',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStartMessage(),
          const SizedBox(height: 30),
          _buildStartButton(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'AICook',
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.grey[200],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey[800]),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
          child: _buildContent(context),
        ),
      ),
    );
  }
}