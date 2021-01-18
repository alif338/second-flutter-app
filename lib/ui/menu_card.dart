import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String idx;
  MenuCard({this.idx});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: (){
          print('Card Tappend');
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pixel_google.jpg'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalDirection: VerticalDirection.up,
              children: [
                Text("Rp20.000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                Text(idx),
              ],
            ),
          ),
        ),
      ),
    );
  }
}