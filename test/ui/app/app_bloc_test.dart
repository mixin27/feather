import 'package:bloc_test/bloc_test.dart';
import 'package:feather/src/data/model/internal/unit.dart';
import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/app/app_bloc.dart';
import 'package:feather/src/ui/app/app_event.dart';
import 'package:feather/src/ui/app/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/repository/local/fake_storage_manager.dart';

void main() {
  late FakeStorageManager fakeStorageManager;
  late AppBloc appBloc;

  setUpAll(() {
    fakeStorageManager = FakeStorageManager();
    appBloc = buildAppBloc(fakeStorageManager: fakeStorageManager);
  });

  group("Initial unit settings", () {
    test("Initial state has metric unit", () {
      expect(appBloc.state.unit, Unit.metric);
    });
  });

  group("Is metric units returns correct flag", () {
    test("Returns false for imperial unit", () async {
      fakeStorageManager.saveUnit(Unit.imperial);
      appBloc.add(LoadSettingsAppEvent());
      await expectLater(appBloc.stream,
          emitsInOrder(<AppState>[const AppState(Unit.imperial)]),);
      expect(appBloc.isMetricUnits(), equals(false));
    });

    test("Returns true for metric unit", () async {
      fakeStorageManager.saveUnit(Unit.metric);
      appBloc.add(LoadSettingsAppEvent());
      await expectLater(appBloc.stream,
          emitsInOrder(<AppState>[const AppState(Unit.metric)]),);
      expect(appBloc.isMetricUnits(), equals(true));
    });
  });

  group("Updated bloc state", () {
    setUp(() {
      fakeStorageManager.saveUnit(Unit.imperial);
    });

    blocTest<AppBloc, AppState>(
      "Load app settings updates unit",
      build: () => appBloc,
      act: (AppBloc bloc) => bloc.add(
        LoadSettingsAppEvent(),
      ),
      expect: () => [
        const AppState(Unit.imperial),
      ],
    );
  });
}

AppBloc buildAppBloc({FakeStorageManager? fakeStorageManager}) {
  return AppBloc(
    ApplicationLocalRepository(
      fakeStorageManager ?? FakeStorageManager(),
    ),
  );
}
