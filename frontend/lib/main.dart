import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: deepMidnight,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'GMT Lead Hunter',
                    style: TextStyle(
                      color: neonRed,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Recherche'),
                  textColor: Colors.white,
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Mes Leads'),
                  textColor: Colors.white,
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Crédits'),
                  textColor: Colors.white,
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Résultats de Prospection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        leadCard('Restaurant XYZ', 3.5, 'Pas de site web'),
                        const SizedBox(height: 10),
                        leadCard('Boutique ABC', 4.8, 'Site web présent'),
                        const SizedBox(height: 10),
                        leadCard('Service DEF', 2.2, 'Pas de site web'),
                      ],
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

  Widget leadCard(String name, double score, String faille) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                faille,
                style: const TextStyle(
                  color: neonRed,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: score / 5,
              color: score < 3 ? neonRed : Colors.green,
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}