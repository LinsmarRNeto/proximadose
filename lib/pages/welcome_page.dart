import 'package:flutter/material.dart';
import 'package:proximadose/layouts/appbar_layout.dart';
import 'package:proximadose/layouts/drawer_layout.dart';
import 'package:proximadose/pages/home_page.dart';
import 'package:proximadose/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Você precisa implementar a lógica real de verificação de login aqui
    bool isUserLoggedIn = true; // Ajuste conforme a lógica de autenticação real

    // Se não estiver logado, redireciona para a LoginPage
    if (!isUserLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_welcome.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Adiciona um título
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Bem-vindo ao Próxima Dose!!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Adiciona um texto de boas-vindas
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Descubra uma nova abordagem para gerenciar sua medicação diária de forma simples e eficaz. Com o Próxima Dose, você terá um aliado inteligente para lembrá-lo dos horários certos, fornecer informações sobre seus medicamentos e facilitar o acompanhamento de sua rotina de saúde.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xff6E6E6E),
                  fontSize: 20,
                ),
              ),
            ),
            // Adiciona um botão para navegar para home_page.dart
            ElevatedButton(
              onPressed: () {
                if (isUserLoggedIn) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(
                        username: 'Nome do Usuário',
                        isUserLoggedIn: true,
                      ),
                    ),
                  );
                } else {
                  // Lógica de navegação para a LoginPage se o usuário não estiver logado
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              child: const Text('Vamos Começar!'),
            ),
          ],
        ),
      ),
    );
  }
}
