FROM dart:stable

WORKDIR /bot

# Install dependencies
COPY pubspec.* /bot
RUN dart pub get

# Copy code
COPY . /bot
RUN dart pub get --offline

# Compile bot into executable
RUN dart run nyxx_commands:compile -o bot.dart --no-compile bin/main.dart
RUN dart compile exe -o bot bot.dart

CMD [ "./bot" ]