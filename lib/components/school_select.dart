import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchoolDropdown extends StatefulWidget {
  final Future<QuerySnapshot<Map<String, dynamic>>> futureSchools;
  final ValueChanged<String?> onSchoolSelected;
  final ValueChanged<String?> onFacultySelected;
  final ValueChanged<String?> onFieldSelected;

  SchoolDropdown({
    required this.futureSchools,
    required this.onSchoolSelected,
    required this.onFacultySelected,
    required this.onFieldSelected,
  });

  @override
  _SchoolDropdownState createState() => _SchoolDropdownState();
}

class _SchoolDropdownState extends State<SchoolDropdown> {
  String? _selectedSchool;
  String? _selectedField;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: widget.futureSchools,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DocumentSnapshot<Map<String, dynamic>>> schoolDocs =
              snapshot.data!.docs;
          return Column(
            children: [
              DropdownButton<String>(
                value: _selectedSchool,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSchool = newValue;
                    _selectedField = null;
                    _selectedValue = null;
                  });
                  widget.onSchoolSelected(_selectedSchool);
                },
                items: schoolDocs.map<DropdownMenuItem<String>>((doc) {
                  return DropdownMenuItem<String>(
                    value: doc.id,
                    child: Text(doc.id),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _selectedField,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedField = newValue;
                    _selectedValue = null;
                  });
                  widget.onFacultySelected(_selectedField);
                  // print(_selectedSchool);
                },
                items: (_selectedSchool != null &&
                            schoolDocs.any((doc) => doc.id == _selectedSchool)
                        ? schoolDocs
                            .firstWhere((doc) => doc.id == _selectedSchool)
                            .data()!
                            .keys
                        : <String>[])
                    .map<DropdownMenuItem<String>>((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
              ),
              if (_selectedField != null)
                DropdownButton<String>(
                  value: _selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue;
                    });
                    widget.onFieldSelected(_selectedValue);
                  },
                  items: (schoolDocs
                          .firstWhere((doc) => doc.id == _selectedSchool)
                          .data()![_selectedField] as List<dynamic>)
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
            ],
          );
        }
      },
    );
  }
}
