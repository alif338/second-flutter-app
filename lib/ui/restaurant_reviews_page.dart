import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/reviews.dart';

class RestaurantReviewsPage extends StatefulWidget {
  static const routeName = '/restaurant_feedback';
  final dynamic element;
  RestaurantReviewsPage({this.element});
  _RestaurantReviewsPageState createState() => _RestaurantReviewsPageState(title: element);
}

Future<Reviews> createFeedback(String name, String review, String id) async {

  final String apiUrl = 'https://restaurant-api.dicoding.dev/review';
  Map<String, String> headers = {
    'Content-Type' : 'application/json',
    'X-Auth-Token' : '12345'
  };
  final response = await http.post(
      apiUrl,
      body: jsonEncode(<String, String>{
        'id': id,
        'name': name,
        'review': review,
      }),
      headers: headers);

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(response.statusCode);
    return reviewsFromJson(response.body);
  } else {
    print(response.statusCode);
    print(jsonDecode(response.body));
    throw Exception("Failed to upload");
  }
}

class _RestaurantReviewsPageState extends State<RestaurantReviewsPage>{
  bool isConnected = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  final dynamic title;
  _RestaurantReviewsPageState({this.title});

  @override
  void initState() {
    checkStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isConnected ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Review Anda",
            style: Theme.of(context).textTheme.headline5,),
            Text(title.name + ' - ' + title.city,
              style: Theme.of(context).textTheme.headline4),
            Divider(color: Colors.grey,),
            Text("Name : "),
            TextField(
              controller: nameController,
            ),
            SizedBox(height: 8,),
            Text("Review : "),
            TextField(
              controller: reviewController,
            ),
            SizedBox(height: 8,),
            Text("Tanggal dibuat : ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"),
            SizedBox(height: 8,),
            SubmitButton(nameController: nameController, reviewController: reviewController, title: title),
          ],
        ) : Center(
          child: Column(
            children: [
              Text('Connnection not found'),
              FlatButton(
                  onPressed: (){
                    setState(() {
                      initState();
                    });
                  },
                  child: Text('Tap to reload'))
            ],
          ),
        ),
      ),
    );
  }

  checkStatus() async {
    var event = await Connectivity().checkConnectivity();
    if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
      setState(() {
        this.isConnected = !this.isConnected;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
    @required this.nameController,
    @required this.reviewController,
    @required this.title,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController reviewController;
  final  title;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Submit"),
      onPressed: () async {
        final String name = nameController.text;
        final String review = reviewController.text;
        await createFeedback(name, review, title.id);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Review Anda berhasil dikirimkan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    );
  }
}