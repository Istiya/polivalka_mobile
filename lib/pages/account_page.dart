import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polivalka/custom%20widgets/background_picture.dart';
import 'package:polivalka/custom%20widgets/change_user_data_button.dart';
import 'package:polivalka/custom%20widgets/create_new_family_button.dart';
import 'package:polivalka/custom%20widgets/custom_image.dart';
import 'package:polivalka/custom%20widgets/update_family_button.dart';
import 'package:polivalka/util/http_util.dart';
import 'package:polivalka/util/socket_util.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic> _accountData = {};

  @override
  void initState() {
    super.initState();
    SocketUtil.connect(
        '/account',
        'userData',
        (data) => setState(() {
              _accountData = data;
            }));
  }

  @override
  void dispose() {
    super.dispose();
    SocketUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(248, 255, 248, 1),
        body: _accountData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Stack(children: [
                BackgroundPicture(),
                Center(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromRGBO(149, 188, 143, 1.0),
                            width: 5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: CustomNetworkImage(
                                      height: 100,
                                      width: 100,
                                      image:
                                          'http://polivalka.ddns.net/${_accountData['image_path']}'),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _accountData['username'],
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Color.fromRGBO(38, 79, 33, 1)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(149, 188, 143, 1.0),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Center(
                                                child: Text(
                                          _accountData['family_name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _accountData['family_users'].length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipOval(
                                                  child: CustomNetworkImage(
                                                      image:
                                                          'http://polivalka.ddns.net/${_accountData['family_users'][index]['image_path']}',
                                                      height: 80,
                                                      width: 80),
                                                ),
                                                Text(
                                                    _accountData['family_users']
                                                        [index]['username'], style: TextStyle(color: Color.fromRGBO(38, 79, 33, 1)),)
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: Color.fromRGBO(222, 238, 219, 1.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.network(
                                    'http://polivalka.ddns.net/img/icon/plant.svg',
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    _accountData['family_plants'].toString(),
                                    style: TextStyle(fontSize: 28, color: Color.fromRGBO(38, 79, 33, 1)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ChangeUserDataButton(
                                  image:
                                      'http://polivalka.ddns.net/${_accountData['image_path']}',
                                ),
                                CreateNewFamilyButton(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                UpdateFamilyButton(),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromRGBO(149, 188, 143, 1.0)),
                                    onPressed: () {
                                      FlutterSecureStorage().deleteAll();
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      'Выйти',
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]));
  }
}
