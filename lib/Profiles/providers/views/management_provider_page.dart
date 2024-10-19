import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/providers/views/add_provider.dart';
import 'package:sweetmanager/Profiles/providers/views/edit_provider.dart';
import 'package:sweetmanager/Profiles/providers/models/provider_model.dart';

class ManageProvidersPage extends StatefulWidget {
  final String role; // Add user role

  ManageProvidersPage({required this.role}); // Constructor that receives the role

  @override
  _ManageProvidersPageState createState() => _ManageProvidersPageState();
}

class _ManageProvidersPageState extends State<ManageProvidersPage> {
  Provider? selectedProvider;
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
              'Manage Providers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
                        Expanded(child: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        Expanded(child: Text('Contact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        Expanded(child: Text('Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        Expanded(child: Text('Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
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
                  source: _ProviderDataSource(context, showActionsDialog, showDeleteConfirmation, widget.role),
                ),
              ),
            ),
            Text(
              'Showing ${providers.length} providers',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Check if the user has the owner role before allowing to add providers
            if (widget.role == 'ROLE_OWNER')
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProviderPage(role: widget.role)),
                  );
                  if (result != null) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Text('Add Provider'),
              ),
          ],
        ),
      ),
    );
  }

  void showActionsDialog(BuildContext context, Provider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actions for ${provider.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Check if the user has the owner role before allowing to edit the provider
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
                        builder: (context) => EditProviderPage(provider: provider, role: widget.role),
                      ),
                    );
                    if (result != null) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                    }
                  },
                  child: Text('Edit Provider'),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteConfirmation(context, provider);
                },
                child: Text('Delete Provider'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteConfirmation(BuildContext context, Provider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete the provider ${provider.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  providers.remove(provider);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Provider deleted')));
              },
            ),
          ],
        );
      },
    );
  }
}

// DataSource for the PaginatedDataTable
class _ProviderDataSource extends DataTableSource {
  final BuildContext context;
  final Function(BuildContext, Provider) showActionsDialog;
  final Function(BuildContext, Provider) showDeleteConfirmation;
  final String role; // Add user role

  _ProviderDataSource(this.context, this.showActionsDialog, this.showDeleteConfirmation, this.role);

  @override
  DataRow getRow(int index) {
    final provider = providers[index];
    return DataRow(
      cells: [
        DataCell(Text(provider.name), onTap: () {
          showActionsDialog(context, provider);
        }),
        DataCell(Text(provider.contact)),
        DataCell(Text(provider.address)),
        DataCell(Text(provider.product)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => providers.length;

  @override
  int get selectedRowCount => 0;
}
