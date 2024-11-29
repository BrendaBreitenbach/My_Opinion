import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_opinion/home.dart';
import 'package:my_opinion/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = "";
  bool _displayError = false;

  
  _login() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email == "" || password == "") {
      setState(() {
        _displayError = true;
        _errorText = "Por favor, preencha todos os campos.";
      });
    } else {
      setState(() {
        _displayError = false;
      });
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const Home()), (route) => false);
      }).onError(
        (error, stackTrace) {
          
          _emailController.clear();
          _passwordController.clear();
          setState(() {
            _displayError = true;
            _errorText = "Email ou senha incorretos.";
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/Logo.png",
                  height: 200,
                ),
                const SizedBox(height: 30),
                
                
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Color(0xffa14d0c)),
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Color(0xffa14d0c)),
                    filled: true,
                    fillColor: const Color(0xfff3f3f3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key, color: Color(0xffa14d0c)),
                    hintText: "Senha",
                    hintStyle: const TextStyle(color: Color(0xffa14d0c)),
                    filled: true,
                    fillColor: const Color(0xfff3f3f3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                
                (_displayError)
                    ? Text(
                        _errorText,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 25),
                
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa14d0c),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 80,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Signup()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent),
                    foregroundColor: const Color(0xffa14d0c),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 60,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Criar conta",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
