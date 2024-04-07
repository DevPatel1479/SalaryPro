import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myappproject/AddEmployee.dart';
import 'package:myappproject/home.dart';

class EmpData extends StatefulWidget {
  @override
  _EmpDataState createState() => _EmpDataState();
}

class _EmpDataState extends State<EmpData> {
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  Future<void> fetchEmployeeData() async {
    final String url =
        'https://myappprojecthack-default-rtdb.firebaseio.com/employee.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedEmployees =
            data.values.toList().cast<Map<String, dynamic>>();

        // Add 'id' field to each employee record
        fetchedEmployees.forEach((employee) {
          employee['id'] =
              data.keys.toList()[fetchedEmployees.indexOf(employee)];
        });

        setState(() {
          employees = fetchedEmployees;
        });
      } else {
        throw Exception('Failed to fetch employee data');
      }
    } catch (error) {
      print('Error fetching employee data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AddEmp(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        title: Text('Employee Data'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          final bool isFirstRecord = index == 0;

          return ListTile(
            tileColor: isFirstRecord ? Colors.grey[200] : null,
            onTap: () {
              _navigateToEmployeeDetails(context, employee);
            },
            title: Text(
              employee['name'],
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              'Email: ${employee['email']}',
              style: TextStyle(fontSize: 14.0),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
          );
        },
      ),
    );
  }

  void _navigateToEmployeeDetails(
      BuildContext context, Map<String, dynamic> employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmployeeDetails(employee: employee)),
    );
  }
}

class EmployeeDetails extends StatefulWidget {
  final Map<String, dynamic> employee;

  const EmployeeDetails({Key? key, required this.employee}) : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _basicSalaryController;
  late TextEditingController _allowancesController;
  late TextEditingController _deductionController;
  late TextEditingController _advancesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee['name']);
    _emailController = TextEditingController(text: widget.employee['email']);
    _mobileController = TextEditingController(text: widget.employee['mobile']);
    _basicSalaryController =
        TextEditingController(text: widget.employee['basicSalary']);
    _allowancesController =
        TextEditingController(text: widget.employee['allowances']);
    _deductionController =
        TextEditingController(text: widget.employee['deduction']);
    _advancesController =
        TextEditingController(text: widget.employee['advances']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveEmployeeDetails(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Email', _emailController),
            _buildTextField('Mobile', _mobileController),
            _buildTextField('Basic Salary', _basicSalaryController),
            _buildTextField('Allowances', _allowancesController),
            _buildTextField('Deduction', _deductionController),
            _buildTextField('Advances', _advancesController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16.0)),
          TextFormField(
            controller: controller,
          ),
        ],
      ),
    );
  }

  void _saveEmployeeDetails(BuildContext context) async {
    final String url =
        'https://myappprojecthack-default-rtdb.firebaseio.com/employee/${widget.employee['id']}.json';

    try {
      final response = await http.patch(Uri.parse(url),
          body: jsonEncode({
            'name': _nameController.text,
            'email': _emailController.text,
            'mobile': _mobileController.text,
            'basicSalary': _basicSalaryController.text,
            'allowances': _allowancesController.text,
            'deduction': _deductionController.text,
            'advances': _advancesController.text,
          }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee details saved successfully')),
        );
      } else {
        throw Exception('Failed to save employee details');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving employee details: $error')),
      );
    }
  }
}
