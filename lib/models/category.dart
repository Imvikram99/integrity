class Category{
  late String id;
  late String name;
  late bool emailStatus;
  late bool telegramStatus;
  late bool whatsAppStatus;
  late bool mobileNumberStatus;
  Category.fromJson(Map<String,dynamic> json){
    id=json['id'].toString();
    name=json['name'].toString();
    emailStatus=json['email'];
    telegramStatus=json['telegram'];
    whatsAppStatus=json['whatsApp'];
    mobileNumberStatus=json['mobileNumber'];
  }

}