import 'package:feather/src/data/repository/local/application_local_repository.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_event.dart';
import 'package:feather/src/ui/settings/bloc/settings_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreenBloc
    extends Bloc<SettingsScreenEvent, SettingsScreenState> {
  final ApplicationLocalRepository _applicationLocalRepository;

  SettingsScreenBloc(this._applicationLocalRepository)
      : super(InitialSettingsScreenState()) {
    on<LoadSettingsScreenEvent>((event, emit) async {
      final unit = await _applicationLocalRepository.getSavedUnit();
      final savedRefreshTime =
          await _applicationLocalRepository.getSavedRefreshTime();
      final lastRefreshedTime =
          await _applicationLocalRepository.getLastRefreshTime();
      emit(
        LoadedSettingsScreenState(
          unit,
          savedRefreshTime,
          lastRefreshedTime,
        ),
      );
    });
    on<ChangeUnitsSettingsScreenEvent>((event, emit) {
      final unitsEvent = event;
      _applicationLocalRepository.saveUnit(unitsEvent.unit);
      if (state is LoadedSettingsScreenState) {
        final loadedState = state as LoadedSettingsScreenState;
        emit(loadedState.copyWith(unit: unitsEvent.unit));
      }
    });
    on<ChangeRefreshTimeSettingsScreenEvent>((event, emit) {
      _applicationLocalRepository.saveRefreshTime(event.refreshTime);
      if (state is LoadedSettingsScreenState) {
        final loadedState = state as LoadedSettingsScreenState;
        emit(loadedState.copyWith(refreshTime: event.refreshTime));
      }
    });
  }
}
