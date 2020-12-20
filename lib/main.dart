import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var calculationResults = "";
  var currentOperation = "";
  var currentNumber = "";
  var currentSymbol = "";

  var resultTextColor = Colors.grey[800];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height * 0.3),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(currentOperation, style: TextStyle(fontSize: 24)),
                    SizedBox(
                      height: 16,
                    ),
                    Text(calculationResults,
                        style: TextStyle(fontSize: 40, color: resultTextColor)),
                  ],
                ),
              ),
            ),
            Container(
              height: getNumbPadHeight(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  getRow("C", "(", ")", " / ", Colors.green),
                  getRow("7", "8", "9", " x ", Colors.pink),
                  getRow("4", "5", "6", " - ", Colors.blue),
                  getRow("1", "2", "3", " + ", Colors.orange),
                  getRow("0", "", ".", " = ", Colors.green),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double getNumbPadHeight() {
    return MediaQuery.of(context).size.height * 0.7 -
        MediaQuery.of(context).padding.top;
  }

  double getButtonHeight() {
    return getNumbPadHeight() / 5;
  }

  double getButtonWidth() {
    return MediaQuery.of(context).size.width / 4;
  }

  Widget getButton(buttonValue, color) {
    return Container(
      height: getButtonHeight(),
      width: getButtonWidth(),
      padding: EdgeInsets.all(20),
      child: TextButton(
        onPressed: () => buttonPressed(buttonValue),
        child: Text(
          buttonValue,
          style: TextStyle(color: Colors.grey[800], fontSize: 30),
        ),
      ),
    );
  }

  buttonPressed(String text) {
    if (text == 'C') {
      clearScreen();
    } else if (text.trim() == '=') {
      operationResult();
    } else if (checkStrNumb(text)) {
      calculate(text);
    } else if (checkOperation()) {
      changeOperation(text);
    } else {
      calculate(text);
    }
  }

  clearScreen() {
    setState(() {
      currentOperation = '';
      currentNumber = '';
      calculationResults = '';
    });
  }

  operationResult() {
    setState(() {
      currentOperation = calculationResults;
      currentNumber = '';
      resultTextColor = Colors.black;
    });
  }

  Widget getSymbol(buttonValue, color) {
    return Container(
      height: getButtonHeight(),
      width: getButtonWidth(),
      padding: EdgeInsets.all(20),
      child: TextButton(
        onPressed: () => buttonPressed(buttonValue),
        child: Text(
          buttonValue,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        style:
            TextButton.styleFrom(shape: CircleBorder(), backgroundColor: color),
      ),
    );
  }

  void calculate(buttonValue) {
    var newValue = currentOperation + buttonValue;
    if (checkStrNumb(buttonValue))
      currentNumber = currentNumber + buttonValue;
    else
      currentNumber = '';
    setState(() {
      currentOperation = newValue;
      try {
        calculationResults = ExpressionEvaluator()
            .eval(Expression.parse(currentOperation.replaceAll('x', '*')), null)
            .toString();
        resultTextColor = Colors.grey[800];
      } catch (e) {}
    });
  }

  getRow(first, second, third, fourth, fourthColor) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          getButton(first, Colors.white),
          getButton(second, Colors.white),
          getButton(third, Colors.white),
          getSymbol(fourth, fourthColor),
        ],
      ),
    );
  }

  bool checkStrNumb(number) {
    if (number == '1' ||
        number == '2' ||
        number == '3' ||
        number == '4' ||
        number == '5' ||
        number == '6' ||
        number == '7' ||
        number == '8' ||
        number == '9' ||
        number == '0' ||
        number == '(' ||
        number == ')' ||
        number == '.') {
      return true;
    } else
      return false;
  }

  bool checkOperation() {
    if (currentOperation.trim().endsWith('/') ||
        currentOperation.trim().endsWith('x') ||
        currentOperation.trim().endsWith('+') ||
        currentOperation.trim().endsWith('-'))
      return true;
    else
      return false;
  }

  changeOperation(operation) {
    setState(() {
      var last = currentOperation.length;
      currentOperation = currentOperation
          .trim()
          .replaceRange(last - 2, last - 1, '${operation.toString().trim()} ');
    });
  }
}
