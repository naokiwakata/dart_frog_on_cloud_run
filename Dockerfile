# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

WORKDIR /app

# Copy Dependencies


# Install Dependencies


# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get
RUN dart pub global activate dart_frog_cli

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub global run dart_frog_cli:dart_frog build
RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server 

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/


# Start server.
CMD ["/app/bin/server"]