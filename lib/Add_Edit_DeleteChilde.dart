import 'package:flutter/material.dart';
import 'package:customchart/Services/Database_Helper.dart';
import 'package:intl/intl.dart';

class AddChildrenPage extends StatefulWidget {
  const AddChildrenPage({super.key});

  @override
  State<AddChildrenPage> createState() => _AddChildrenPageState();
}

class _AddChildrenPageState extends State<AddChildrenPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  String? _bloodType;
  String? _gender;

  @override
  void dispose() {
    _birthdateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  String? validateDouble(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    final n = double.tryParse(value);
    if (n == null) {
      return 'กรุณากรอกตัวเลข';
    }
    return null;
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> child = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'nickname': _nicknameController.text,
        'birthdate': _birthdateController.text,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'bloodType': _bloodType,
        'allergies': _allergiesController.text,
        'gender': _gender,
        'createDate': DateTime.now().toIso8601String(),
        'modifyDate': DateTime.now().toIso8601String(),
      };

      await _dbHelper.insertChild(child);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Saved')),
      );

      Navigator.pop(context, child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มข้อมูลเด็ก'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView( // Wrapped with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'นามสกุล',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกนามสกุล';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อเล่น',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อเล่น';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                    labelText: 'วันเกิด',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _birthdateController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกวันเกิด';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'ส่วนสูง (cm)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: validateDouble,
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'น้ำหนัก (kg)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: validateDouble,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'กรุ๊ปเลือด',
                  ),
                  items: <String>[
                    'กรุ๊ปเลือด A',
                    'กรุ๊ปเลือด B',
                    'กรุ๊ปเลือด AB',
                    'กรุ๊ปเลือด O'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _bloodType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกกรุ๊ปเลือด';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _allergiesController,
                  decoration: const InputDecoration(
                    labelText: 'การแพ้ยา',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกข้อมูลการแพ้ยา';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'เพศ',
                  ),
                  items: <String>['ชาย', 'หญิง'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกเพศ';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text('บันทึก'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditChildrenPage extends StatefulWidget {
  final Map<String, dynamic> child;

  EditChildrenPage({required this.child});

  @override
  _EditChildrenPageState createState() => _EditChildrenPageState();
}

class _EditChildrenPageState extends State<EditChildrenPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nicknameController;
  late TextEditingController _birthdateController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _allergiesController;
  String? _bloodType;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.child['firstName']);
    _lastNameController = TextEditingController(text: widget.child['lastName']);
    _nicknameController = TextEditingController(text: widget.child['nickname']);
    _birthdateController = TextEditingController(text: widget.child['birthdate']);
    _heightController = TextEditingController(text: widget.child['height'].toString());  // Convert double to string
    _weightController = TextEditingController(text: widget.child['weight'].toString());  // Convert double to string
    _allergiesController = TextEditingController(text: widget.child['allergies']);
    _bloodType = widget.child['bloodType'];
    _gender = widget.child['gender'];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _birthdateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'กรุณากรอกตัวเลข';
    }
    return null;
  }

  String? validateDouble(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    final n = double.tryParse(value);
    if (n == null) {
      return 'กรุณากรอกตัวเลข';
    }
    return null;
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      await _dbHelper.updateChild({
        'id': widget.child['id'],
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'nickname': _nicknameController.text,
        'birthdate': _birthdateController.text,
        'height': double.parse(_heightController.text),  // Convert string to double
        'weight': double.parse(_weightController.text),  // Convert string to double
        'bloodType': _bloodType,
        'allergies': _allergiesController.text,
        'gender': _gender,
      });
      Navigator.of(context).pop(true); // Return true to indicate update was successful
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลเด็ก'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'ชื่อ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'นามสกุล'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกนามสกุล';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'ชื่อเล่น'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อเล่น';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _birthdateController,
                decoration: const InputDecoration(
                  labelText: 'วันเกิด',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _birthdateController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกวันเกิด';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'ส่วนสูง (cm)',
                ),
                keyboardType: TextInputType.number,
                validator: validateDouble,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'น้ำหนัก (kg)',
                ),
                keyboardType: TextInputType.number,
                validator: validateDouble,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'กรุ๊ปเลือด',
                ),
                value: _bloodType,
                items: <String>[
                  'กรุ๊ปเลือด A',
                  'กรุ๊ปเลือด B',
                  'กรุ๊ปเลือด AB',
                  'กรุ๊ปเลือด O'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _bloodType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกกรุ๊ปเลือด';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                  labelText: 'การแพ้ยา',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกข้อมูลการแพ้ยา';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'เพศ',
                ),
                value: _gender,
                items: <String>['ชาย', 'หญิง'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกเพศ';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('บันทึกการเปลี่ยนแปลง'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ยกเลิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
