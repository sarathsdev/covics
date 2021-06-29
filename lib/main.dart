
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:covics/slots.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'covics',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    //set time to load the new page
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('images/vaccine.png'),
            ),
            SizedBox(height:10),
            Text("COVICS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color:Colors.blue,
              ),)
          ],

        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pincodecontroller = TextEditingController();
  TextEditingController daycontroller = TextEditingController();
  String dropdownValue = '01';
  List slots = [];

  late final DropdownButton<String>? onChanged;
  get key => null;

  fetchslots() async {
    await http
        .get(Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
            pincodecontroller.text +
            '&date=' +
            daycontroller.text +
            '%2F' +
            dropdownValue +
            '%2F2021'))
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        slots = result['sessions'];
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Slot(
                slots: slots, key: key,
              )));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('COVICS'),
      backgroundColor: Colors.blue,),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
              children: [
                Center(
                  child: Container(
                    height: 380,
                    width: 380,
                    child: Lottie.asset('images/vaccinate.json'),
                  ),
                ),

            SizedBox(height:5.0),
            TextField(
              controller: pincodecontroller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)
                ),
                labelText: 'Enter Pincode',

              ),

            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: daycontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)
                          ),
                          labelText: 'Date',
                          ),
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                    child: Container(
                      height: 52,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,

                        underline: Container(
                          color: Colors.grey.shade400,
                          height: 2,
                        ),
                        onChanged: (String ? newValue) async {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },

                        items: <String>[
                          '01',
                          '02',
                          '03',
                          '04',
                          '05',
                          '06',
                          '07',
                          '08',
                          '09',
                          '10',
                          '11',
                          '12'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ))
              ],
            ),
            SizedBox(height: 40),
            Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      ),

                  onPressed: () {
                    fetchslots();

                  },
                  child: Text('Find Slots'),
                ))
          ]),
        ),
      ),
    );
  }
}