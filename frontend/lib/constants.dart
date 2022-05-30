import 'package:flutter/material.dart';

// API
const String baseURL = "https://radiant-island-75261.herokuapp.com/";
const String searchApiEndpoint = "search/";
const String detailsApiEndpoint = "details/";

// Styles
const double defaultBorderWidth = 2;
const Duration defaultAnimationDuration = Duration(milliseconds: 500);
const Curve defaultAnimationCurve = Curves.easeInOut;
const double defaultBorderRadius = 26;

BoxShadow defaultBoxShadow() {
  return BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3), // changes position of shadow
  );
}
