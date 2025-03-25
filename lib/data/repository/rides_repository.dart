import 'package:week_3_blabla_project/model/ride/ride.dart';
import 'package:week_3_blabla_project/model/ride/ride_filter.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

abstract class RidesRepository {
  List<Ride> getRidesFor(RidePreference ridePreference, RideFilter? rideFilter);
}
