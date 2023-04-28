import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oiva_app_flutter/colors.dart';
import 'package:oiva_app_flutter/data/feedback_model.dart';
import 'package:oiva_app_flutter/fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oiva_app_flutter/ui/search_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({Key key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();
  double _starRating1 = 0;
  double _starRating2 = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.defaultBackground,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Miten arvioisit sovelluksen toimivuutta?",
                style: AppFonts.regular(18),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: _starRating1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.defaultForeground,
                ),
                onRatingUpdate: (rating) {
                  _starRating1 = rating;
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Kuinka tarpeelliseksi koit sovelluksen?",
                style: AppFonts.regular(18),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: _starRating2,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.defaultForeground,
                ),
                onRatingUpdate: (rating) {
                  _starRating2 = rating;
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Vapaa palaute",
                style: AppFonts.regular(18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                controller: _textEditingController,
                minLines: 2,
                maxLines: 8,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  fillColor: AppColors.white,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context).feedbackSubmit,
                  style: AppFonts.regular(22, color: AppColors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  _saveFeedback();
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  primary: AppColors.defaultForeground,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveFeedback() async {
    // Get device id
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo != null && androidInfo.androidId != null) {
      // Get database reference
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference ref = database.ref("oivaApp/feedback");
      DatabaseReference child = ref.child(androidInfo.androidId +
          "-" +
          DateTime.now().millisecondsSinceEpoch.toString());

      // Save data
      FeedbackModel model = FeedbackModel(
          _starRating1,
          _starRating2,
          _textEditingController.text,
          DateTime.now().toUtc().toIso8601String(),
          androidInfo.androidId);
      await child.set(model.toJson());
    }
  }
}
