import 'package:flutter/material.dart';
import 'package:sweetmanager/Profiles/providers/models/provider_model.dart';
import 'package:sweetmanager/Profiles/providers/views/add_provider.dart';
import 'package:sweetmanager/Profiles/providers/views/edit_provider.dart';
import 'package:sweetmanager/Profiles/providers/services/providerservices.dart';
import 'package:sweetmanager/IAM/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class ProvidersManagement extends StatefulWidget {
  const ProvidersManagement({super.key});

  @override
  State<ProvidersManagement> createState() => _ProvidersManagement();
}

class _ProvidersManagement extends State<ProvidersManagement> {
  late ProviderService _providerService;
  late AuthService _authService;
  final storage = const FlutterSecureStorage();
  List<Provider> providers = [];
  bool isLoading = true;
  int? hotelId;
  String? role;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _providerService = ProviderService('https://sweetmanager-api.ryzeon.me');
    _loadHotelId();
  }

  Future<void> _loadHotelId() async {
    hotelId = await _getHotelId();
    if (hotelId != null) {
      await _fetchProviders();
    } else {
      setState(() => isLoading = false);
      _showSnackBar('Hotel ID not found');
    }
  }

  Future<String?> _getRole() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString();
    }
    return null;
  }

  Future<int?> _getHotelId() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String? locality = decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality'];
      return locality != null ? int.tryParse(locality) : null;
    }
    return null;
  }

  Future<void> _fetchProviders() async {
    if (hotelId == null) return;

    try {
      List<dynamic> fetchedProviders = await _providerService.getProvidersByHotelId(hotelId!);
      setState(() {
        providers = fetchedProviders.map((data) => Provider.fromJson(data)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Failed to load providers: $e');
    }
  }

  Future<void> _addProvider() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProviderAddScreen()),
    );

    if (result == true) {
      _fetchProviders();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading role'));
        }

        role = snapshot.data;

        return BaseLayout(
          role: role,
          childScreen: Scaffold(
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildProvidersTable(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Providers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProvidersTable() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
              return const Color(0xFF474C74);
            }),
            dataRowColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.grey.withOpacity(0.5);
              }
              return Colors.white;
            }),
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'ID',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Name',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Address',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Actions',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: providers.map((provider) {
              return DataRow(
                cells: [
                  DataCell(Text(provider.id.toString())),
                  DataCell(Text(provider.name)),
                  DataCell(Text(provider.address)),
                  DataCell(
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProviderEditScreen(provider: provider),
                              ),
                            );
                            if (result == true) {
                              _fetchProviders();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF474C74),
                          ),
                          child: const Text('Edit', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
