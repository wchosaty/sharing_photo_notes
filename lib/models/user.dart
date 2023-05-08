class User {
  late int user_id;
  late String username;
  late String password;
  late String nickname;
  late String token;
  late int create_time;
  late String email;
  late String address;
  late int use_last_time;

  User({
    this.user_id = 0,
    required this.username,
    required this.password,
    required this.nickname,
    this.token = "",
    this.create_time = 0,
    this.email = "",
    this.address = "",
    this.use_last_time = 0,
  });

  User.fromJson(Map<String, dynamic> json)
      : user_id = json['user_id'],
        password = json['password'],
        nickname = json['nickname'],
        token = json['token'],
        create_time = json['create_time'],
        email = json['email'],
        address = json['address'],
        use_last_time = json['use_last_time'];

  Map<String,dynamic> toJson() => {
    'user_id' : user_id, 'password': password, 'nickname': nickname,
    'token': token, 'create_time': create_time, 'email': email,
    'address': address, 'use_last_time': use_last_time,
  };
}
