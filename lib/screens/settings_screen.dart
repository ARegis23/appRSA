import 'package:flutter/material.dart';
import '../../../core/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool allowNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        // Ícone de voltar
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
          onPressed: () {
          Navigator.pop(context);
          },
        ),

        // Título da página
        title: Text('Configurações',
        ),
      ),
      
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Modo escuro
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Modo escuro'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() => isDarkMode = value);
                  // Aqui você pode integrar com seu ThemeController, se tiver
                },
              ),
            ),

            Divider(),


            Divider(),

            // Permissão de avisos
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Permitir avisos'),
              trailing: Switch(
                value: allowNotifications,
                onChanged: (value) {
                  setState(() => allowNotifications = value);
                  // Aqui você pode integrar com sistema de notificações
                },
              ),
            ),
          ],
        ),
      ),

      // Rodapé
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Painel Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outlined),
            label: 'Configurações',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.Dashboard);
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.About);
          }
        },
      ),
    );
  }
}
