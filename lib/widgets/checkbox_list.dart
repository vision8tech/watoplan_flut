import 'package:flutter/material.dart';

typedef bool ValueActive(String match);
typedef void OnCheckChange(bool selected, String entry);

class CheckboxList<T> extends StatefulWidget {

  final List<T> values;
  final List<String> entries;
  final Color color;
  final ValueActive isActive;
  final OnCheckChange onChange;

  CheckboxList({ List values, this.entries, this.color, this.isActive, this.onChange }) : values = values ?? entries;

  @override
  State<CheckboxList> createState() => CheckboxListState();

}

class CheckboxListState extends State<CheckboxList> {



  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<int>.generate(widget.entries.length, (i) => i).map(
        (i) => CheckboxListTile(
          value: widget.isActive(widget.values[i]),
          title: Text(widget.entries[i]),
          activeColor: widget.color,
          onChanged: (bool selected) {
            widget.onChange(selected, widget.values[i]);
            setState(() {  });
          },
        )
      ).toList(),
    );
  } 

}
