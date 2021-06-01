import 'dart:async';

/// must use dispose() from the bloc
/// use streamListener to listen for changes
/// use setStream() to set a dynamic value

class CustomStreamController {
  late StreamController<dynamic> _streamController;

  Stream<dynamic> get streamListener => _streamController.stream;

  Sink<dynamic> get _streamIn => _streamController.sink;

  CustomStreamController() {
    _createNewStreamController();
  }

  _createNewStreamController() {
    _streamController = StreamController<dynamic>.broadcast();
  }

  void dispose() {
    _streamController.close();
  }

  void setStream(dynamic dynamic) {
    _streamIn.add(dynamic);
  }
}
