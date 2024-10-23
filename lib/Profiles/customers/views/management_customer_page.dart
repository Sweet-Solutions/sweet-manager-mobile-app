import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/customers/views/add_customer.dart';
import 'package:sweetmanager/Profiles/customers/views/edit_customer.dart';
import 'package:sweetmanager/Profiles/customers/models/customer_model.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

@override
Widget build(BuildContext context) { // Implements design for login view.
  return BaseLayout(role: '', childScreen: ManageCustomersPage(role: 'ROLE_OWNER'));
}

class ManageCustomersPage extends StatefulWidget {
  final String role; // Add user role

  ManageCustomersPage({required this.role}); // Constructor

  @override
  _ManageCustomersPageState createState() => _ManageCustomersPageState();
}

class _ManageCustomersPageState extends State<ManageCustomersPage> {
  Customer? selectedCustomer;
  int rowsPerPage = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Text(
              'Manage Customers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Space between title and table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: PaginatedDataTable(
                  header: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    color: Color(0xFF494E74),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: Text('ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        Expanded(child: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        Expanded(child: Text('Contact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        Expanded(child: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                      ],
                    ),
                  ),
                  columnSpacing: 5,
                  dataRowHeight: 40,
                  rowsPerPage: rowsPerPage,
                  availableRowsPerPage: [4],
                  columns: [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  source: _CustomerDataSource(context, showActionsDialog, widget.role),
                ),
              ),
            ),
            Text(
              'Showing ${customers.length} customers',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Check role to show the add customer button
            if (widget.role == 'ROLE_OWNER')
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCustomerPage(role: widget.role)),
                  );
                  if (result != null) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Text('Add Customer'),
              ),
          ],
        ),
      ),
    );
  }

  void showActionsDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actions for ${customer.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show edit button only if the role is 'ROLE_OWNER'
              if (widget.role == 'ROLE_OWNER')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCustomerPage(customer: customer, role: widget.role), // Pass the role
                      ),
                    );
                    if (result != null) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                    }
                  },
                  child: Text('Edit Customer'),
                ),
            ],
          ),
        );
      },
    );
  }
}

// DataSource for the PaginatedDataTable
class _CustomerDataSource extends DataTableSource {
  final BuildContext context;
  final Function(BuildContext, Customer) showActionsDialog;
  final String role;

  _CustomerDataSource(this.context, this.showActionsDialog, this.role);

  @override
  DataRow getRow(int index) {
    final customer = customers[index];
    return DataRow(
      cells: [
        DataCell(Text(customer.idNumber), onTap: () {
          showActionsDialog(context, customer);
        }),
        DataCell(Text(customer.name), onTap: () {
          showActionsDialog(context, customer);
        }),
        DataCell(Text(customer.contact)),
        DataCell(Row(
          children: [
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customers.length;

  @override
  int get selectedRowCount => 0;
}
