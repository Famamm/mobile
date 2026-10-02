class CancelTripDTO {
  final int driverId;

  CancelTripDTO({required this.driverId});

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
      };
}
