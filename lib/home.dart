import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_opinion/addCritic.dart';
import 'package:my_opinion/critics.dart';
import 'package:my_opinion/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color primaryColor = const Color(0xFFA14D0C);
  final Color lightPrimary = const Color(0xFFBD8254);
  final Color backgroundColor = Colors.white;

  List<QueryDocumentSnapshot> critics = [];
  bool isLoading = true;

  _logout() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao realizar logout: $error"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  _buscarCriticas() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String userId = auth.currentUser!.uid;
      FirebaseFirestore db = FirebaseFirestore.instance;

      QuerySnapshot snapshot = await db
          .collection("criticas")
          .doc(userId)
          .collection("minhas_criticas")
          .orderBy("data", descending: true)
          .limit(3)
          .get();

      setState(() {
        critics = snapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao carregar críticas: $e"),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'images/LogoName.png',
                    height: 60,
                  ),
                ),
                Positioned(
                  right: 16,
                  child: IconButton(
                    onPressed: _logout,
                    icon: Icon(Icons.logout, color: primaryColor),
                    tooltip: "Sair",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (critics.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Critics(),
                          ),
                        );
                      },
                      child: Text(
                        "Ver Todas as Críticas",
                        style: TextStyle(
                          color: lightPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: critics.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final critic =
                            critics[index].data() as Map<String, dynamic>;
                        return Card(
                          color: lightPrimary.withAlpha(80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 16),
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
                                  "Nota: ${critic['nota']?.toStringAsFixed(1)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Categoria: ${critic['midia']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  critic['descricao'],
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCritic(),
              ),
            );
            _buscarCriticas();
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
