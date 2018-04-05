import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';
import 'package:watoplan/data/Provider.dart';

/**
 * This class takes a temporarily created Activity object and the field to edit.
 * NOTE: we are directly changing the object here because it is too cumbersome to
 *   generate a new state on every character change, instead we have a temporary object
 *   not part of the app state that holds data entry (this may not be the best solution though).
 */
class ActivityDataInput extends StatelessWidget {

  final Activity activity;
  final String field;

  ActivityDataInput({this.activity, this.field});
  
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: new TextField(
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontSize: 20.0,
        ),
        decoration: new InputDecoration(
          hintText: field
        ),
        onChanged: (String changed) {
          activity.data[field] = changed;
        },
      ),
    );
  }

}