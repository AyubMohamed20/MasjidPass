import 'package:logger/logger.dart';

final logger = (Type type) => Logger(
      printer: CustomerPrinter(type.toString()),
    );

class CustomerPrinter extends LogPrinter {
  final String className;

  CustomerPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final dataTime = DateTime.now();
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji [$dataTime] $className: $message')];
  }
}
