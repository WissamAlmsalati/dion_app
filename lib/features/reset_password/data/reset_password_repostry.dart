


abstract class ResetPasswordRepository {

  
  Future<void> sendOtp({required String phoneNumber,});
  Future<void> resetPassword({required int otpId,required int otp,required String newPassword});


}
