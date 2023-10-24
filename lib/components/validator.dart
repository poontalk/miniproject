String? validateEmail(String? email){
    RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    final isEmailValid = emailRegex.hasMatch(email ?? '');
     if(email!.length < 5 ){
      return 'อีเมล์ อย่างน้อยต้องมี 5 ตัวอักษร';
    }  
    if(!isEmailValid){
      return 'กรุณากรอกอีเมล์ใหม่';
    } 
    return null;
 }
String? validateServiceName(String? input) {
  RegExp serviceNameRegex = RegExp(r"^[ก-๙]+$");
  final isServiceNameValid = serviceNameRegex.hasMatch(input ?? '');
  if (input!.isEmpty) {
    return 'ห้ามว่าง';
  }
  if (!isServiceNameValid) {
    return 'กรุณากรอกชื่อบริการเป็นภาษาไทยเท่านั้น';
  }
  return null;
}

bool validateRegister(String input) {
  const registerRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";
  if (RegExp(registerRegex).hasMatch(input)) {
    return true;
  } else
    return false;
}

String? validateServicTimespend(String? input) {
  RegExp servicTimespend = RegExp(r"^[\d]") ;
   final isServicTimespendValid = servicTimespend.hasMatch(input ?? '');
   if (input!.isEmpty) {
    return 'ห้ามว่าง';
  }
  if (!isServicTimespendValid) {
    return 'กรุณากรอกจำนวนเวลาเป็นตัวเลขนาทีเท่านั้น';
  } 
   return null;
}

String? validateServicPrice(String? input) {
  RegExp servicePrice = RegExp(r"^[\d.]") ;
   final isServicPriceValid = servicePrice.hasMatch(input ?? '');  
  if (input!.isEmpty) {
    return 'ห้ามว่าง';
  }
  if (!isServicPriceValid) {
    return 'กรุณากรอกจำนวนราคาเป็นตัวเลขเท่านั้น';
  } 
    return null;
}

String? validateUserName(String? username){
    RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9]+$');
    final isusernameValid = usernameRegex.hasMatch(username ?? '');
    if(!isusernameValid){
      return 'กรุณากรอกชื่อผู้ใช้งานใหม่';
    }   
    if(username!.length < 4 ){
      return 'ชื่อผู้ใช้งาน อย่างน้อยต้องมี 4 ตัวอักษร';
    }  
    return null;
 }

 String? validatePassword(String? password){
    RegExp passwordRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+-=?^_`@]+$");
    final ispasswordValid = passwordRegex.hasMatch(password ?? '');
     if(password!.length < 8 ){
      return 'รหัสผ่าน อย่างน้อยต้องมี 8 ตัวอักษร';
    }  
    if(!ispasswordValid){
      return 'กรุณากรอกรหัสผ่านใหม่';
    }      
    return null;
 }

 

 String? validateAddress(String? address){
    RegExp addressRegex = RegExp(r"^[ a-zA-Z0-9.ก-๙]+$");
    final isaddressValid = addressRegex.hasMatch(address ?? '');
    if(address!.length < 2 ){
      return 'ที่อยู่ อย่างน้อยต้องมี 2 ตัวอักษร';
    }
    if(!isaddressValid){
      return 'กรุณากรอกที่อยู่ใหม่';
    }         
    return null;
 }

 String? validatePhoneNumber(String? phoneNumber){
    RegExp phoneNumberRegex = RegExp(r"^[0]{1}[6,8,9]{1}[0-9]{8}$");
    final isPhoneNumberValid = phoneNumberRegex.hasMatch(phoneNumber ?? '');
    if(!isPhoneNumberValid){
      return 'กรุณากรอกเบอร์โทรใหม่';
    }   
    return null;
 }

 String? validateName(String? name){
    RegExp nameRegex = RegExp(r"^[a-zA-Zก-๙]+$");    
    final isnameValid = nameRegex.hasMatch(name ?? '');
     if(name!.length < 2 ){
      return 'ชื่อ อย่างน้อยต้องมี 2 ตัวอักษร';
    }   
    if(!isnameValid){
      return 'กรุณากรอกชื่อใหม่';
    }    
    return null;
 }

 String? validateReservedate(String? reserveDate){    
     if (reserveDate!.isEmpty) {
    return 'ห้ามว่าง';
  }      
    return null;
 }

  String? validateReserveTime(String? reserveTime){    
     if (reserveTime!.isEmpty) {
    return 'ห้ามว่าง';
  }      
    return null;
 }
