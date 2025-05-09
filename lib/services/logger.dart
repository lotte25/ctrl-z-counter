import 'dart:io';
import 'package:logger/logger.dart';

class FileOutput extends LogOutput {
  final File file;
  
  FileOutput({required this.file});

  @override
  void output(OutputEvent event) {
    file.writeAsStringSync('${event.lines.join('\n')}\n', mode: FileMode.append);
  }
}

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true
  ),
  output: FileOutput(file: File("app.log"))
);