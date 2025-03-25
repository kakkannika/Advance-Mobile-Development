import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> _pastPreferences;
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _pastPreferences = AsyncValue.loading();
    fetchPastPreferences();
  }

  // Getter for pastPreferences to safely access the data
  AsyncValue<List<RidePreference>> get pastPreferences => _pastPreferences;

  Future<void> fetchPastPreferences() async {
    _pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      final List<RidePreference> prefs = await repository.getPastPreferences();
      _pastPreferences = AsyncValue.success(prefs);
    } catch (error) {
      _pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreferrence(RidePreference pref) {
    if (_currentPreference != pref) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  Future<void> _addPreference(RidePreference preference) async {
    if (_pastPreferences.state == AsyncValueState.success && 
        _pastPreferences.data != null) {
      final List<RidePreference> currentData = _pastPreferences.data!;
      
      if (!currentData.contains(preference)) {
        try {
          await repository.addPreference(preference);
          currentData.add(preference);
          _pastPreferences = AsyncValue.success(currentData);
          notifyListeners();
        } catch (error) {
          _pastPreferences = AsyncValue.error(error);
          notifyListeners();
        }
      }
    } else {
      try {
        await repository.addPreference(preference);
        fetchPastPreferences();
      } catch (error) {
        _pastPreferences = AsyncValue.error(error);
        notifyListeners();
      }
    }
  }

  List<RidePreference> get preferencesHistory {
    if (_pastPreferences.state == AsyncValueState.success && 
        _pastPreferences.data != null) {
      return _pastPreferences.data!.reversed.toList();
    }
    return [];
  }
}
