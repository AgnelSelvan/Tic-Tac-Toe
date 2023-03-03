import 'dart:math';

class Constants {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static final Random _rnd = Random();

  static String get generateTeamID {
    return List.generate(6, (index) => _chars[_rnd.nextInt(_chars.length)])
        .join();
  }
}
