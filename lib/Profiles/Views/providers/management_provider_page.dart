import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/Views/providers/add_provider.dart';
import 'edit_provider.dart';
import 'provider_model.dart';

class GestionProveedoresPage extends StatefulWidget {
  @override
  _GestionProveedoresPageState createState() => _GestionProveedoresPageState();
}

class _GestionProveedoresPageState extends State<GestionProveedoresPage> {
  Proveedor? proveedorSeleccionado;
  int rowsPerPage = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Proveedores'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarProveedorPage()),
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
                        width: double.infinity,  // Hace que el contenedor ocupe todo el ancho
                        padding: const EdgeInsets.symmetric(vertical: 4.0), // Ajusta el padding aquí
                        color: Color(0xFF494E74),  // Color de fondo para el encabezado
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(child: Text('Nombre', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Contacto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Dirección', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Producto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            Expanded(child: Text('Acciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                          ],
                        ),
                      ),
                      columnSpacing: 5,
                      dataRowHeight: 40, // Ajustar el alto de la fila de datos
                      rowsPerPage: rowsPerPage,  // 4 proveedores por página
                      availableRowsPerPage: [4],  // Número fijo de filas por página
                      columns: [
                        DataColumn(label: Text('')), // Para el título de nombre
                        DataColumn(label: Text('')), // Para el título de contacto
                        DataColumn(label: Text('')), // Para el título de dirección
                        DataColumn(label: Text('')), // Para el título de producto
                        DataColumn(label: Text('')), // Para el título de acciones
                      ],
                      source: _ProveedorDataSource(context, showAccionesDialog, showDeleteConfirmation),
                    ),
                  ),
                ),
                Text(
                  'Mostrando ${proveedores.length} proveedores',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showAccionesDialog(BuildContext context, Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acciones para ${proveedor.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  Navigator.pop(context); // Cierra el diálogo
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarProveedorPage(proveedor: proveedor),
                    ),
                  );
                  if (result != null) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  }
                },
                child: Text('Editar Proveedor'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  showDeleteConfirmation(context, proveedor);
                },
                child: Text('Eliminar Proveedor'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteConfirmation(BuildContext context, Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar al proveedor ${proveedor.nombre}?'),
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
                  proveedores.remove(proveedor);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Proveedor eliminado')));
              },
            ),
          ],
        );
      },
    );
  }
}

// DataSource para el PaginatedDataTable
class _ProveedorDataSource extends DataTableSource {
  final BuildContext context;
  final Function(BuildContext, Proveedor) showAccionesDialog;
  final Function(BuildContext, Proveedor) showDeleteConfirmation;

  _ProveedorDataSource(this.context, this.showAccionesDialog, this.showDeleteConfirmation);

  @override
  DataRow getRow(int index) {
    final proveedor = proveedores[index];
    return DataRow(
      cells: [
        DataCell(Text(proveedor.nombre), onTap: () {
          showAccionesDialog(context, proveedor);
        }),
        DataCell(Text(proveedor.contacto)),
        DataCell(Text(proveedor.direccion)),
        DataCell(Text(proveedor.producto)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                showAccionesDialog(context, proveedor);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeleteConfirmation(context, proveedor);
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
  int get rowCount => proveedores.length;

  @override
  int get selectedRowCount => 0;
}
