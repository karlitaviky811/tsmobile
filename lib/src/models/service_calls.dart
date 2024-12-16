class ServiceCall {
  final int id;
  final int appStatus;
  final String createdAt;
  final String updatedAt;
  final int callID;
  final String subject;
  final String customer;
  final String custmrName;
  final int contctCode;
  final String descrption;
  final String startDate;
  final int startTime;
  final String endDate;
  final int endTime;
  final int duration;
  final String telephone;
  final String bpBillAddr;
  final String uDkMarca;
  final String uDkTienda;
  final String uDkQueja;
  final int uForaneo;
  final int assignedTechnician;

  ServiceCall({
    required this.id,
    required this.appStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.callID,
    required this.subject,
    required this.customer,
    required this.custmrName,
    required this.contctCode,
    required this.descrption,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.duration,
    required this.telephone,
    required this.bpBillAddr,
    required this.uDkMarca,
    required this.uDkTienda,
    required this.uDkQueja,
    required this.uForaneo,
    required this.assignedTechnician,
  });

  factory ServiceCall.fromJson(Map<String, dynamic> json) {
    return ServiceCall(
      id: json['id'],
      appStatus: json['app_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      callID: json['callID'],
      subject: json['subject'],
      customer: json['customer'],
      custmrName: json['custmrName'],
      contctCode: json['contctCode'],
      descrption: json['descrption'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      endDate: json['endDate'],
      endTime: json['endTime'],
      duration: json['duration'],
      telephone: json['telephone'],
      bpBillAddr: json['bpBillAddr'],
      uDkMarca: json['U_DK_Marca'],
      uDkTienda: json['U_DK_TIENDA'],
      uDkQueja: json['U_DK_QUEJA'],
      uForaneo: json['U_FORANEO'],
      assignedTechnician: json['ASSIGNED_TECHNICIAN'],
    );
  }
}
