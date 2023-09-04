

class BarberModel {
  String? barberId;
  String? userId;
  String? barberFirstName;
  String? barberLastName;
  String? barberStatus;
  

  BarberModel({
    this.barberId,    
    this.userId,
    this.barberFirstName,
    this.barberLastName,
    this.barberStatus,    
  });

    Map<String,dynamic> fromBarberToJson(){
    return<String,dynamic> {
      'barberId' : barberId,
      'userId' : userId,           
      'firstName' : barberFirstName,
      'lastName' : barberLastName,
      'barberStatus' : barberStatus      
    };
  }

   factory BarberModel.fromJsonToBarber(Map<String, dynamic> json) {
    return BarberModel(
      userId: json["userId"],
      barberId: json["barberId"],
      barberFirstName: json["firstName"],
      barberLastName: json["lastName"],
      barberStatus: json["barberStatus"]                 
    );
  }
}