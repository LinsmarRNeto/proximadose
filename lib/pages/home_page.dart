import 'package:flutter/material.dart';
import 'package:proximadose/layouts/appbar_layout.dart';
import 'package:proximadose/layouts/drawer_layout.dart';
import 'package:proximadose/helpers/helper_database.dart';
import 'package:proximadose/pages/add_page.dart';
import 'package:proximadose/pages/edit_page.dart'; // Adicionado import para EditMedicineForm

class HomePage extends StatefulWidget {
  final String username;
  final bool isUserLoggedIn;

  const HomePage({
    Key? key,
    required this.username,
    required this.isUserLoggedIn,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: dbHelper.getMedicines(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar medicamentos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Nenhum medicamento cadastrado
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nenhum medicamento cadastrado.'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Aguardar a construção do widget antes de navegar
                      WidgetsBinding.instance?.addPostFrameCallback((_) async {
                        // Navegar para a AddPage e aguardar o resultado
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMedicineForm()),
                        );

                        // Atualizar a lista se um medicamento foi adicionado
                        if (result == true) {
                          _refreshMedicineList();
                        }
                      });
                    },
                    child: const Text('Adicionar Medicamento'),
                  ),
                ],
              ),
            );
          } else {
            // Exibir a lista de medicamentos
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final medicine = snapshot.data![index];
                return ListTile(
                  title: Text(medicine['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dose: ${medicine['dose']}'),
                      Text('Data: ${medicine['date']}'),
                      Text('Hora: ${medicine['time']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          // Navegar para a página de edição e aguardar o resultado
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditMedicineForm(medicine: medicine),
                            ),
                          );

                          // Atualizar a lista se as alterações foram salvas
                          if (result == true) {
                            _refreshMedicineList();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Remover o medicamento do banco de dados
                          _deleteMedicine(medicine['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar para a AddPage e aguardar o resultado
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMedicineForm()),
          );

          // Atualizar a lista se um medicamento foi adicionado
          if (result == true) {
            _refreshMedicineList();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Método para atualizar a lista de medicamentos
  void _refreshMedicineList() {
    setState(() {});
  }

  // Método para excluir um medicamento
  void _deleteMedicine(int medicineId) async {
    await dbHelper.deleteMedicine(medicineId);
    _refreshMedicineList();
  }
}
