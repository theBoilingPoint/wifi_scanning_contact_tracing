import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/symptom.dart';

class SymptomsDatePicker extends StatefulWidget {
  final Function notifyParent;
  SymptomsDatePicker({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _SymptomsDatePickerState createState() => _SymptomsDatePickerState();
}

class _SymptomsDatePickerState extends State<SymptomsDatePicker> {
  DateTime selectedDate = DateTime.now();
  final Color kingsBlue = HexColor('#0a2d50');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Symptoms Appearing Date",
          style: TextStyle(
            fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
        ),
        backgroundColor: kingsBlue,  
      ),
      body: Container(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 50),
              children: [
                Text(
                  "If you are feeling uncomfortable at the moment, can you remember when the symptom(s) occurred?",
                  style: TextStyle(
                    fontFamily: "MontserratRegular", 
                    fontSize: 30
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    "Yes, I can.",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(kingsBlue), 
                  ),
                  onPressed: () async {
                    final DateTime newSelectedDate = await showDatePicker(
                      context: context, 
                      initialDate: selectedDate, 
                      firstDate: selectedDate.add(Duration(days: -9)), 
                      lastDate: selectedDate,
                    );
                    if(newSelectedDate != null && newSelectedDate.isBefore(selectedDate)){
                      selectedDate = newSelectedDate;
                      print("The selected date: " + selectedDate.toString());
                      showSymptomsList();
                    }
                  }, 
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text(
                    "No, I can't.",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(kingsBlue)),
                  onPressed: (){
                    showSymptomsList();
                  }, 
                ),
              ],
            ),
          ),
        ),
      );
  }

  showSymptomsList() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new SymptomsCheckPage(
          notifyParent: widget.notifyParent,
          symptomsAppearingDate: selectedDate
        )
      )
    );
  }
}