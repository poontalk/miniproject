import 'package:flutter/material.dart';
import 'package:miniproject/controller/barberController.dart';
import 'package:miniproject/controller/userController.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/model/barber.dart';
import 'package:miniproject/model/user.dart';
import 'package:miniproject/views/admin/addBarber.dart';
import 'package:miniproject/views/admin/editBarber.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class ListAllMembersScreen extends StatefulWidget {
  const ListAllMembersScreen({super.key});

  @override
  State<ListAllMembersScreen> createState() => _ListAllMembersScreenState();
}

class _ListAllMembersScreenState extends State<ListAllMembersScreen> {
  final UserController userController = UserController();
  final BarberController barberController = BarberController();

  bool? isLoaded = false;
  List<UserModel>? user;
  List<BarberModel>? barber;

  void fetchData() async {
    barber = await barberController.listAllBarber();
    user = await userController.listAllBarbers();
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _checkDeleteBarber(String barberId) async{
    http.Response response =
              await barberController.deleteAuthorityLoginBarber(barberId);         
          if (response.statusCode == 200) {    
            await barberController.deleteBarber(barberId);        
            showDeleteBarberSuccessAlert();
          } else {
            showFailToDeleteBarberAlert();
          }
  }

  void showSureToBarberAlert(String barberId) {  
        showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('ลบช่างตัดผม'),
          content: Text('ท่านต้องการลบช่างตัดผมหรือไม่'),
          actions:<Widget> [
               TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ลบ'); 
                _checkDeleteBarber(barberId);
              } ,
              child: const Text('ลบ'),
            ),
          ],
        )
        ); 
  }

  void showFailToDeleteBarberAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อมูลผิดพลาด",
        text: "ไม่สามารถลบช่างตัดผมได้",
        type: QuickAlertType.error);
  }

  void showDeleteBarberSuccessAlert() {
      showDialog(context: context, 
        builder: (BuildContext context) =>
         AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('ลบข้อมูลเสร็จสิ้น'),
          actions:<Widget> [           
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ตกลง'); 
                Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyApp()));                 
              } ,
              child: const Text('ตกลง'),
            ),
          ],
        )
        );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
           const Align(
              alignment: Alignment.center,
              child: Text('รายชื่อช่างตัดผม',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),
            ),
            const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.yellow, 
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        side: const BorderSide(width: 2, color: Colors.black)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddBarber()));
                    },
                    child: const Text("เพิ่มช่างตัดผม")),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("ชื่อ"),
              Text("สถานะ"),
            ],
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: barber?.length ?? user?.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          title: Text(
                              '${barber?[index].barberId}    ${user?[index].firstName}        ${user?[index].lastName}    ${barber?[index].barberStatus}'),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => EditBarberScreen(
                                          barberId:
                                              barber?[index].barberId ?? "",
                                        )));
                          },
                          trailing: GestureDetector(
                            onTap: () {
                              showSureToBarberAlert(
                                  barber?[index].barberId ?? "");
                            },
                            child: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }
}
