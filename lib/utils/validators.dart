class Validators {

  static bool isValidMobile(String mobile) {
    if (mobile.isEmpty) return false;
    
    final cleanMobile = mobile.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanMobile.length != 10) return false;
    
    final firstDigit = int.tryParse(cleanMobile[0]);
    if (firstDigit == null || firstDigit < 6) return false;
    
    return true;
  }


  static bool isValidOtp(String otp) {
    if (otp.isEmpty) return false;
    
    final cleanOtp = otp.replaceAll(RegExp(r'[^\d]'), '');
    return cleanOtp.length == 4;
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(email);
  }


  static bool isValidPassword(String password) {
    return password.length >= 6;
  }


  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(name) && name.trim().length >= 2;
  }

  static String? getMobileError(String mobile) {
    if (mobile.isEmpty) {
      return 'Mobile number is required';
    }
    
    if (!isValidMobile(mobile)) {
      return 'Please enter a valid 10 digit mobile number';
    }
    
    return null;
  }

  static String? getOtpError(String otp) {
    if (otp.isEmpty) {
      return 'OTP is required';
    }
    
    if (!isValidOtp(otp)) {
      return 'Please enter a valid 4 digit OTP';
    }
    
    return null;
  }
}