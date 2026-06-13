import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get stripeSecret => dotenv.env['STRIPE_SECRET'] ?? "";
}
