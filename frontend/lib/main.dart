import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GMTLeadHunterMaster(),
    ));

class GMTLeadHunterMaster extends StatefulWidget {
  const GMTLeadHunterMaster({super.key});

  @override
  State<GMTLeadHunterMaster> createState() => _GMTLeadHunterMasterState();
}

class _GMTLeadHunterMasterState extends State<GMTLeadHunterMaster> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<dynamic> _leads = [];
  bool _isLoading = false;

  // ⚠️ VERIFIEZ L'URL DE VOTRE BACKEND RAILWAY ICI
  final String backendUrl = "https://gmt-lead-hunter-production.up.railway.app/hunt";

  Future<void> _hunt() async {
    if (_searchCtrl.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final res = await http.post(Uri.parse(backendUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"query": _searchCtrl.text}));
      if (res.statusCode == 200) setState(() => _leads = jsonDecode(res.body));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Midnight
      // Le Drawer (menu latéral) ne s'affiche que sur Mobile
      drawer: MediaQuery.of(context).size.width < 800 ? _buildSidebar() : null,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text("GMT LEAD HUNTER", 
          style: TextStyle(color: Color(0xFFFF2D55), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // --- VUE PC (DESKTOP) ---
            return Row(
              children: [
                _buildSidebar(), // Sidebar fixe à gauche
                Expanded(child: _buildMainContent()), // Contenu à droite
              ],
            );
          } else {
            // --- VUE TELEPHONE (MOBILE) ---
            return _buildMainContent(); // Plein écran
          }
        },
      ),
    );
  }

  // COMPOSANT : BARRE LATÉRALE (SIDEBAR)
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF0B1222),
      child: Column(
        children: [
          const SizedBox(height: 50),
          _menuItem(Icons.search, "Lancer la chasse", true),
          _menuItem(Icons.list, "Mes Leads", false),
          _menuItem(Icons.credit_card, "Acheter Crédits", false),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("v1.0.0", style: TextStyle(color: Colors.white24, fontSize: 10)),
          )
        ],
      ),
    );
  }

  // COMPOSANT : CONTENU PRINCIPAL
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Prospection Intelligente IA", 
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w100)),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 30),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  // COMPOSANT : BARRE DE RECHERCHE
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Ex: Cliniques à Douala sans site web",
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _hunt,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2D55),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text("HUNT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // COMPOSANT : LISTE DES RESULTATS
  Widget _buildResultsList() {
    if (_leads.isEmpty && !_isLoading) {
      return const Center(child: Text("Aucun résultat. Tapez votre cible ci-dessus.", style: TextStyle(color: Colors.white24)));
    }
    return ListView.builder(
      itemCount: _leads.length,
      itemBuilder: (context, i) {
        final lead = _leads[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              const Icon(Icons.business, color: Color(0xFFFF2D55), size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lead['title'] ?? 'Sans Nom', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(lead['address'] ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text("SCORE", style: TextStyle(color: Colors.white24, fontSize: 8)),
                  Text("${lead['rating'] ?? 'N/A'}", 
                    style: TextStyle(color: (lead['rating'] ?? 5) < 4 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String title, bool active) {
    return ListTile(
      leading: Icon(icon, color: active ? const Color(0xFFFF2D55) : Colors.white24, size: 20),
      title: Text(title, style: TextStyle(color: active ? Colors.white : Colors.white24, fontSize: 14)),
      onTap: () {},
    );
  }
}
