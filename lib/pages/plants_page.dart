import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:polivalka/custom%20widgets/background_picture.dart';
import 'package:polivalka/custom%20widgets/create_plant_button.dart';
import 'package:polivalka/custom%20widgets/plant_card.dart';
import 'package:polivalka/util/http_util.dart';
import 'package:polivalka/util/toast_util.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../util/socket_util.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  List<dynamic> plantsData = [];
  late Socket socket;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isPlantsLoaded = false;

  bool _isChecked = false;
  List<bool> _children = [];

  @override
  void initState() {
    super.initState();
    SocketUtil.connect(
        '/plants',
        'plantsData',
        (data) => setState(() {
              _isPlantsLoaded = true;
              if (data != false) {
                plantsData = data;
                _children = List.filled(plantsData.length, false);
              } else {
                plantsData = [];
              }
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
      backgroundColor: Color.fromRGBO(248, 255, 248, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(149, 188, 143, 1),
        automaticallyImplyLeading: false,
        title: Text('Растения'),
        actions: <Widget>[
          //IconButton(onPressed: null, icon: Icon(Icons.delete)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CreatePlantButton(),
          ),
          if (plantsData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: _delete, icon: Icon(Icons.delete)),
            ),
          if (plantsData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Checkbox(
                checkColor: Colors.white,
                activeColor:
                Color.fromRGBO(38, 79, 33, 1),
                value: _isChecked,
                onChanged: (value) {
                  _checkAll(value!);
                },
              ),
            )
        ],
      ),
      body: _isPlantsLoaded
          ? plantsData.isEmpty
              ? Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'У вас нет растений',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: plantsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: PlantCard(
                        plantsData[index]['name'],
                        'http://polivalka.ddns.net/${plantsData[index]['image_path']}',
                        (bool? value) {
                          setState(() {
                            _children[index] = value!;
                          });
                        },
                        isChecked: _children[index],
                      ),
                    );
                  })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _checkAll(bool value) {
    setState(() {
      _isChecked = value;

      for (int i = 0; i < _children.length; i++) {
        _children[i] = value;
      }
    });
  }

  void _delete() async {
    List<int> toDelete = [];
    for (int i = 0; i < _children.length; i++) {
      if (_children[i] == true) {
        toDelete.add(plantsData[i]["id"]);
      }
    }

    if (toDelete.isEmpty) {
      return;
    }

    setState(() {
      _isPlantsLoaded = false;
      plantsData = [];
    });

    int statusCode = await HttpUtil.deletePlants(toDelete);
    if (statusCode == 200) {
      ToastUtil.showToast(
          'Удаление прошло успешно', Color.fromRGBO(38, 79, 33, 1), context);
    } else {
      ToastUtil.showToast('Что-то пошло не так..', Colors.redAccent, context);
    }
  }
}
