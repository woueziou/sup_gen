class DatabaseOption {
  final String userName;
  final String schema;
  final String password;
  final String host;
  final int port;
  final bool? useSSL;

  DatabaseOption(
      {required this.userName,
      required this.schema,
      required this.password,
      required this.host,
      required this.port,
       this.useSSL});
}
