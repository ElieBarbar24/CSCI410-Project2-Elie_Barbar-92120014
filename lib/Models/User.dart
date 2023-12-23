class User{
  int? id;
  final String name;
  String? email;
  String? password;
  String? status;
  String? photo;
  int? relationID;

  User(this.name, this.email, this.password, this.status);
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'Status': status,
    };
  }
  User.idUser(this.id,this.name, this.email, this.password, this.status,this.photo,this.relationID);
  User.friendRequest(this.id,this.name, this.email, this.password, this.status,this.photo);
  User.user(this.name, this.id,this.relationID,this.photo);

  factory User.fromJson(Map<String, dynamic> json) {
    return User.idUser(
      json['id'] as int?,
      json['name'] as String,
      json['email'] as String,
      json['password'] as String,
      json['Status'] as String,
      json['photo'] as String?,
      json['relationID'] as int?
    );
  }
}

late User currentUser;