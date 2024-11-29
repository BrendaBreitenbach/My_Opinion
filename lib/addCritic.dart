import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCritic extends StatefulWidget {
  const AddCritic({super.key});

  @override
  State<AddCritic> createState() => _AddCriticState();
}

class _AddCriticState extends State<AddCritic> {
  
  final Color primaryColor = const Color(0xFFA14D0C);
  final Color lightPrimary = const Color(0xFFBD8254);
  final Color backgroundColor = Colors.white;

  
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _descricao = TextEditingController();

  
  String _midia = 'Filme';
  double _nota = 0.0;
  DateTime _dataAtual = DateTime.now();

  
  _adicionarCritica(String midia, String nome, double nota, String descricao, DateTime data) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    
    User? user = auth.currentUser;
    if (user == null) {
      
      try {
        UserCredential userCredential = await auth.signInAnonymously();
        user = userCredential.user;
      } catch (e) {
        print('Erro ao fazer login: $e');
        return; 
      }
    }

    
    Map<String, dynamic> dadosCritica = {
      "midia": midia,
      "nome": nome,
      "nota": nota,
      "descricao": descricao,
      "data": Timestamp.fromDate(data), 
    };

    
    try {
      
      await db.collection("criticas").doc(user!.uid).collection("minhas_criticas").add(dadosCritica);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crítica adicionada com sucesso!')),
      );

      
      _nome.clear();
      _descricao.clear();
      setState(() {
        _nota = 0.0;
      });
    } catch (e) {
      print('Erro ao salvar crítica: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar crítica. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Crítica', style: TextStyle(color: Colors.white)),
        backgroundColor: lightPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              DropdownButtonFormField<String>(
                value: _midia,
                decoration: InputDecoration(
                  labelText: 'Tipo de Mídia',
                  labelStyle: TextStyle(color: lightPrimary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightPrimary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Filme', 'Série', 'Livro'].map((type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _midia = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              
              TextFormField(
                controller: _nome,
                decoration: InputDecoration(
                  labelText: 'Nome da Mídia',
                  labelStyle: TextStyle(color: lightPrimary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightPrimary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              
              Row(
                children: [
                  const Text(
                    'Nota:',
                    style: TextStyle(color: Color(0xFFBD8254)),
                  ),
                  Expanded(
                    child: Slider(
                      value: _nota,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _nota.toStringAsFixed(1),
                      onChanged: (double value) {
                        setState(() {
                          _nota = value;
                        });
                      },
                      activeColor: lightPrimary, 
                      inactiveColor: Colors.grey.shade300,
                    ),
                  ),
                  Text(
                    _nota.toStringAsFixed(1),
                    style: TextStyle(color: lightPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descricao,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: lightPrimary),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightPrimary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    
                    _dataAtual = DateTime.now();
                    
                    
                    _adicionarCritica(
                      _midia, 
                      _nome.text, 
                      _nota, 
                      _descricao.text, 
                      _dataAtual
                    );
                    
                    
                    print('Crítica salva:');
                    print('Mídia: $_midia');
                    print('Nome: ${_nome.text}');
                    print('Nota: $_nota');
                    print('Descrição: ${_descricao.text}');
                    print('Data: $_dataAtual');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightPrimary,
                    foregroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Salvar Crítica',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
