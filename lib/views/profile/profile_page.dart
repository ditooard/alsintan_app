import 'dart:convert';

import 'package:alsintan_app/models/profile.dart';
import 'package:alsintan_app/services/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:alsintan_app/models/font.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilPage();
}

class _ProfilPage extends State<ProfilePage> {
  Profile? profile;

  @override
  void initState() {
    super.initState();
    loadProfileData();
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
        setState(() {
          profile = Profile.fromJson(responseData['data']);
        });
      } else {
        print('Failed to load profile data: ${response.body}');
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_type');
    await prefs.remove('acces_token');
    await prefs.remove('nama_lengkap');
    await prefs.remove('no_hp');
    await prefs.remove('alamat');
    await prefs.remove('role');
    await prefs.remove('id');
    print('Token dihapus.');

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    double lebarLayar = MediaQuery.of(context).size.width;
    double tinggiLayar = MediaQuery.of(context).size.height;
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10),
          child: Text('Profile'),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: lebarLayar,
            height: 730,
            padding: const EdgeInsets.only(top: 20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 380,
                  height: 96,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 72,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF31C48D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${profile?.namaLengkap?[0] ?? ""}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 38.40,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          '${profile?.namaLengkap ?? ""}',
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/detailProfile');
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        24 * fem, 16 * fem, 24 * fem, 350 * fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 0 * fem),
                          padding: EdgeInsets.fromLTRB(
                              12 * fem, 12 * fem, 12 * fem, 12 * fem),
                          width: double.infinity,
                          height: 48 * fem,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8 * fem),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x19000000),
                                offset: Offset(0 * fem, 0 * fem),
                                blurRadius: 10.5 * fem,
                              ),
                            ],
                          ),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 8 * fem, 0 * fem),
                                  width: 24 * fem,
                                  height: 24 * fem,
                                  child: Image.asset(
                                    'assets/images/profile-circle.png',
                                    color: Color(
                                        0xff31C48D), // Gantilah dengan warna yang sesuai
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 4 * fem, 0 * fem, 3.5 * fem),
                                  height: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0 * fem,
                                            0.5 * fem, 190 * fem, 0 * fem),
                                        child: Text(
                                          'Data Pribadi',
                                          style: SafeGoogleFont(
                                            'Plus Jakarta Sans',
                                            fontSize: 12 * ffem,
                                            fontWeight: FontWeight.w500,
                                            height: 1.26 * ffem / fem,
                                            letterSpacing: -0.25 * fem,
                                            color: Color(0xff818181),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0 * fem,
                                            0 * fem, 0 * fem, 0.5 * fem),
                                        width: 16 * fem,
                                        height: 16 * fem,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xff31C48D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      24 * fem, 0 * fem, 24 * fem, 52 * fem),
                  width: double.infinity,
                  height: 110 * fem,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 74, 74).withOpacity(0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: 247 * fem,
                              height: 155 *
                                  fem, // Menambahkan tinggi agar dialog lebih proporsional
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(8 * fem),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 0 * fem, 14.4 * fem),
                                    width: 58.8 * fem,
                                    height: 55.2 * fem,
                                    child: Image.asset(
                                      'assets/images/alert.png',
                                      width: 58.8 * fem,
                                      height: 55.2 * fem,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem,
                                        0 * fem,
                                        0 * fem,
                                        10 * fem), // Memberi margin ke teks
                                    constraints: BoxConstraints(
                                      maxWidth: 197 * fem,
                                    ),
                                    child: Text(
                                      'Anda yakin ingin keluar dari akun anda ?',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Plus Jakarta Sans',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1 * ffem / fem,
                                        color: Color(0xff333333),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 25,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: Color(0xFF999999),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Tidak',
                                                style: TextStyle(
                                                  color: Color(0xFF999999),
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _logout(context);
                                        },
                                        child: Container(
                                          width: 97.50,
                                          height: 25,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: ShapeDecoration(
                                            color: Color(0xffFF9C20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Iya',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * fem),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0 * fem),
                      shadowColor: Colors.black,
                      elevation: 1,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                20 * fem, 1 * fem, 167 * fem, 0 * fem),
                            child: Text(
                              'Keluar Akun',
                              style: SafeGoogleFont(
                                'Plus Jakarta Sans',
                                fontSize: 16 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.26 * ffem / fem,
                                color: Color(0xff31C48D),
                              ),
                            ),
                          ),
                          Container(
                            width: 24 * fem,
                            height: 24 * fem,
                            child: Image.asset(
                              'assets/images/logout.png',
                              color: Color(
                                  0xff31C48D), // Gantilah dengan warna yang sesuai
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
