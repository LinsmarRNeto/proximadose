import 'package:flutter/material.dart';
import 'package:proximadose/helpers/helper_database.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class EditMedicineForm extends StatefulWidget {
  final Map<String, dynamic> medicine;

  const EditMedicineForm({Key? key, required this.medicine}) : super(key: key);

  @override
  _EditMedicineFormState createState() => _EditMedicineFormState();
}

class _EditMedicineFormState extends State<EditMedicineForm> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  late TextEditingController _modeController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine['name']);
    _doseController = TextEditingController(text: widget.medicine['dose']);
    _modeController = TextEditingController(text: widget.medicine['mode']);
    _dateController = TextEditingController(text: widget.medicine['date']);
    _timeController = TextEditingController(text: widget.medicine['time']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Medicamento'),
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
                  await _updateMedicine();
                  Navigator.pop(context, true);
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateMedicine() async {
    final dbHelper = DatabaseHelper.instance;

    final updatedMedicine = {
      DatabaseHelper.medicineIdCol: widget.medicine['id'],
      DatabaseHelper.medicineNameCol: _nameController.text,
      DatabaseHelper.medicineDoseCol: _doseController.text,
      DatabaseHelper.medicineModeCol: _modeController.text,
      DatabaseHelper.medicineDateCol: _dateController.text,
      DatabaseHelper.medicineTimeCol: _timeController.text,
      DatabaseHelper.medicineStatusCol: 0,
      DatabaseHelper.medicineImageCol: '',
    };

    await dbHelper.updateMedicine(updatedMedicine);
  }
}
