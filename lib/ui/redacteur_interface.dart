import 'package:flutter/material.dart';
import '../modele/redacteur.dart';
import '../database/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    _loadRedacteurs();
  }

  Future<void> _loadRedacteurs() async {
    final redacteurs = await DatabaseManager().getAllRedacteurs();
    if (!mounted) return;
    setState(() {
      _redacteurs = redacteurs;
    });
  }

  Future<void> _addRedacteur() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _emailController.text.isEmpty) {return; }

    final redacteur = Redacteur.withoutId(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );

    await DatabaseManager().insertRedacteur(redacteur);
    if (!mounted) return;

    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    _loadRedacteurs();
  }

  Future<void> _editRedacteurDialog(Redacteur redacteur) async {
    _nomController.text = redacteur.nom;
    _prenomController.text = redacteur.prenom;
    _emailController.text = redacteur.email;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier le rédacteur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _saveRedacteur(redacteur);
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRedacteur(Redacteur redacteur) async {
    final updated = Redacteur(
      id: redacteur.id,
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );

    await DatabaseManager().updateRedacteur(updated);
    if (!mounted) return;
    Navigator.pop(context);
    _loadRedacteurs();
  }

  Future<void> _confirmDelete(int id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Êtes-vous sûr de vouloir supprimer ce rédacteur ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteRedacteur(id);
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRedacteur(int id) async {
    await DatabaseManager().deleteRedacteur(id);
    if (!mounted) return;
    Navigator.pop(context);
    _loadRedacteurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des Rédacteurs',
           style: TextStyle(color: Colors.white),
          ), 
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addRedacteur,
              icon: const Icon(Icons.add),
              label: const Text(
                "Ajouter un Rédacteur",
                 style: TextStyle(color: Colors.white),
                ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
            const SizedBox(height: 20),
            const Text(
              'Liste des Rédacteurs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _redacteurs.length,
                itemBuilder: (context, index) {
                  final r = _redacteurs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${r.nom} ${r.prenom}"),
                      subtitle: Text(r.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editRedacteurDialog(r),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(r.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
