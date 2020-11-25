class Timestamp {
  Timestamp();
  factory Timestamp.now() {
    return Timestamp.fromDateTime(DateTime.now());
  }
  factory Timestamp.fromDateTime(DateTime time) {
    return Timestamp();
  }
}
