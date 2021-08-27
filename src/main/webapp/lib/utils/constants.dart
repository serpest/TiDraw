// API_URL environment variable must be declared if the backend runs on a different host, otherwise it is not necessary
const String API_URL = String.fromEnvironment('API_URL'); 

// DRAW_ID_LENGTH environment variable must always be declared
const int DRAW_ID_LENGTH = int.fromEnvironment('DRAW_ID_LENGTH');
