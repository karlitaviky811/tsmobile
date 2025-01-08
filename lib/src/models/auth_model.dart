class User {
  final int id;
  final String name;
  final String email;
  final String geographicalcoordinates;
  final String nameComercial;
  final int ntickets;
  final int nrejectedtickets;
  final int qualification;
  final String address;
  final String latitude;
  final String longitude;
  final String? agency;
  final String phone;
  final int nparts;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.nameComercial,
    required this.ntickets,
    required this.nrejectedtickets,
    required this.qualification,
    required this.address,
    required this.geographicalcoordinates,
    required this.latitude,
    required this.longitude,
    required this.nparts,
    this.agency,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['User_name'] ?? '',
      email: json['Email'] ?? '',
      nameComercial: json['Name_user_comercial'] ?? '',
      ntickets: json['ticketsCount'] ?? 0,
      nparts: json['partRequestCount'] ?? 0,
      nrejectedtickets: json['Tickets_rejected'] ?? 0,
      qualification: json['Qualification'] ?? 0,
      address: json['Address'] ?? '',
      geographicalcoordinates:
          json['GeographicalCoordinates']['data'].toString(),
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      agency: json['agency'] ?? '',
      phone: json['Phone'] ?? '',
    );
  }
}
