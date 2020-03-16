String formatCommand(String command, Iterable<String> arguments) {
  String formattedArguments = arguments?.join(" ") ?? "";
  return formattedArguments.isNotEmpty ? "$command $formattedArguments" : command;
}
