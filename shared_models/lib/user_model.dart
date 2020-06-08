class UserModel
{
  String id;

  String name;

  String password;

  String userType;

  UserModel(this.name, this.password);

  UserModel.fromJson(Map<String, dynamic> json)
    : name = json["name"] as String,
      password = json["password"] as String,
      id = json["id"] as String,
      userType = json["userType"] as String;
  
  Map<String, dynamic> toJson() =>
    {
      "id": id,
      "name": name,
      "password": password,
      "userType": userType
    };
}