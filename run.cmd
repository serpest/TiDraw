@echo off

START mvnw.cmd spring-boot:run
START /d src\main\webapp flutter run -d chrome --dart-define=API_URL=http://localhost:8080
