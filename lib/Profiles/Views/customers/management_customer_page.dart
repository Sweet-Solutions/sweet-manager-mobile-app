import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/Views/customers/add_customer.dart';
import 'edit_customer.dart';
import 'customer_model.dart';

class GestionClientesPage extends StatefulWidget {
  @override
  _GestionClientesPageState createState() => _GestionClientesPageState();
}

class _GestionClientesPageState extends State<GestionClientesPage> {
  Cliente? clienteSeleccionado;
  int rowsPerPage = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Clientes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarClientePage()),
              );
              if (result != null) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
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
                            Expanded(child: Text('DNI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Nombre', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Contacto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Acciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
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
                      source: _ClienteDataSource(context, showAccionesDialog, showDeleteConfirmation),
                    ),
                  ),
                ),
                Text(
                  'Mostrando ${clientes.length} clientes',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showAccionesDialog(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acciones para ${cliente.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarClientePage(cliente: cliente),
                    ),
                  );
                  if (result != null) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Text('Editar Cliente'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteConfirmation(context, cliente);
                },
                child: Text('Eliminar Cliente'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteConfirmation(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar al cliente ${cliente.nombre}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  clientes.remove(cliente);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cliente eliminado')));
              },
            ),
          ],
        );
      },
    );
  }
}

// DataSource para el PaginatedDataTable
class _ClienteDataSource extends DataTableSource {
  final BuildContext context;
  final Function(BuildContext, Cliente) showAccionesDialog;
  final Function(BuildContext, Cliente) showDeleteConfirmation;

  _ClienteDataSource(this.context, this.showAccionesDialog, this.showDeleteConfirmation);

  @override
  DataRow getRow(int index) {
    final cliente = clientes[index];
    return DataRow(
      cells: [
        DataCell(Text(cliente.dni), onTap: () {
          showAccionesDialog(context, cliente);
        }),
        DataCell(Text(cliente.nombre)),
        DataCell(Text(cliente.contacto)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                showAccionesDialog(context, cliente);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeleteConfirmation(context, cliente);
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clientes.length;

  @override
  int get selectedRowCount => 0;
}
