import 'package:flutter/material.dart';
import 'package:miniproject/controller/service_controller.dart';
import 'package:miniproject/model/service.dart';


class ListServiceScreen extends StatefulWidget {
  const ListServiceScreen({super.key});

  @override
  State<ListServiceScreen> createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {
  final ServiceController serviceController = ServiceController();

  bool? isLoaded = false;
  List<ServiceModel>? serviceModels;
  int i = 0;

  void fetchData() async {
    serviceModels = await serviceController.getListService();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
           const SizedBox(height: 25),
              //Header
              const Text('รายการบริการ',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 30)),       
          Expanded(
            child: ListView.builder(
                itemCount: serviceModels?.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: SizedBox(
                        width: 155,
                        child: ListTile(
                          title: Center(
                            child: Text(
                                '${serviceModels?[index].serviceName} ${serviceModels?[index].price} บาท  เวลาบริการ: ${serviceModels?[index].timespend} ชั่วโมง'),
                          ),
                        ),
                      ),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }
}
