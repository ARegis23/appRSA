import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/routes.dart';
import '../services/key_generation_service.dart';

class EncryptScreen extends StatefulWidget {
  @override
  _EncryptScreenState createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final TextEditingController _textController = TextEditingController();
  String? encryptedText;

  String? first_name;
  String? last_name;
  String? dob; // MM/DD

  bool loading = true;

  String? publicKey;
  String? privateKey;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        loading = false;
        encryptedText = "Usuário não autenticado";
      });
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        setState(() {
          loading = false;
          encryptedText = "Dados do usuário não encontrados";
        });
        return;
      }

      setState(() {
        first_name = userDoc.get('first_name') as String;
        last_name = userDoc.get('last_name') as String;
        dob = userDoc.get('dob') as String; // Espera MM/DD
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        encryptedText = "Erro ao carregar dados do usuário";
      });
    }
  }

  Future<void> _saveToFile(String filename, String content) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsString(content);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Arquivo salvo: ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar arquivo: $e')));
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label copiado para área de transferência')));
  }

  void _encrypt() {
    if (loading || first_name == null || last_name == null || dob == null) return;
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final keys = KeyGenerationService.generateKeys(now);

    setState(() {
      publicKey = keys['publicKey']!;
      privateKey = keys['privateKey']!;
    });

    final encrypted = KeyGenerationService.encryptWithPublicKey(
      text,
      publicKey!,
      first_name!,
      last_name!,
      dob!,
    );

    setState(() {
      encryptedText = encrypted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Encriptando'),),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    

    return Scaffold(
            appBar: AppBar(
      
        // Ícone de fechar
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
          Navigator.pop(context);
          },
        ),

        // Saudacao Usuario
        title: Text('Encriptando'),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Texto para criptografar',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encrypt,
              child: Text('Criptografar'),
            ),
            SizedBox(height: 20),
            if (publicKey != null && privateKey != null) ...[
              Text('Chave Pública:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(publicKey!, style: TextStyle(fontFamily: 'monospace')),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.copy),
                    label: Text('Copiar'),
                    onPressed: () => _copyToClipboard(publicKey!, 'Chave Pública'),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.download),
                    label: Text('Baixar'),
                    onPressed: () => _saveToFile('public_key.txt', publicKey!),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Chave Privada:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(privateKey!, style: TextStyle(fontFamily: 'monospace')),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.copy),
                    label: Text('Copiar'),
                    onPressed: () => _copyToClipboard(privateKey!, 'Chave Privada'),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.download),
                    label: Text('Baixar'),
                    onPressed: () => _saveToFile('private_key.txt', privateKey!),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            if (encryptedText != null && encryptedText!.isNotEmpty) ...[
              Text('Texto Criptografado:', style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(encryptedText!, style: TextStyle(fontFamily: 'monospace')),
              Row(
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.copy),
                    label: Text('Copiar'),
                    onPressed: () => _copyToClipboard(encryptedText!, 'Texto criptografado'),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.download),
                    label: Text('Baixar'),
                    onPressed: () => _saveToFile('encrypted_text.txt', encryptedText!),
                  ),
                ],
              ),
            ],
          ],
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