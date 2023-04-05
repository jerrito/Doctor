import 'dart:convert';

import 'package:doctor/firebase_services.dart';

class User implements Serializable {
  String? fullname;
  String? number;
  String? email;
  String? password;
  String? id;
  String? image;
  String? location;
  String? speciality;
  String? shortBio;
  int? experience;
  int? patients;
  double? ratings;
  int? live;

  User(
      {this.fullname,
      this.number,
      this.id,
      this.shortBio,
      this.email,
      this.password,
      this.image,
      this.location,
      this.speciality,
      this.experience,
      this.patients,
      this.ratings,
      this.live});
  factory User.fromJson(Map? json) => User(
        id: json?["id"],
        fullname: json?["fullname"],
        number: json?["number"],
        email: json?["email"],
        password: json?["password"],
        image: json?["image"],
        location: json?["location"],
        speciality: json?["speciality"],
        shortBio: json?["shortBio"],
        experience: json?["experience"],
        patients: json?["patients"],
        ratings: json?["ratings"],
        live: json?["live"],
      );
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "fullname": fullname,
      "number": number,
      "password": password,
      "email": email,
      "image": image,
      "location": location,
      "ratings": ratings,
      "patients": patients,
      "experience": experience,
      "speciality": speciality,
      "shortBio": shortBio,
      "live": live,
    };
  }

  static User fromString(String userString) {
    return User.fromJson(jsonDecode(userString));
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Appointment implements Serializable {
  String? date;
  String? time;
  String? doctor;
  String? speciality;
  String? location;
  String? number;
  Appointment(
      {this.date,
      this.time,
      this.doctor,
      this.speciality,
      this.location,
      this.number});

  factory Appointment.fromJson(Map? json) => Appointment(
      date: json?["date"],
      time: json?["time"],
      doctor: json?["doctor"],
      speciality: json?["speciality"],
      number: json?["number"],
      location: json?["location"]);

  @override
  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "time": time,
      "doctor": doctor,
      "speciality": speciality,
      "location": location,
      "number": number,
    };
  }

  static Appointment fromString(String userString) {
    return Appointment.fromJson(jsonDecode(userString));
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
