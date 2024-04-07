import 'dart:io';
import 'package:myappproject/AdminPanel.dart';

import 'phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EmployeeData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(AddEmp());
}

class AddEmp extends StatelessWidget {
  final String apiUrl = 'http://localhost:3000/api/send_otp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AdminPanel(),
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
          title: Text('Add Employees'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: UserForm(),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  var mobileval = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _allowancesController = TextEditingController();
  final TextEditingController _deductionController = TextEditingController();
  final TextEditingController _advancesController = TextEditingController();

  final String _databaseUrl =
      'https://myappprojecthack-default-rtdb.firebaseio.com/employee.json';

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          } else if (value.length != 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _basicSalaryController,
                        decoration: InputDecoration(
                          labelText: 'Basic Salary',
                          prefixIcon: Icon(Icons.money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the basic salary';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _allowancesController,
                        decoration: InputDecoration(
                          labelText: 'Allowances',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the allowances';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _deductionController,
                        decoration: InputDecoration(
                          labelText: 'Deduction',
                          prefixIcon: Icon(Icons.money_off),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the deduction';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _advancesController,
                        decoration: InputDecoration(
                          labelText: 'Advances',
                          prefixIcon: Icon(Icons.arrow_upward),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the advances';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 18.0),
                          minimumSize: Size(double.infinity, 50.0),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            var email = _emailController.text;
                            var apiUrl =
                                'http://192.168.10.206:3000/api/send_otp/$email';
                            final response = await http.get(Uri.parse(apiUrl));
                            if (response.statusCode == 200) {
                              print("Otp sent successfully !!");
                            } else {
                              print(_emailController.text);
                              print("Failed to send the OTP !! ");
                            }

                            addEmployeeToDatabase();
                          }
                        },
                        child: Text('Add'),
                      ),
                      SizedBox(height: 10), // Added SizedBox for spacing
                      ElevatedButton(
                        // Button to view employee data
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 18.0),
                          minimumSize: Size(double.infinity, 50.0),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      EmpData(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                        child: Text('View Employees'), // Button text
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to validate email format
  bool isValidEmail(String? email) {
    if (email == null) return false;
    // Regular expression for validating email addresses
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Function to add employee data to Firebase Realtime Database
  void addEmployeeToDatabase() async {
    try {
      final response = await http.post(
        Uri.parse(_databaseUrl),
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'basicSalary': _basicSalaryController.text,
          'allowances': _allowancesController.text,
          'deduction': _deductionController.text,
          'advances': _advancesController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Data added successfully
        print('Employee data added to database');
        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _mobileController.clear();
        _basicSalaryController.clear();
        _allowancesController.clear();
        _deductionController.clear();
        _advancesController.clear();
        // Show dialog box with tick mark and "Employee Added !!" text
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                height: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Employee Added !!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            );
          },
        );
      } else {
        // Error occurred while adding data
        print(
            'Error adding employee data to database. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Exception occurred
      print('Error adding employee data to database: $error');
    }
  }
}
