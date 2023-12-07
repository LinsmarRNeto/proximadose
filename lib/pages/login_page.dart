import 'package:flutter/material.dart';
import 'package:proximadose/helpers/helper_database.dart';
import 'package:proximadose/pages/register_page.dart';
import 'package:proximadose/pages/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 250,
                height: 200,
                child: Image.asset("assets/images/logo.png"),
              ),
              // Campo email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Campo password
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validar os campos do formulário
                  if (_formKey.currentState?.validate() ?? false) {
                    // Consultar o banco de dados para verificar a autenticação
                    final user = await dbHelper.getUserByEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );

                    print('User from database: $user');
                    print('Entered password: ${_passwordController.text}');

                    if (user != null &&
                        user['password'] == _passwordController.text) {
                      // Se autenticado, navegar para a WelcomePage
                      print('Authentication successful');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                      );
                    } else {
                      // Se não autenticado, exibir mensagem de erro
                      print('Authentication failed');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Usuário não encontrado ou senha incorreta'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Entrar'),
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const Text(
                    'Ainda não tem uma conta?',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: const Text(
                      "Registre-se",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
