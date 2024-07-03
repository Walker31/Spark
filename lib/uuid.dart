import 'package:uuid/uuid.dart';

class Utils {
  static const _uuid = Uuid();
  static String generateUuid() => _uuid.v4();
}
