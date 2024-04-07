import 'package:flutter/material.dart';
import 'AdminLogin.dart';
import 'EmployeeLogin.dart';

void main() {
  runApp(MyHomeApp());
}

class MyHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeApk(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomeApk extends StatefulWidget {
  @override
  _MyHomeApkState createState() => _MyHomeApkState();
}

class _MyHomeApkState extends State<MyHomeApk> {
  bool _isAdminButtonPressed = false;
  bool _isEmployeeButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/homescreen.jpeg'),
            SizedBox(height: 20.0),
            Container(
              width: 250.0, // Set the width of the buttons
              height: 60.0, // Set the height of the buttons
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  begin:
                      Alignment.topLeft, // Start gradient from top-left corner
                  end: Alignment
                      .bottomRight, // End gradient at bottom-right corner
                  colors: [
                    Colors.blue.withOpacity(0.8), // Start color
                    Colors.blue.withOpacity(0.4), // End color
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isAdminButtonPressed = !_isAdminButtonPressed;
                  });
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Adminlogin(),
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Increased border radius
                  ),
                  elevation:
                      0, // Remove elevation to maintain the gradient effect
                  primary: Colors
                      .transparent, // Make button transparent to show gradient
                ),
                icon: Icon(Icons.admin_panel_settings),
                label: Text(
                  'Login as Admin',
                  style: TextStyle(
                    fontSize: 18.0, // Increased font size
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors
                        .white, // Set text color to contrast with the gradient
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: 250.0, // Set the width of the buttons
              height: 60.0, // Set the height of the buttons
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  begin:
                      Alignment.topLeft, // Start gradient from top-left corner
                  end: Alignment
                      .bottomRight, // End gradient at bottom-right corner
                  colors: [
                    Colors.blue.withOpacity(0.8), // Start color
                    Colors.blue.withOpacity(0.4), // End color
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isEmployeeButtonPressed = !_isEmployeeButtonPressed;
                  });
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          EmployeeLogin(),
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

                  // Add your employee login logic here
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Increased border radius
                  ),
                  elevation:
                      0, // Remove elevation to maintain the gradient effect
                  primary: Colors
                      .transparent, // Make button transparent to show gradient
                ),
                icon: Icon(Icons.person),
                label: Text(
                  'Login as Employee',
                  style: TextStyle(
                    fontSize: 18.0, // Increased font size
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors
                        .white, // Set text color to contrast with the gradient
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
