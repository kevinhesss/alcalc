import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBbICdxeKThIaITQuTGK-NrubtwzyYjoPo",
        authDomain: "alculator-ee2b5.firebaseapp.com",
        projectId: "alculator-ee2b5",
        storageBucket: "alculator-ee2b5.appspot.com",
        messagingSenderId: "688366562269",
        appId: "1:688366562269:web:6b9e4906a2760318f92434",
        measurementId: "G-9CQXPPBN4N"),
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlcoholCalculator(),
    );
  }
}
class AlcoholCalculator extends StatefulWidget {
  @override
  _AlcoholCalculatorState createState() => _AlcoholCalculatorState();
}

class _AlcoholCalculatorState extends State<AlcoholCalculator> {
  String? _inputType = "Shots of Aubrey's Gin";
  String? _outputType = "Shots of Aubrey's Gin";
  double? _inputABV;
  double? _outputABV;
  String? _result;
  double? _inputAmountInOz;
  double? _outputAmountInOz;
  double? _enteredAmount;
  List<String> _drinkNames = [];

  @override
  void initState() {
    super.initState();
    fetchABVs();
    fetchDrinkNames();
  }

  Future<void> fetchDrinkNames() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Dranks').get();
    List<String> loadedNames =
    snapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      _drinkNames = loadedNames;
    });
  }

  Future<void> fetchABVs() async {
    final inputTypeDoc = await FirebaseFirestore.instance
        .collection('Dranks')
        .where('name', isEqualTo: _inputType)
        .get();
    final outputTypeDoc = await FirebaseFirestore.instance
        .collection('Dranks')
        .where('name', isEqualTo: _outputType)
        .get();

    if (inputTypeDoc.docs.isNotEmpty) {
      setState(() {
        _inputABV = inputTypeDoc.docs.first['ABV'];
        _inputAmountInOz = inputTypeDoc.docs.first['amount'];
      });
    }

    if (outputTypeDoc.docs.isNotEmpty) {
      setState(() {
        _outputABV = outputTypeDoc.docs.first['ABV'];
        _outputAmountInOz = outputTypeDoc.docs.first['amount'];
      });
    }
    calculateResult();
  }

  void calculateResult() {
    if (_enteredAmount != null &&
        _inputABV != null &&
        _outputABV != null &&
        _inputAmountInOz != null &&
        _outputAmountInOz != null) {
      double outputtedNumber =
          (_enteredAmount! * _inputAmountInOz! * _inputABV!) /
              (_outputAmountInOz! * _outputABV!);

      setState(() {
        _result =
        'There is the equivalent of ${outputtedNumber.toStringAsFixed(2)} $_outputType in $_enteredAmount $_inputType';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('How many',
                    style:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _drinkNames.where((String name) {
                      return name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _outputType = selection;
                    });
                    fetchABVs();
                    calculateResult();
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Shots of Aubrey's Gin",
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      textAlign: TextAlign.center,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
                Text('Are in',
                    style:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _enteredAmount = double.tryParse(value);
                    });
                    calculateResult();
                  },
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _drinkNames.where((String name) {
                      return name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _inputType = selection;
                    });
                    fetchABVs();
                    calculateResult();
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Shots of Aubrey's Gin",
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      textAlign: TextAlign.center,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
                if (_result != null)
                  Text(
                    '$_result',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}