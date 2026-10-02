import 'package:core/errors.dart';

class PresentationFailureException implements Exception {
  const PresentationFailureException(this.failure);

  final Failure failure;

  @override
  String toString() => failure.message;
}

String presentationFailureMessage(Object error) {
  if (error is PresentationFailureException) return error.failure.message;
  if (error is Failure) return error.message;
  return error.toString();
}
