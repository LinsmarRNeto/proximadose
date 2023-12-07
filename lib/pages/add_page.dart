import 'package:flutter/material.dart';
import 'package:proximadose/helpers/helper_database.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({Key? key}) : super(key: key);

  @override
  _AddMedicineFormState createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _modeController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Medicamento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Nome do Medicamento'),
              ),
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: 'Dose'),
              ),
              TextFormField(
                controller: _modeController,
                decoration:
                    const InputDecoration(labelText: 'Modo de Administração'),
              ),
              DateTimeField(
                controller: _dateController,
                format: DateFormat('dd/MM/yyyy'),
                decoration: const InputDecoration(labelText: 'Data'),
                onShowPicker: (context, currentValue) async {
                  return await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                },
              ),
              DateTimeField(
                controller: _timeController,
                format: DateFormat('HH:mm'),
                decoration: const InputDecoration(labelText: 'Hora'),
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.convert(time);
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  // Adicione a lógica para validar e salvar o medicamento no banco de dados
                  final success = await _addMedicine();

                  // Retorna para a página anterior (home_page.dart)
                  Navigator.pop(context, success);
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _addMedicine() async {
    final dbHelper = DatabaseHelper.instance;

    final medicine = {
      DatabaseHelper.medicineNameCol: _nameController.text,
      DatabaseHelper.medicineDoseCol: _doseController.text,
      DatabaseHelper.medicineModeCol: _modeController.text,
      DatabaseHelper.medicineDateCol: _dateController.text,
      DatabaseHelper.medicineTimeCol: _timeController.text,
      DatabaseHelper.medicineStatusCol: 0,
      DatabaseHelper.medicineImageCol: '',
    };

    final insertedId = await dbHelper.insertMedicine(
      medicine,
      _doseController.text,
      name: _nameController.text,
    );

    return insertedId > 0;
  }
}
