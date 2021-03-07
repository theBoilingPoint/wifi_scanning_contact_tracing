import 'package:flutter/material.dart';

class StepCard extends StatefulWidget {
  final int stepNum;
  final String description;
  final List buttons;

  StepCard({Key key, this.stepNum, this.description, this.buttons})
      : super(key: key);

  @override
  _StepCardState createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("Step ${widget.stepNum.toString()}"),
          SizedBox(height: 15,),
          Text(widget.description),
          SizedBox(height: 15,),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.buttons.length,
            itemBuilder: (context, index) {
              return widget.buttons[index];
            }
          ),
        ],
      ),
    );
  }
}
