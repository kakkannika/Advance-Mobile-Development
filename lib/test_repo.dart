// import 'package:week_3_blabla_project/data/repository/local/local_ride_preferences_repository.dart';
// import 'package:week_3_blabla_project/model/location/locations.dart';
// import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

// void main() async {
//   // Initialize the repository
//   final repository = LocalRidePreferencesRepository();

//   // Create a new ride preference (example data)
//   final newPreference = RidePreference(
//     departure: Location(name: 'New York', country: Country.uk),
//     departureDate: DateTime.now(),
//     arrival: Location(name: 'Los Angeles', country: Country.uk),
//     requestedSeats: 3,
//   );

//   // Add the new preference
//   await repository.addPreference(newPreference);
//   print('New preference added successfully.');

//   // Fetch and print all stored preferences
//   final preferences = await repository.getPastPreferences();
//   print('Stored preferences:');
//   preferences.forEach((pref) {
//     print(pref.toString());  // Make sure the RidePreference model has a toString() method for printing
//   });
// }
