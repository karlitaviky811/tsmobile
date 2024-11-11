class Reservation {
  Reservation(
      {required this.id,
      required this.courtName,
      required this.reservationDate,
      required this.schedule,
      required this.user});

  String courtName;
  String reservationDate;
  String user;
  String schedule;
  String id;
}
