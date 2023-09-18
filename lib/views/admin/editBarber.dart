import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:miniproject/components/myTextField.dart';
import 'package:miniproject/controller/barberController.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/model/barber.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/admin/listallmember.dart';
import 'package:http/http.dart' as http;

class EditBarberScreen extends StatefulWidget {
  final String barberId;

  const EditBarberScreen({super.key, required this.barberId});

  @override
  State<EditBarberScreen> createState() => _EditBarberScreenState();
}

class _EditBarberScreenState extends State<EditBarberScreen> {
  BarberModel? barberModel;
  bool? isLoaded = false;
  UserModel? userModel;

  final BarberController barberController = BarberController();
  TextEditingController barberIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();

  void fetchData(String baeberId) async {
    barberModel = await barberController.getBarberById(baeberId);
    // setDataToText();
    barberIdController.text = barberModel?.barberId ?? "";
    userIdController.text = barberModel?.userModel?.userId ?? "";
    
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.barberId);
  }

  List<String> items = ['ว่าง', 'ไม่ว่าง', 'ไม่อยู่'];
  String? selectedItem = 'ว่าง';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barber'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: barberIdController,
              enabled: false,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
            DropdownButton<String>(
              value: selectedItem,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 24)),
                      ))
                  .toList(),
              onChanged: (item) => setState(() => selectedItem = item),
            ),

            //Button Submit
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () async {
                    http.Response response =
                        await barberController.updateBarber(BarberModel(
                      barberId: barberIdController.text,
                      barberStatus: selectedItem,
                      userModel: barberModel?.userModel
                    ));

                    if (response.statusCode == 500) {
                      print('Failed to update');
                    }
                  },
                  child: Text("ยืนยัน")),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (bui) => const ListAllMembersScreen()));
                },
                child: Text("ยกเลิก"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
