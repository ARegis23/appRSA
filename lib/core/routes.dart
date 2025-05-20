import 'package:flutter/material.dart';

//import '../screens/about_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/decrypt_screen.dart';
import '../screens/encrypt_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/settings_screen.dart';
import '../services/auth_service.dart';


class AppRoutes {
    static const String Login = '/login';
    static const String Register = '/register';
    static const String ForgotPassword = '/forgot-password';
    static const String Dashboard = '/dashboard';
    static const String Encrypt = '/encrypt';
    static const String Decrypt = '/decrypt';
    static const String KeyGeneration = '/key-generation';
    static const String Settings = '/settings';
    static const String About = '/about';

  static Map<String, WidgetBuilder> routes = {
    Login: (context) => LoginScreen(),                                  // Tela de login
    Register: (context) => RegisterScreen(),                            // Tela de registro
    ForgotPassword: (context) => ForgotPasswordScreen(),                // Tela de recuperação de senha
    Dashboard: (context) => AuthGuard(child: const DashboardScreen()),  // Protegida pela autenticação
    Encrypt: (context) => EncryptScreen(),                              // Tela de criptografia
    Decrypt: (context) => DecryptScreen(),                              // Tela de descriptografia    
    //KeyGeneration: (context) => KeyGenerationScreen(),                  // Tela de gereação de chaves
    Settings: (context) => SettingsScreen(),                            // Tela de configurações
    //About: (context) => AboutScreen(),                                  // Tela sobre o aplicativo
  };
}
