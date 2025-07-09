class MyIDAccount {
  String phoneNumber;
  int? mainBalance;
  int? voiceBalance;
  int? dataBalance;
  String? dataExpireTime;
  int? loyaltyPoints;

  MyIDAccount({
    this.phoneNumber = "0",
    this.mainBalance = 0,
    this.voiceBalance = 0,
    this.dataBalance = 0,
    this.dataExpireTime = "dd/MM/yyyy",
    this.loyaltyPoints = 0,
  });

  void clearValues() {
    phoneNumber = "0";
    mainBalance = 0;
    voiceBalance = 0;
    dataBalance = 0;
    loyaltyPoints = 0;
    dataExpireTime = "dd/MM/yyyy";
  }
}
