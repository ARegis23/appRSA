import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/routes.dart';
import '../widgets/menu_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _firstNameController;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _firstNameController = '${data['first_name']} ${data['last_name']}';
        });
      }
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
      
        // Ícone de fechar
        leading: IconButton(
        icon: Icon(Icons.close),
          onPressed: () => _logout(context),
        ),

        // Saudacao Usuario
        title: Text('Olá, ${_firstNameController?? 'Carregando...'}'),
      ),
        
      body:Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                DashboardCard(
                  title: 'Criptografar Texto',
                  icon: Icons.lock_outline,
                  route: AppRoutes.Encrypt,
                ),
                DashboardCard(
                  title: 'Descriptografar Texto',
                  icon: Icons.lock_open_outlined,
                  route: AppRoutes.Decrypt,
                ),
              ],
            ),
          ),
        ),
      ),
    
        // Rodape
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _getCurrentIndex(context) == -1 ? 0 : _getCurrentIndex(context),
          selectedItemColor: _getCurrentIndex(context) == -1 ? Colors.red[600] : null, // Remove destaque
          unselectedItemColor: Colors.black87,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outlined),
              label: 'Informações',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Painel Inicial',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_sharp),
              label: 'Configurações',
            ),
          ],
          onTap: (int index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, AppRoutes.About);
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, AppRoutes.Dashboard);
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, AppRoutes.Settings);
            }
          },
        ),
      );
    }
  }

  // Função para obter o índice atual do BottomNavigationBar
  int _getCurrentIndex(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    if (currentRoute == AppRoutes.About) return 0;
    if (currentRoute == AppRoutes.Dashboard) return 1;
    if (currentRoute == AppRoutes.Settings) return 2;

    return -1; // Nenhum item será destacado
  }