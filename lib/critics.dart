import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Critics extends StatefulWidget {
  const Critics({super.key});

  @override
  State<Critics> createState() => _CriticsState();
}

class _CriticsState extends State<Critics> {
  final Color primaryColor = const Color(0xFFA14D0C);
  final Color lightPrimary = const Color(0xFFBD8254);
  final Color backgroundColor = Colors.white;

  List<String> categories = ['Todos', 'Filme', 'Série', 'Livro'];
  String selectedCategory = 'Todos';

  List<QueryDocumentSnapshot> critics = [];
  bool isLoading = true;

  
  Future<void> _buscarCriticas() async {
    setState(() {
      isLoading = true;
    });

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;
      FirebaseFirestore db = FirebaseFirestore.instance;

      QuerySnapshot snapshot;

      if (selectedCategory == 'Todos') {
        snapshot = await db
            .collection("criticas")
            .doc(_userId)
            .collection("minhas_criticas")
            .orderBy("data", descending: true)
            .orderBy("__name__", descending: true)
            .get();
      } else {
        snapshot = await db
            .collection("criticas")
            .doc(_userId)
            .collection("minhas_criticas")
            .where('midia', isEqualTo: selectedCategory)
            .get();
      }

      setState(() {
        critics = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage = "Erro ao carregar críticas. ";
      if (e.toString().contains("no index")) {
        errorMessage +=
            "Certifique-se de que o índice correto está configurado no Firestore.";
      } else {
        errorMessage += e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _buscarCriticas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Críticas', style: TextStyle(color: Colors.white)),
        backgroundColor: lightPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              children: categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedCategory = isSelected ? category : 'Todos';
                      isLoading = true;
                    });
                    _buscarCriticas();
                  },
                  selectedColor: lightPrimary,
                  backgroundColor: backgroundColor,
                  side: BorderSide(color: lightPrimary),
                  labelStyle: TextStyle(
                    color: selectedCategory == category ? backgroundColor : primaryColor,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : critics.isEmpty
                    ? const Center(child: Text("Nenhuma crítica encontrada."))
                    : ListView.builder(
                        itemCount: critics.length,
                        itemBuilder: (context, index) {
                          final critic = critics[index].data() as Map<String, dynamic>;
                          return Card(
                            color: lightPrimary.withAlpha(80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            margin: const EdgeInsets.only(top: 16, bottom: 8, left: 20, right: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    critic['nome'] ?? 'Crítica ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Nota: ${critic['nota']?.toStringAsFixed(1) ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: primaryColor.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Categoria: ${critic['midia'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    critic['descricao'] ?? 'Resumo não disponível.',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      ),
    );
  }
}
