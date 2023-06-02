import 'package:feather/src/data/model/internal/geo_position.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/repository/local/storage_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../model/weather_utils.dart';
import 'fake_storage_provider.dart';

void main() {
  late StorageManager storageManager;
  setUpAll(() {
    storageManager = StorageManager(FakeStorageProvider());
  });

  group("Unit", () {
    test("getUnit returns default unit", () async {
      expect(await storageManager.getUnit(), Unit.metric);
    });

    test("getUnit returns saved Unit", () async {
      storageManager.saveUnit(Unit.imperial);
      expect(await storageManager.getUnit(), Unit.imperial);

      storageManager.saveUnit(Unit.metric);
      expect(await storageManager.getUnit(), Unit.metric);
    });

    test("saveUnit returns true", () async {
      expect(await storageManager.saveUnit(Unit.imperial), true);
      expect(await storageManager.saveUnit(Unit.metric), true);
    });
  });

  group("Refresh time", () {
    test("refreshTime returns default value", () async {
      expect(await storageManager.getRefreshTime(), 600000);
    });

    test("Refresh time saves refresh time", () async {
      storageManager.saveRefreshTime(1000);
      expect(await storageManager.getRefreshTime(), 1000);
    });

    test("Save refresh time returns true", () async {
      expect(await storageManager.saveRefreshTime(1000), true);
    });
  });

  group("Last Refresh time", () {
    test("Last Refresh time returns default value", () async {
      expect(await storageManager.getLastRefreshTime() != 0, true);
    });

    test("Last refresh time saves refresh time", () async {
      await storageManager.saveLastRefreshTime(1000);
      expect(await storageManager.getLastRefreshTime(), 1000);
    });

    test("Save last refresh time returns true", () async {
      expect(await storageManager.saveLastRefreshTime(1000), true);
    });
  });

  group("Last Refresh time", () {
    test("Last Refresh time returns default value", () async {
      expect(await storageManager.getLastRefreshTime() != 0, true);
    });

    test("Last refresh time saves refresh time", () async {
      await storageManager.saveLastRefreshTime(1000);
      expect(await storageManager.getLastRefreshTime(), 1000);
    });

    test("Save last refresh time returns true", () async {
      expect(await storageManager.saveLastRefreshTime(1000), true);
    });
  });

  group("Location", () {
    test("Location returns default value", () async {
      expect(await storageManager.getLocation(), null);
    });

    test("Save location saves location", () async {
      await storageManager.saveLocation(GeoPosition(1, 1));
      final position = await storageManager.getLocation();
      expect(position != null, true);
      expect(position?.lat == 1.0, true);
      expect(position?.long == 1.0, true);
    });

    test("Save last refresh time returns true", () async {
      expect(await storageManager.saveLocation(GeoPosition(1, 1)), true);
    });
  });

  group("Weather", () {
    test("Weather returns default value", () async {
      expect(await storageManager.getWeather(), null);
    });

    test("Save weather saves weather", () async {
      final weatherResponse = WeatherUtils.getWeather();

      await storageManager.saveWeather(weatherResponse);
      final weather = await storageManager.getWeather();
      expect(weather != null, true);
      expect(weather?.id, 0);
    });

    test("Save weather returns true", () async {
      final result =
          await storageManager.saveWeather(WeatherUtils.getWeather());
      expect(result, true);
    });
  });

  group("Weather forecast", () {
    test("Weather forecast returns default value", () async {
      expect(await storageManager.getWeatherForecast(), null);
    });

    test("Save weather forecast saves weather", () async {
      final weatherForecastResponse =
          WeatherUtils.getWeatherForecastListResponse();

      await storageManager.saveWeatherForecast(weatherForecastResponse);
      final weatherForecast = await storageManager.getWeatherForecast();
      expect(weatherForecast != null, true);
    });

    test("Save weather forecast returns true", () async {
      final result = await storageManager
          .saveWeatherForecast(WeatherUtils.getWeatherForecastListResponse());
      expect(result, true);
    });
  });
}
