// API_URL environment variable must be declared if the backend runs on a different host, otherwise it is not necessary
const String API_URL = String.fromEnvironment('API_URL'); 

// DRAW_ID_LENGTH environment variable must always be declared
const int DRAW_ID_LENGTH = int.fromEnvironment('DRAW_ID_LENGTH');

// Used to store locally the tokens
final TOKEN_KEY_PREFIX = 'token-';

final DATE_REGEX = RegExp(r'^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$');
final TIME_REGEX = RegExp(r'^([01][0-9]|2[0-3]):([0-5][0-9])$');
