import 'package:flutter/material.dart';
import 'package:wifi_scanning_flutter/models/customised_result.dart';
import 'package:wifi_scanning_flutter/screens/demo/db_operations.dart';
import 'package:tuple/tuple.dart';

class DialogsCreator {
  DatabaseOperations databaseOperations = DatabaseOperations();

  Future<void> createResultConfirmingDialog(BuildContext context, bool hasMatch,
      double strongestNPercentInRssi, double similarityThr, double similarity) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Result"),
            content: Text("The predicted matching result is: $hasMatch with similarity ${similarity.toStringAsFixed(2).toString()}"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await databaseOperations.insertResultToDb(
                        new CustomisedResult(strongestNPercentInRssi,
                            similarityThr, similarity, hasMatch, true));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This result has been saved."),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: Text("Correct")),
              TextButton(
                  onPressed: () async {
                    await databaseOperations.insertResultToDb(
                        new CustomisedResult(strongestNPercentInRssi,
                            similarityThr, similarity, hasMatch, false));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("This result has been saved."),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: Text("Wrong")),
            ],
          );
        });
  }

  double strongestNPercentInRssi = 0;
  double similarityThr = 0;

  Future<Tuple2<double, double>> createParameterAdjustingDialog(
      BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          double newStrongestNPercentInRssi = 0;
          double newSimilarityThr = 0;
          //need to wrap the dialog inside a stateful widget otherwise
          //the sliders don't slide
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Please adjust the matching parameters"),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    "Filter Percentage: ${strongestNPercentInRssi.toStringAsFixed(2)}"),
                Slider(
                    value: strongestNPercentInRssi,
                    min: 0,
                    max: 1,
                    onChanged: (double val) {
                      //print(val.toString());
                      setState(() {
                        newStrongestNPercentInRssi = val;
                        strongestNPercentInRssi = newStrongestNPercentInRssi;
                      });
                    }),
                Text(
                    "Similarity Threshold: ${similarityThr.toStringAsFixed(2)}"),
                Slider(
                    value: similarityThr,
                    min: 0,
                    max: 1,
                    onChanged: (double val) {
                      //print(val.toString());
                      setState(() {
                        newSimilarityThr = val;
                        similarityThr = newSimilarityThr;
                      });
                    }),
              ]),
            );
          });
        });
    return Tuple2<double, double>(strongestNPercentInRssi, similarityThr);
  }
}
