import 'package:miniproject/model/user.dart';

class BarberModel {
  String? barberId;
  UserModel? userModel; 
  String? barberStatus;
  

  BarberModel({
    this.barberId,    
    this.userModel,
    this.barberStatus,    
  });

    Map<String,dynamic> fromBarberToJson(){
    return<String,dynamic> {
      'barberId' : barberId,      
      'barberStatus' : barberStatus,    
      'user' : userModel?.fromUserToJson()  
    };
  }

   factory BarberModel.fromJsonToBarber(Map<String, dynamic> json) {
    return BarberModel(      
      barberId: json["barberId"],
      barberStatus: json["barberStatus"],  
      userModel: UserModel.fromJsonToUser(json["user"])               
    );
  }
}