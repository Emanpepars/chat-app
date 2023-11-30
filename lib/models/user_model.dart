class UserModel {
  String id;
  String email;
  String name;
  String phone;
  String image;
  String pushToken;

  UserModel({
    this.id = '',
    required this.email,
    required this.name,
    required this.phone,
    required this.image,
    required this.pushToken,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          email: json["email"],
          image: json["image"],
          name: json["name"],
          phone: json["phone"],
          pushToken: json["pushToken"],
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "image": image,
      "name": name,
      "phone": phone,
      "pushToken": pushToken,
    };
  }
}
