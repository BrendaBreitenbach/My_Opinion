import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_opinion/home.dart';
import 'package:my_opinion/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorText = "";
  bool _displayError = false;

 
  _signup() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email == "" || password == "" || confirmPassword == ""){
      setState(() {
        _displayError = true;
        _errorText = "Por favor, preencha todos os campos.";
      });
    } else if (password != confirmPassword) {
      setState(() {
        _displayError = true;
        _errorText = "Senhas não coincidem.";
      });
    } else {
      setState(() {
        _displayError = false;
      });
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          if (value.user?.uid != null) {
            
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          } else {
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
            setState(() {
              _displayError = true;
              _errorText = "Falha em realizar cadastro. Tente novamente.";
            });
          }
        },
      ).onError((error, stackTrace) {
        
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
              _displayError = true;
              _errorText = "Falha em realizar cadastro. Tente novamente.";
            });
      });
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
              Image.asset("images/Logo.png", height: 180,),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Preencha seus dados.",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: Color(0xffa14d0c)
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                
                const SizedBox(height: 15),
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

                const SizedBox(height: 15),
                TextField(
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key, color: Color(0xffa14d0c)),
                    hintText: "Confirma Senha",
                    hintStyle: const TextStyle(color: Color(0xffa14d0c)),
                    filled: true,
                    fillColor: const Color(0xfff3f3f3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              (_displayError)
                  ? Text(
                      _errorText,
                      style: const TextStyle(color: Colors.red),
                    )
                  : Text(
                      _errorText,
                      style: const TextStyle(color: Colors.white),
                    ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: _signup,
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
                    "Criar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                // Botão de criar conta
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.transparent),
                    foregroundColor: const Color(0xffa14d0c),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 26,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Já tem uma conta",
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
    )
    );
  }
}