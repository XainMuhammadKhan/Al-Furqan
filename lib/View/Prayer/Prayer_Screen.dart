import 'package:adhan/adhan.dart';
import 'package:alfurqan/ViewModel/controller/Prayer/prayer_screen_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/fonts/App_Fonts.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerScreen extends StatefulWidget {
  PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  PrayerScreenController _c = PrayerScreenController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBgColor,
      body: FutureBuilder(
        future: _c.getLoc(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final myCoordinates = Coordinates(
            24.956666373717386,
            67.06033229839285,
          );
          final params = CalculationMethod.karachi.getParameters();
          params.madhab = Madhab.hanafi;
          final prayerTimes = PrayerTimes.today(myCoordinates, params);
          // Build a Home-like header and place prayer times in an overlapping white card
          final size = MediaQuery.of(context).size;
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header (same as HomeScreen)
                Container(
                  height: size.height * 0.30,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(AppImages.background, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat(
                                  'EEE, d MMM yyyy',
                                ).format(DateTime.now()),
                                style: AppFonts.montserratStyle(
                                  color: AppColors.primaryTextColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Prayer Timings',
                                style: AppFonts.montserratStyle(
                                  color: AppColors.primaryTextColor,
                                  size: 18,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Overlapping card with prayer list
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.splashGrad1,
                            AppColors.splashGrad2,
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Frame image on top like AyaCard
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Image.asset(
                                AppImages.ayaframe,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Prayer Timings',
                                    textAlign: TextAlign.center,
                                    style: AppFonts.montserratStyle(
                                      weight: FontWeight.w700,
                                      color: AppColors.primaryTextColor
                                          .withOpacity(0.95),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 80,
                                  child: Divider(
                                    color: AppColors.primaryTextColor
                                        .withOpacity(0.6),
                                    thickness: 2,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                _buildPrayerRowStyled(
                                  'Fajr',
                                  DateFormat.jm().format(prayerTimes.fajr),
                                ),
                                Divider(
                                  color: AppColors.primaryTextColor.withOpacity(
                                    0.25,
                                  ),
                                  thickness: 1,
                                ),
                                _buildPrayerRowStyled(
                                  'Sunrise',
                                  DateFormat.jm().format(prayerTimes.sunrise),
                                ),
                                Divider(
                                  color: AppColors.primaryTextColor.withOpacity(
                                    0.25,
                                  ),
                                  thickness: 1,
                                ),
                                _buildPrayerRowStyled(
                                  'Duhr',
                                  DateFormat.jm().format(prayerTimes.dhuhr),
                                ),
                                Divider(
                                  color: AppColors.primaryTextColor.withOpacity(
                                    0.25,
                                  ),
                                  thickness: 1,
                                ),
                                _buildPrayerRowStyled(
                                  'Asr',
                                  DateFormat.jm().format(prayerTimes.asr),
                                ),
                                Divider(
                                  color: AppColors.primaryTextColor.withOpacity(
                                    0.25,
                                  ),
                                  thickness: 1,
                                ),
                                _buildPrayerRowStyled(
                                  'Maghrib',
                                  DateFormat.jm().format(prayerTimes.maghrib),
                                ),
                                Divider(
                                  color: AppColors.primaryTextColor.withOpacity(
                                    0.25,
                                  ),
                                  thickness: 1,
                                ),
                                _buildPrayerRowStyled(
                                  'Isha',
                                  DateFormat.jm().format(prayerTimes.isha),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrayerRow(String label, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.montserratStyle(
              color: AppColors.secondaryTextColor,
              size: 18,
              weight: FontWeight.w600,
            ),
          ),
          Text(
            time,
            style: AppFonts.montserratStyle(
              color: AppColors.secondaryTextColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRowStyled(String label, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.montserratStyle(
              color: AppColors.primaryTextColor,
              size: 18,
              weight: FontWeight.w700,
            ),
          ),
          Text(
            time,
            style: AppFonts.montserratStyle(
              color: AppColors.primaryTextColor,
              size: 16,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
