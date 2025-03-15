// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String email;
  final String roomnumber;
  UserModel({
    required this.email,
    required this.roomnumber,
  });

  UserModel copyWith({
    String? email,
    String? roomnumber,
  }) {
    return UserModel(
      email: email ?? this.email,
      roomnumber: roomnumber ?? this.roomnumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'roomnumber': roomnumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      roomnumber: map['roomnumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(email: $email, roomnumber: $roomnumber)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.roomnumber == roomnumber;
  }

  @override
  int get hashCode => email.hashCode ^ roomnumber.hashCode;
}
