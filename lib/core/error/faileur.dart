abstract class Faileur {
  final String message;

  Faileur({required this.message});
}

class ServerFaileur extends Faileur {
  ServerFaileur({required super.message});
}
