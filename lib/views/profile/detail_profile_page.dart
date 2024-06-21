import 'dart:convert';

import 'package:alsintan_app/models/profile.dart';
import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailProfile extends StatefulWidget {
  @override
  State<DetailProfile> createState() => _DetailProfile();
}

class _DetailProfile extends State<DetailProfile> {
  TextEditingController namaLengkapController = TextEditingController();
  TextEditingController nomorHpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  late int userId;
  late String role;

  @override
  void initState() {
    super.initState();
    loadProfileData();
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id') ?? 0;
      role = prefs.getString('role') ?? '';
    });
  }


  Future<void> loadProfileData() async {
    final url = '${MyServerConfig.server}/pengguna/user';
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('access_token');

    if (savedToken == null) {
      print('No token found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $savedToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final profileData = Profile.fromJson(responseData['data']);

        setState(() {
          namaLengkapController.text = profileData.namaLengkap;
          nomorHpController.text = profileData.noHp;
          alamatController.text = profileData.alamat; 
          userId = profileData.id;
          role = profileData.role;
        });
      } else {
        print('Failed to load profile data: ${response.body}');
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future<void> updateProfile() async {
    final url = role == 'admin'
        ? '${MyServerConfig.server}/admin/update-user/$userId'
        : '${MyServerConfig.server}/pengguna/update-user/$userId';

    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('access_token');

    if (savedToken == null) {
      print('No token found');
      return;
    }

    final body = jsonEncode(<String, String>{
      'nama_lengkap': namaLengkapController.text,
      'no_hp': nomorHpController.text,
      'alamat': alamatController.text,
    });

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $savedToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Update successful
      print('Profile updated successfully');
      print(response.body);
      // Optionally, update local SharedPreferences here if needed
    } else {
      // Error in updating profile
      print('Failed to update profile: ${response.body}');
      // Handle error accordingly
    }
  }

  @override
  void dispose() {
    namaLengkapController.dispose();
    nomorHpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double lebarLayar = MediaQuery.of(context).size.width;
    double tinggiLayar = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: lebarLayar,
          height: tinggiLayar,
          padding: const EdgeInsets.only(top: 20),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 393,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(color: Colors.white),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          child: Stack(
                                            children: [
                                              Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.black,
                                              ),
                                            ],
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
                      'Data Pribadi',
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
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 375,
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'Nama Lengkap',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFDBD7EC)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: namaLengkapController,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 375,
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'Nomor Handphone',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFDBD7EC)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: nomorHpController,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 375,
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'Alamat',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 81,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 81,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFDBD7EC)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: alamatController,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: 500,
                      height: 50.57,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          updateProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF31C48D), // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.87),
                          child: Text(
                            'Simpan !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
