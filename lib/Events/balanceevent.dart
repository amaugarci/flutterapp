import 'package:eventhandler/eventhandler.dart';

class BalanceEvent extends EventBase {
  final String mode;

  BalanceEvent(this.mode);
}
