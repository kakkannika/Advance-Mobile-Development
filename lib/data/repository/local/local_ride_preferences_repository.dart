import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ride_preference_dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  // Fetch past preferences from SharedPreferences
  Future<List<RidePreference>> getPastPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsList = prefs.getStringList(_preferencesKey) ?? [];
      return prefsList
          .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      // Handle any errors that might occur
      print("Error fetching past preferences: $e");
      return [];
    }
  }

  // Add a new preference to SharedPreferences
  Future<void> addPreference(RidePreference preference) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsList = await getPastPreferences();
      prefsList.add(preference);

      // Save the new list as a string list
      await prefs.setStringList(
        _preferencesKey,
        prefsList.map((pref) => jsonEncode(RidePreferenceDto.toJson(pref))).toList(),
      );

     
      print("Preferences saved: ${prefs.getStringList(_preferencesKey)}");
    } catch (e) {
      
      print("Error adding preference: $e");
    }
  }
}