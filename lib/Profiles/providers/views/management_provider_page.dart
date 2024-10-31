import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'add_provider.dart';
import 'edit_provider.dart';
import 'package:sweetmanager/Profiles/providers/views/paymentscreen.dart';
import 'package:sweetmanager/Profiles/providers/models/provider_model.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class ManageProvidersPage extends StatefulWidget {
  @override
  _ManageProvidersPageState createState() => _ManageProvidersPageState();
}

class _ManageProvidersPageState extends State<ManageProvidersPage> {
  Provider? selectedProvider;
  int rowsPerPage = 4;
  final storage = const FlutterSecureStorage();
  String? role;
  List<Provider> providers = []; // Inicializa tu lista de proveedores

  Future<String?> _getRole() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  void _loadRole() async {
    String? userRole = await _getRole();
    setState(() {
      role = userRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return role == null
        ? const Center(child: CircularProgressIndicator())
        : BaseLayout(
      role: role!,
      childScreen: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Providers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: PaginatedDataTable(
                    header: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), // Reduzco el padding
                      color: Color(0xFF494E74),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Expanded(child: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          Expanded(child: Text('Contact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          Expanded(child: Text('Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          Expanded(child: Text('Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                        ],
                      ),
                    ),
                    columnSpacing: 5,
                    dataRowMinHeight: 40,
                    rowsPerPage: rowsPerPage,
                    availableRowsPerPage: const [4],
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    source: _ProviderDataSource(context, showActionsDialog, showDeleteConfirmation, role!),
                  ),
                ),
              ),
              Text(
                'Showing ${providers.length} providers',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  if (role == 'ROLE_OWNER')
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddProviderPage(role: role!)),
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
            ],
          ),
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
              if (role == 'ROLE_OWNER')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProviderPage(provider: provider, role: role!),
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
  final String role;

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
        DataCell(
          Row(
            children: [
              Text(provider.product),
              IconButton(
                icon: Icon(Icons.money, color: Colors.green), // Icono de dinero junto al producto
                onPressed: () {
                  // Al hacer clic en el ícono, navega a la pantalla de pago
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
              ),
            ],
          ),
        ),
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
