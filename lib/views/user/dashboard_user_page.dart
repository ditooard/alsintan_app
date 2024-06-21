import 'package:alsintan_app/views/detail_alsintan_page.dart';
import 'package:flutter/material.dart';
import 'package:alsintan_app/models/alsinta.dart';
import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:alsintan_app/views/user/tambah_alsintan_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardUser extends StatefulWidget {
  @override
  State<DashboardUser> createState() => _DashboardUser();
}

class _DashboardUser extends State<DashboardUser> {
  List<Alsinta> alsintaList = <Alsinta>[];
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadAlsintas();
  }

  bool isSearchVisible = false;
  int axiscount = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Text('Alat dan Mesin Pertanian'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await refreshAlsintas();
        },
        child: alsintaList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(alsintaList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailAlsintan(
                                      alsinta: alsintaList[index]),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    width: screenWidth,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                      alsintaList[index].image,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        truncateString(alsintaList[index].merk),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahAlsintan()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF31C48D),
      ),
    );
  }

  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return str + "...";
    } else {
      return str;
    }
  }

  Future<void> refreshAlsintas() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      loadAlsintas();
    });
  }

  Future<void> loadAlsintas() async {
    Center(child: CircularProgressIndicator());
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('access_token');

      if (savedToken == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('${MyServerConfig.server}/pengguna/alsinta'),
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
      } else {
        print('Failed to load alsintas, status code: ${response.statusCode}');
        throw Exception('Failed to load alsintas');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load alsintas');
    }
  }
}
