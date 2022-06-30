import 'package:m_survey/network/network_state_enum.dart';

class NetworkState {
  NetworkStateEnum state;
  String? message;

  NetworkState({
    required this.state,
    this.message,
  });
}
