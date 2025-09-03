/// Configuration options for database connections.
///
/// This class holds all necessary parameters to establish a connection
/// to a PostgreSQL or Supabase database, including authentication credentials,
/// connection details, and SSL preferences.
///
/// ## Usage
///
/// Typically created by loading from environment variables:
/// ```dart
/// final dbOption = DatabaseOption(
///   userName: 'postgres',
///   password: 'your_password',
///   host: 'localhost',
///   port: 5432,
///   db: 'your_database',
///   schema: 'public',
///   useSSL: false,
/// );
/// ```
class DatabaseOption {
  /// The database username for authentication.
  final String userName;

  /// The database schema to query (e.g., 'public', 'auth').
  final String schema;

  /// The database password for authentication.
  final String password;

  /// The database host address (e.g., 'localhost', 'db.supabase.co').
  final String host;

  /// The database port number (typically 5432 for PostgreSQL).
  final int port;

  /// Whether to use SSL/TLS for the database connection.
  /// 
  /// - `true`: Forces SSL connection (required for most cloud databases)
  /// - `false`: Disables SSL (typically for local development)
  /// - `null`: Uses database default SSL behavior
  final bool? useSSL;

  /// The database name to connect to.
  final String db;

  /// Creates a new [DatabaseOption] instance.
  ///
  /// All parameters except [useSSL] are required for establishing
  /// a database connection.
  DatabaseOption({
    required this.userName,
    required this.schema,
    required this.password,
    required this.host,
    required this.port,
    required this.db,
    this.useSSL,
  });
}
