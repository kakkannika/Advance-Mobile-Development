import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/ui/provider/ride_pref_provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

/// This screen allows the user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  // onRidePrefSelected method updated to use the provider
  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference using the provider
    Provider.of<RidesPreferencesProvider>(context, listen: false)
        .setCurrentPreferrence(newPreference);

    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));

    // 3 - No need to call setState as the provider will notify listeners
  }

  @override
Widget build(BuildContext context) {
  final ridePreferencesProvider = Provider.of<RidesPreferencesProvider>(context);

  // Get the state of the past preferences 
  final pastPreferencesState = ridePreferencesProvider.pastPreferences;

  // Check the state of the past preferences
  if (pastPreferencesState.state == AsyncValueState.loading) {
    return const BlaError(message: 'Loading...');
  }

  if (pastPreferencesState.state == AsyncValueState.error) {
    return const BlaError(message: 'No connection. Try later');
  }

  if (pastPreferencesState.state == AsyncValueState.success) {
    List<RidePreference> pastPreferences = pastPreferencesState.data!;

    return Stack(
      children: [
        const BlaBackground(),
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text("Your pick of rides at low price", style: BlaTextStyles.heading.copyWith(color: Colors.white)),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  RidePrefForm(
                    initialPreference: ridePreferencesProvider.currentPreference,
                    onSubmit: (newPreference) => onRidePrefSelected(context, newPreference),
                  ),
                  SizedBox(height: BlaSpacings.m),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: pastPreferences.length,
                      itemBuilder: (ctx, index) => RidePrefHistoryTile(
                        ridePref: pastPreferences[index],
                        onPressed: () => onRidePrefSelected(context, pastPreferences[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  return const BlaError(message: 'Unexpected error occurred');
}

}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, 
      ),
    );
  }
}

class BlaError extends StatelessWidget {
  const BlaError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: BlaSpacings.m, right: BlaSpacings.m, top: BlaSpacings.s),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/blabla_wifi.png', // Error image asset
              fit: BoxFit.none, // Adjust image fit to cover the container
            ),
            Text(
              message,
              style: BlaTextStyles.heading.copyWith(color: BlaColors.textNormal),
            ),
          ],
        ),
      ),
    ));
  }
}
