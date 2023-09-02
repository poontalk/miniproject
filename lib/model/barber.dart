class BarberModel {
  String? barberId;
  String? userId;
  String? barberStatus;

  BarberModel({
    this.barberId,
    this.barberStatus,
    this.userId
  });

    Map<String,dynamic> fromBarberToJson(){
    return<String,dynamic> {
      'userId' : userId,
      'barberId' : barberId,
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