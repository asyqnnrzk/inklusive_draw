class SignUpFail {
  final String message;

  const SignUpFail([this.message = 'Error occurred']);

  factory SignUpFail.code(String code) {
    switch(code) {
      case 'weak-password':
        return const SignUpFail('Please enter a stronger password');
      case 'invalid-email':
        return const SignUpFail('Email is not valid or badly formatted');
      case 'email-already-in-used':
        return const SignUpFail('An account already exists for that email');
      case 'operation-not-allowed':
        return const SignUpFail('Operation is not allowed, '
            'please contact support');
      case 'user-disabled':
        return const SignUpFail('This user has been disabled');
      default:
        return const SignUpFail();
    }
  }
}