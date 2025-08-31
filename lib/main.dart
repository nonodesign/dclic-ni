import 'package:flutter/material.dart';
import 'ui/redacteur_interface.dart'; // Assurez-vous que ce chemin est correct

void main() {
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      home: const PageAccueil(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Magazine Infos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 91, 12, 210),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            print('Menu cliqué. La fonctionnalité sera disponible à la prochaine MAJ');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              print('Bouton Recherche cliqué. La fonctionnalité sera disponible à la prochaine MAJ');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/magazine.png',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            const PartieTitre(),
            const PartieTexte(),
            const PartieIcone(),
            const PartieRubrique(),
          ],
        ),
      ),

      // ✅ Bouton flottant pour aller à la gestion des rédacteurs
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RedacteurInterface()),
          );
        },
        label: const Text("Ajouter Redacteur"),
        icon: const Icon(Icons.edit_note),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          Text(
            "Votre Magazine Numérique, votre source d'apprentissage et de divertissement",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        "L'appli Magazine Infos est plus qu'un simple magazine d'information, c'est une plateforme dynamique où l'actualité, les analyses approfondies et les reportages exclusifs se rencontrent pour vous offrir une expérience de lecture inégalée. Explorez une vaste gamme de sujets, des dernières nouvelles aux tendances émergentes, le tout à portée de main.",
      ),
    );
  }
}

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconColumn(Icons.phone, "Tel"),
          _iconColumn(Icons.mail, "Mail"),
          _iconColumn(Icons.share, "Partage"),
        ],
      ),
    );
  }

  Widget _iconColumn(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(height: 5),
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.deepPurple)),
      ],
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _imageCard('assets/images/magazine2.png'),
          const SizedBox(width: 15),
          _imageCard('assets/images/magazine3.png'),
        ],
      ),
    );
  }

  Widget _imageCard(String path) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          height: 200,
        ),
      ),
    );
  }
}
