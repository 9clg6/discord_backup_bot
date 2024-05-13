import 'package:nyxx_commands/nyxx_commands.dart';

///
/// [Parameters]
///
enum Parameters {
  /// 
  /// No parameters
  /// 
  noParameter(0, "Aucun paramètre"),

  ///
  /// Don't save messages
  ///
  noMessageSave(1, "Ne pas sauvegarder les messages");

  ///
  /// Constructor
  ///
  const Parameters(this.code, this.name);

  /// Code
  final int code;

  /// Name to show
  final String name;
}

/// Parameters to string
String parameterTypeToString(Parameters type) => type.name;

///
/// Converter
///
const SimpleConverter<Parameters> parameterTypeConverter = SimpleConverter.fixed(
  elements: Parameters.values,
  stringify: parameterTypeToString,
);
