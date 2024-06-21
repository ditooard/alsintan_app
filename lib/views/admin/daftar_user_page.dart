import 'package:alsintan_app/views/admin/detail_user_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alsintan_app/models/user.dart';
import 'package:alsintan_app/services/myserverconfig.dart';

class DaftarUser extends StatefulWidget {
  @override
  State<DaftarUser> createState() => _DaftarUser();
}

class _DaftarUser extends State<DaftarUser> {
  List<User> userList = <User>[];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('access_token');

      if (savedToken == null) {
        throw Exception('No token found');
      }

      final uri = '${MyServerConfig.server}/admin/user-all';
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $savedToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] == null) {
          throw Exception('Data field is missing in the response');
        }

        final List<dynamic> userJson = data['data'];
        setState(() {
          userList = userJson.map((json) => User.fromJson(json)).toList();
        });
      } else {
        print('Failed to load users, status code: ${response.statusCode}');
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double lebarLayar = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 48,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Daftar User',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: userList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailUser(user: userList[index]),
                        ),
                      );
                    },
                    child: Container(
                      width: lebarLayar,
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
                                  userList[index].namaLengkap,
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
