import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepMidnight = Color(0xFF0F172A);
const Color neonRed = Color(0xFFFF2D55);

void main() {
  runApp(const GMTLeadHunterApp());
}

class GMTLeadHunterApp extends StatelessWidget {
  const GMTLeadHunterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GMT Lead Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: deepMidnight,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // --- VARIABLES DE CONNEXION ---
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _leads = []; // Liste des résultats réels
  bool _isLoading = false;

  // ⚠️ REMPLACEZ CETTE URL PAR VOTRE LIEN BACKEND RAILWAY
  final String backendUrl ="https://mysql-production-e612.up.railway.app/hunt";

  Future<void> _startHunt() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": _searchController.text}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _leads = jsonDecode(response.body);
        });
      } else {
        _showError("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      _showError("Impossible de contacter le cerveau : $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar (Menu de gauche)
          Container(
            width: 250,
            color: const Color(0xFF0B1222),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'GMT LEAD HUNTER',
                    style: TextStyle(color: neonRed, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ),
                _sidebarItem(Icons.search, 'Recherche', true),
                _sidebarItem(Icons.list, 'Mes Leads', false),
                _sidebarItem(Icons.credit_card, 'Crédits', false),
              ],
            ),
          ),
          
          // Main Content (Zone de droite)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Chasseur de Prospects IA', 
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w100)),
                  const SizedBox(height: 30),
                  
                  // BARRE DE RECHERCHE RÉELLE
                  _buildSearchBar(),
                  
                  const SizedBox(height: 40),
                  
                  // LISTE DES RÉSULTATS DYNAMIQUE
                  Expanded(
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator(color: neonRed))
                      : _leads.isEmpty 
                        ? const Center(child: Text("Entrez une recherche pour commencer la chasse", style: TextStyle(color: Colors.white24)))
                        : ListView.builder(
                            itemCount: _leads.length,
                            itemBuilder: (context, index) {
                              final lead = _leads[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: leadCard(
                                  lead['title'] ?? 'Inconnu', 
                                  (lead['rating'] ?? 0).toDouble(), 
                                  lead['address'] ?? 'Pas d\'adresse'
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Ex: Restaurants à Douala sans site web...",
                hintStyle: TextStyle(color: Colors.white24),
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _startHunt,
            style: ElevatedButton.styleFrom(backgroundColor: neonRed, foregroundColor: Colors.white),
            child: const Text('HUNT'),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, bool active) {
    return ListTile(
      leading: Icon(icon, color: active ? neonRed : Colors.white24),
      title: Text(label, style: TextStyle(color: active ? Colors.white : Colors.white54)),
      onTap: () {},
    );
  }

  Widget leadCard(String name, double score, String info) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(info, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Text('SCORE', style: TextStyle(color: score < 4 ? neonRed : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('$score', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
