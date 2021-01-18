import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/restaurant_favorite_page.dart';
import 'package:restaurant_app/ui/restaurant_search_page.dart';
import 'package:restaurant_app/provider/enum/result_state.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/data/preferences/preferences_provider.dart';

class RestaurantHomePage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  @override
  _RestaurantHomePageState createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  bool isSearching = false;
  bool isConnected = false;

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  @override
  void initState() {
    checkStatus();
    super.initState();
    port.listen((_) async => await _service.someTask());
    _notificationHelper.configureSelectNotificationSubject(
      RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: !isSearching ? Text("Restaurant List")
        : TextField(
          style: TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search of Restaurant',
          ),
          onEditingComplete: (){
            setState(() {
              this.isSearching = !this.isSearching;
            });
          },
          onSubmitted: (text) {
            print(text);
            Navigator.pushNamed(context, RestaurantSearchPage.routeName,
            arguments: text);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                this.isSearching = !this.isSearching;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top :8.0),
        child: isConnected ? Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.HasData) {
              return ListView.builder(
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, eatIdx) {
                  var resItem = state.result.restaurants[eatIdx];
                  return _restaurantItems(context, resItem);
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ) : Center(
          child: Column(
            children: [
              Text('Connection not found'),
              Text('Check your connections'),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Restaurant'),
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: AssetImage('assets/pixel_google2.jpg'),
                  fit: BoxFit.cover
                )
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorite List'),
              onTap: () {
                Navigator.pushNamed(context, RestaurantFavoritePage.routeName);
              },
            ),
            Consumer<PreferencesProvider>(
              builder: (context, provider, _) {
                return ListTile(
                  title: Text('Enable Scheduler'),
                  trailing: Consumer<SchedulingProvider>(
                    builder: (context, scheduled,_) {
                      return Switch.adaptive(
                        value: provider.isDailyNotifyActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            Fluttertoast.showToast(
                                msg: "This feature is unavailable",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black54,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else {
                            scheduled.scheduledRestaurant(value);
                            provider.enableDailyNotify(value);
                            if (value) {
                              Fluttertoast.showToast(
                                  msg: "Scheduler Activated",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Scheduler Deactivated",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }

                          }
                        },
                      );
                    }
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  checkStatus() async {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
        setState(() {
          this.isConnected = !this.isConnected;
        });
      }
    });
  }
}

Widget _restaurantItems(BuildContext context, element) {
  return Material(
    child:InkWell(
      onTap: () => Navigation.intentWithData(RestaurantDetailPage.routeName, element),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    child: element.pictureId == null
                    ? Container(width: 100, child: Icon(Icons.error),)
                    : Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/' + element.pictureId,
                      width: 120,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(element.name, style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.location_city, size: 15,),
                            Text(element.city ?? "")
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.star_rate_sharp, color:Colors.amber, size: 15,),
                            Text(element.rating.toString() ?? ""),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Divider(color: Colors.blueGrey, indent: 10,endIndent: 10,)
        ],
      ),
    ),
  );
}
