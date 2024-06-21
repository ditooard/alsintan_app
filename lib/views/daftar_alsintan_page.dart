import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alsintan_app/models/alsinta.dart';
import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:alsintan_app/views/detail_alsintan_page.dart';

class DaftarAlsintan extends StatefulWidget {
  @override
  State<DaftarAlsintan> createState() => _DaftarAlsintan();
}

class _DaftarAlsintan extends State<DaftarAlsintan> {
  List<Alsinta> alsintaList = <Alsinta>[];

  @override
  void initState() {
    super.initState();
    loadAlsintas();
  }

  Future<void> loadAlsintas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('access_token');
      final role = prefs.getString('role');

      if (savedToken == null) {
        throw Exception('No token found');
      }

      if (role == null) {
        throw Exception('No role found');
      }

      final uri = role == 'admin'
          ? '${MyServerConfig.server}/admin/alsinta-all'
          : '${MyServerConfig.server}/pengguna/alsinta';

      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $savedToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> alsintaJson = data['data'];
        setState(() {
          alsintaList =
              alsintaJson.map((json) => Alsinta.fromJson(json)).toList();
        });

        print(response.body);
      } else {
        print('Failed to load alsintas, status code: ${response.statusCode}');
        throw Exception('Failed to load alsintas');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load alsintas: $e');
    }
  }

  Future<void> deleteAlsintan(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('access_token');

      if (savedToken == null) {
        throw Exception('No token found');
      }

      final response = await http.delete(
        Uri.parse('${MyServerConfig.server}/pengguna/delete-alsintan/$id'),
        headers: {
          'Authorization': 'Bearer $savedToken',
        },
      );

      if (response.statusCode == 200) {
        // Remove the deleted item from the local list
        setState(() {
          alsintaList.removeWhere((alsinta) => alsinta.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alsintan successfully deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Failed to delete alsintan, status code: ${response.statusCode}');
        throw Exception('Failed to delete alsintan');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to delete alsintan');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Text('Daftar Alsintan'),
        ),
      ),
      body: SafeArea(
        child: alsintaList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: alsintaList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailAlsintan(alsinta: alsintaList[index]),
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        border: Border.all(
                          color: Color(0xFFF4F4F4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alsintaList[index].merk,
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(Icons.qr_code),
                            onPressed: () {
                              // QR code button action
                            },
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Alsintan"),
                                    content: Text(
                                        "Are you sure you want to delete this Alsintan?"),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed: () {
                                          deleteAlsintan(alsintaList[index].id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
