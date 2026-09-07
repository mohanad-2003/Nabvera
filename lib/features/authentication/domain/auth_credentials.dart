// /// Replaces the old `LoginModel`/`SignupModel` — immutable value objects
// /// instead of mutable plain classes with no purpose beyond field storage.
// class LoginCredentials {
//   const LoginCredentials({required this.email, required this.password});

//   final String email;
//   final String password;
// }

// class SignupCredentials {
//   const SignupCredentials({
//     required this.fullName,
//     required this.email,
//     required this.password,
//   });

//   final String fullName;
//   final String email;
//   final String password;
// }

class LoginCredentials {
  const LoginCredentials({required this.email, required this.password});
  final String email;
  final String password;
}

class SignupCredentials {
  const SignupCredentials({
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String fullName;
  final String email;
  final String password;
}
