import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wifi_scanning_flutter/screens/user/widgets/question_card.dart';

class CommonQuestionsPage extends StatefulWidget {
  CommonQuestionsPage({Key key}) : super(key: key);

  @override
  _CommonQuestionsPageState createState() => _CommonQuestionsPageState();
}

class _CommonQuestionsPageState extends State<CommonQuestionsPage> {
  final Color kingsBlue = HexColor('#0a2d50');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Common Questions",
            style: TextStyle(
                fontFamily: "MontserratRegular", fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: kingsBlue,
        ),
        body: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            QuestionCard(question: "What is COVID-19?", answer: 
"""Coronaviruses (CoV) are a large family of viruses that cause illness ranging from the common cold to more serious diseases such as Severe Acute Respiratory Syndrome (SARS-CoV). 
\nThe 2019 novel coronavirus is a new strain that has not been seen in humans until now and has caused viral pneumonia. It was first linked to Wuhan’s South China Seafood City market which is a wholesale market for seafood and live animals in December 2019.
\nThe virus has now been detected in several areas throughout China, along with countries across Asia, North and South America, Europe, Africa and Oceana.""").getQuestionCard(),
            QuestionCard(question: "How does COVID-19 spread?", answer:
"Coronavirus is spread through the air by droplets and smaller particles (known as aerosols) that are exhaled from the nose and mouth of an infected person as they breathe, speak or cough. They behave in a similar way to smoke but are invisible. The majority of virus transmissions happen indoors.").getQuestionCard(),
            QuestionCard(question: "What are the symptoms of COVID-19?", answer: 
"""COVID-19 affects different people in different ways. Most infected people will develop mild to moderate illness and recover without hospitalization.
\nMost common symptoms:
- fever
- dry cough
- tiredness

Less common symptoms:
- aches and pains.
- sore throat.
- diarrhoea.
- conjunctivitis.
- headache.
- loss of taste or smell.
- a rash on skin, or discolouration of fingers or toes.

Serious symptoms:
- difficulty breathing or shortness of breath.
- chest pain or pressure.
- loss of speech or movement.

Seek immediate medical attention if you have serious symptoms. Always call before visiting your doctor or health facility. 
\nPeople with mild symptoms who are otherwise healthy should manage their symptoms at home. 
\nOn average it takes 5–6 days from when someone is infected with the virus for symptoms to show, however it can take up to 14 days. 
""").getQuestionCard(),
            QuestionCard(question: "What should I do if I have symptoms?", answer: 
"""- Get a test to check if you have coronavirus as soon as possible.
- You and anyone you live with should stay at home and not have visitors until you get your test result – only leave your home to have a test.
""").getQuestionCard(),
            QuestionCard(question: "What can I do to prevent spreading of COVID-19?", answer: 
"""Coronavirus is spread through the air by droplets and smaller particles (known as aerosols) that are exhaled from the nose and mouth of an infected person as they breathe, speak or cough. They behave in a similar way to smoke but are invisible. The majority of virus transmissions happen indoors.
\nWhat you can do:
- Wash your hands with soap and water often, for at least 20 seconds
- Use hand sanitiser gel if soap and water are not available
- Cover your mouth and nose with a tissue or your sleeve (not your hands) when you cough or sneeze
- Put used tissues in the bin immediately and wash your hands afterwards
- Clean objects and surfaces you touch often (such as door handles, kettles and phones) using your regular cleaning products
- Consider wearing a face covering when in shared spaces
- Keep windows open in the room you're staying in and shared spaces as much as possible   

What you can't do:
- Share towels, including hand towels and tea towels
""").getQuestionCard(),
            QuestionCard(question: "Where can I get help if it's an emergency?", answer: 
"""If the person who needs help is aged under 5, call 111.
\nOtherwise, call 999 if:
- Signs of a heart attack - pain like a very tight band, heavy weight or squeezing in the centre of your chest
- Signs of a stroke - face drooping on one side, can’t hold both arms up, difficulty speaking
- Severe difficulty breathing - not being able to get words out, choking or gasping
- Heavy bleeding - that won’t stop
- Severe injuries - or deep cuts after a serious accident
- Seizure (fit) - someone is shaking or jerking because of a fit, or is unconscious (can’t be woken up)
- Sudden, rapid swelling - of the eyes, lips, mouth, throat or tongue
""").getQuestionCard(),
            QuestionCard(question: "What should I do if I have been advised to self-isolate?", answer: 
"""- Do not go to your work, school, GP surgery, hospital, or public areas, and do not use public transport or taxis
- Do not go out to get food and medicine - order it online or by phone, or ask someone to bring it to your home
- Do not have visitors in your home, including friends and family, except for people providing essential care
- Do not go out to exercise - exercise at home or in your garden""").getQuestionCard(),
            QuestionCard(question: "Where can I get extra help?", answer: 
"""In England, contact the NHS volunteer responder service if there are no friends and family nearby who can help, by calling 0808 196 3646 (8am to 8pm 7 days a week). This number is free from any phone. 
\nNHS volunteers are people in your community who have offered to help by picking up groceries, collecting prescriptions, and talking to you if you need support.
""").getQuestionCard(),
          ],
        ),
      ),
    );
  }
}
