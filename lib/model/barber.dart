class BarberModel {
  String? barberId;
  String? userId; 
  String? barberStatus;
  

  BarberModel({
    this.barberId,    
    this.userId,
    this.barberStatus,    
  });

    Map<String,dynamic> fromBarberToJson(){
    return<String,dynamic> {
      'barberId' : barberId,
      'userId' : userId,
      'barberStatus' : barberStatus      
    };
  }

   factory BarberModel.fromJsonToBarber(Map<String, dynamic> json) {
    return BarberModel(
      userId: json["userId"],
      barberId: json["barberId"],
      barberStatus: json["barberStatus"]                 
    );
  }
}