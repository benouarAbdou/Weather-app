# Flutter Weather App

## Overview

This Flutter Weather App is a comprehensive mobile application that provides real-time weather information and forecasts. Based on the tutorial video by [Romain Girou](https://www.youtube.com/watch?v=MMq4wkeHkPc), this project has been expanded with additional features and optimizations.

## Features

- **Current Weather Display**: Shows the current temperature, weather condition, and location.
- **5-Day Forecast**: Provides a summary of weather conditions for the next 5 days.
- **15-Hour Forecast**: Detailed hourly forecast for the next 15 hours.
- **40-Hour Forecast Chart**: Visual representation of temperature trends over the next 40 hours.
- **Dynamic UI**: Changes appearance based on the time of day (morning/evening).
- **Geolocation**: Automatically fetches weather data for the user's current location.
- **Responsive Design**: Adapts to different screen sizes and orientations.

## Technologies Used

### Framework
- **Flutter**: Cross-platform UI toolkit for building natively compiled applications.

### State Management
- **BLoC (Business Logic Component)**: Used for separating the business logic from the UI.

### APIs
- **OpenWeatherMap API**: Provides weather data and forecasts.

### Packages
- `flutter_bloc`: Implements the BLoC pattern for state management.
- `weather`: Wrapper for the OpenWeatherMap API.
- `geolocator`: Provides easy access to platform-specific location services.
- `intl`: Internationalization and localization support.
- `loading_indicator`: Customizable loading indicators.
- `equatable`: Simplifies equality comparisons for Dart objects.

## Project Structure

The project follows a modular structure:

- `lib/`
  - `main.dart`: Entry point of the application.
  - `bloc/`: Contains BLoC-related files for state management.
  - `components/`: Reusable UI components.
  - `data/`: Data-related files, including API keys.

## Setup and Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/flutter-weather-app.git
   ```

2. Navigate to the project directory:
   ```
   cd flutter-weather-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Set up your OpenWeatherMap API key:
   - Create a file `lib/data/my_data.dart`
   - Add your API key:
     ```dart
     const String API_KEY = 'your_api_key_here';
     ```

5. Run the app:
   ```
   flutter run
   ```

## Usage

Upon launching the app:
1. Grant location permissions when prompted.
2. The app will automatically fetch and display weather data for your current location.
3. Scroll through the UI to view different weather forecasts and information.

## Contributing

Contributions to improve the app are welcome. Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature.
3. Add your changes and commit them.
4. Push to your fork and submit a pull request.

## License

This project is open-source and available under the [MIT License](LICENSE).

## Acknowledgements

- Original tutorial by [Romain Girou](https://www.youtube.com/watch?v=MMq4wkeHkPc)
- OpenWeatherMap for providing the weather data API
- Flutter and Dart teams for their excellent framework and language

## Contact

For any queries or suggestions, please open an issue in the GitHub repository.

---

Happy coding! ☀️🌦️
