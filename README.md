# flutter_weather_app

A simple Flutter weather demo app that fetches and displays weather information for a city or the device location.

## Features
- Search weather by city name
- Fetch weather for current device location
- Clean, responsive UI with light/dark theme support
- Uses a .env file for API key configuration

## Project layout (important files)
- lib/main.dart — app entrypoint
- lib/app/app.dart — MaterialApp setup (themes, routes)
- lib/pages/weather_home_page.dart — main UI and logic (search, location, states)
- lib/services/weather_service.dart — API/service calls
- lib/models/weather_data.dart — weather data model
- lib/widgets/weather_card.dart — weather display widget
- assets/images/launcher_icon.png — launcher icon image
- .env — environment file with API key (not checked in)

## Prerequisites
- Flutter SDK (stable)
- Android Studio / Xcode toolchains for device/emulator
- An API key for the weather provider used by services/weather_service.dart

## Setup & run
1. Clone the repo and open it in VS Code or Android Studio.
2. Create a `.env` file in the project root (same folder as pubspec.yaml) with your API key, for example:
   API_KEY=your_api_key_here
3. Get packages:
   flutter pub get
4. (Optional) Add launcher icons:
   - Ensure `assets/images/launcher_icon.png` exists
   - Add flutter_launcher_icons config to `pubspec.yaml` (dev_dependency)
   - Run:
     flutter pub run flutter_launcher_icons:main
5. Static analysis:
   flutter analyze
6. Run the app:
   flutter run

## Theme
The app supports device theme. Ensure your MaterialApp in `lib/app/app.dart` uses:
- themeMode: ThemeMode.system
- Provide `theme` and `darkTheme` for consistent visuals.

## Environment variables
The app uses flutter_dotenv. Example `.env`:
API_KEY=YOUR_WEATHER_API_KEY

Do not commit `.env` to version control.

## Testing & QA
- Run static analysis: `flutter analyze`
- Add unit/widget tests under `test/` and run: `flutter test`

## Troubleshooting
- If launcher icons don't update, run:
  flutter clean
  flutter pub get
  flutter pub run flutter_launcher_icons:main
- If missing API key, requests will fail — verify `.env` and restart the app.

## Contributing
- Open issues/pull requests.
- Keep changes focused and update README with any added setup steps.

## License
Specify project license as needed.
