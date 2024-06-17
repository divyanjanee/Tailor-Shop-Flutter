import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tailer_shop/Old/nav.dart';

class Pending_job extends StatefulWidget {
  const Pending_job({Key? key}) : super(key: key);

  @override
  _Pending_jobState createState() => _Pending_jobState();
}

class _Pending_jobState extends State<Pending_job> {
  List<dynamic> orderData = [];
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _updateJobStatus(String job_no) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/Tailer/job_status_update.php'),
      body: {'job_no': job_no},
    );

    if (response.statusCode == 200) {
      // Status updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job Completed Successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the data after updating
      fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job Completed Faild'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/Tailer/Pending_Job.php'));

    if (response.statusCode == 200) {
      setState(() {
        orderData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

bool isToday(String date) {
  DateTime today = DateTime.now();
  String formattedToday = DateFormat('yyyy-MM-dd').format(today);
  return date == formattedToday;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(3, 191, 203, 1),
                Color.fromRGBO(3, 191, 203, 1),
              ],
            ),
          ),
        ),
        title: Text('Pending Job'),
        actions: [
             Expanded(
            child: orderSearchBar(onSearch: (value) {
              setState(() {
                searchTerm = value;
              });
            }),
          ),
       
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile view
            return buildMobileView();
          } else {
            // Desktop view
            return buildDesktopView();
          }
        },
      ),
    );
  }

  Widget buildMobileView() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mobile Supplier View',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Scrollbar(
                        controller: ScrollController(),
                        trackVisibility: true,
                        child: DataTable(
                             columnSpacing: 50,
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromRGBO(3, 191, 203, 1),
                          ),
                          columns: [
                            DataColumn(
                                label: Text('Job ID',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Customer Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Phone\nNumber',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Order Date',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Delivery\nDate',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Delivery',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Price',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Discount',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Advance\nPayment',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Advance Payment\nMethod',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Total',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Status',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('Employee Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            DataColumn(
                                label: Text('',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                          ],
                          rows: orderData
                              .where((job_card) =>
                                  job_card['job_no']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['customerPhone']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['orderDate']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['dueDate']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['status']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['empName']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['job_status']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['paymentStatus']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()) ||
                                  job_card['customerName']
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()))
                              .map(
                                (job_card) => DataRow(
                                    color: isToday(job_card['dueDate'])
              ? MaterialStateProperty.all<Color>(
                  Color.fromRGBO(247, 1, 1, 0.294)) // Adjust the highlight color
              : MaterialStateProperty.all<Color>(Colors.transparent),
                                  cells: [
                                    DataCell(Text('${job_card['job_no']}')),
                                    DataCell(
                                        Text('${job_card['customerName']}')),
                                    DataCell(
                                        Text('${job_card['customerPhone']}')),
                                    DataCell(Text('${job_card['orderDate']}')),
                                    DataCell(Text('${job_card['dueDate']}')),
                                    DataCell(
                                      Container(
                                        width: 80,
                                        height: 30,
                                        color: _getColorForStatus(
                                            job_card['status']),
                                        child: Text(
                                          '${job_card['status']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                        Text('${job_card['total_price']}')),
                                    DataCell(Text('${job_card['discount']}')),
                                    DataCell(Text('${job_card['advance']}')),
                                    DataCell(
                                        Text('${job_card['paymentStatus']}')),
                                    DataCell(Text('${job_card['amount']}')),
                                    DataCell(
                                      Container(
                                        width: 80,
                                        height: 30,
                                        color: _getColorForStatus(
                                            job_card['job_status']),
                                        child: Text(
                                          '${job_card['job_status']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text('${job_card['empName']}')),
                                    DataCell(
                                      Container(
                                        width: 100,
                                        height: 35,
                                        child: TextButton(
                                          onPressed: () {
                                            _updateJobStatus(
                                                '${job_card['job_no']}');
                                          }, style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color.fromRGBO(15, 128, 4, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Finish Job',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return Color.fromARGB(255, 201, 138, 4);
      case 'Complete':
        return Color.fromARGB(255, 3, 119, 30);
      case 'Failed':
        return const Color.fromARGB(255, 248, 17, 1);
      case 'Processing':
        return Color.fromARGB(255, 1, 67, 248);
      case 'On Hold':
        return Color.fromARGB(255, 4, 76, 134);
      default:
        return Colors.white;
    }
  }
}


class orderSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const orderSearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 1300, right: 30, bottom: 10),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: TextField(
          style: TextStyle(
            backgroundColor: Color.fromARGB(255, 139, 172, 214),
          ),
          onChanged: onSearch,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromRGBO(3, 191, 203, 1),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
          ),
        ),
      ),
    );
  }
}

