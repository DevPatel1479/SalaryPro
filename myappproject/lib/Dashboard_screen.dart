import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:myappproject/AdminPanel.dart';

class Dash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Map<String, dynamic>> employees = []; // List to store employee data

  @override
  void initState() {
    super.initState();
    fetchEmployeeData(); // Fetch employee data when the widget initializes
  }

  Future<void> fetchEmployeeData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://myappprojecthack-default-rtdb.firebaseio.com/employee.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          employees = data.values.toList().cast<Map<String, dynamic>>();
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
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: CustomPieChart(employees: employees),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(color: Colors.blue, label: 'Basic Salary'),
                  SizedBox(height: 8),
                  _buildLegendItem(color: Colors.green, label: 'Allowances'),
                  SizedBox(height: 8),
                  _buildLegendItem(color: Colors.red, label: 'Deduction'),
                  SizedBox(height: 8),
                  _buildLegendItem(color: Colors.orange, label: 'Advances'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8.0), // Add padding from the bottom
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> employees;

  const CustomPieChart({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalBasicSalary = employees.fold<double>(
        0, (prev, elem) => prev + double.parse(elem['basicSalary']));
    final totalAllowances = employees.fold<double>(
        0, (prev, elem) => prev + double.parse(elem['allowances']));
    final totalDeduction = employees.fold<double>(
        0, (prev, elem) => prev + double.parse(elem['deduction']));
    final totalAdvances = employees.fold<double>(
        0, (prev, elem) => prev + double.parse(elem['advances']));

    final List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        color: Colors.blue,
        value: totalBasicSalary > 0
            ? totalBasicSalary
            : 0.001, // Ensure value is greater than zero
        radius: 80,
        title:
            '${((totalBasicSalary / (totalBasicSalary + totalAllowances + totalDeduction + totalAdvances)) * 100).toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        color: Colors.green,
        value: totalAllowances > 0
            ? totalAllowances
            : 0.001, // Ensure value is greater than zero
        radius: 100,
        title:
            '${((totalAllowances / (totalBasicSalary + totalAllowances + totalDeduction + totalAdvances)) * 100).toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        color: Colors.red,
        value: totalDeduction > 0
            ? totalDeduction
            : 0.001, // Ensure value is greater than zero
        radius: 120,
        title:
            '${((totalDeduction / (totalBasicSalary + totalAllowances + totalDeduction + totalAdvances)) * 100).toStringAsFixed(1)}%',
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: totalAdvances > 0
            ? totalAdvances
            : 0.001, // Ensure value is greater than zero
        radius: 140,
        title:
            '${((totalAdvances / (totalBasicSalary + totalAllowances + totalDeduction + totalAdvances)) * 100).toStringAsFixed(1)}%',
      ),
    ];

    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: pieChartData,
          borderData: FlBorderData(
            show: false,
          ),
          centerSpaceRadius: 30,
          sectionsSpace: 0,
          pieTouchData: PieTouchData(enabled: true),
        ),
      ),
    );
  }
}

void main() {
  runApp(Dash());
}
