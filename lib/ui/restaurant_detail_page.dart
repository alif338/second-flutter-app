import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/api/api_restaurant_detail.dart';
import 'package:restaurant_app/data/db/database_provider.dart';
import 'package:restaurant_app/provider/detail_provider.dart';
import 'package:restaurant_app/ui/restaurant_reviews_page.dart';
import 'menu_card.dart';
import 'package:restaurant_app/provider/enum/result_state.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final dynamic element;
  RestaurantDetailPage({@required this.element});


  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isConnected = false;


  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailProvider>(
        create: (context) => DetailProvider(restaurantDetail: ApiRestaurantDetail(baseId: widget.element.id)),
        child: isConnected ? ListMenus(element: widget.element,) :
    Scaffold(
      appBar: AppBar(
        title: Text('Something when wrong'),
      ),
      body:Center(
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
    ));
  }

  checkStatus() async {
    var event = await Connectivity().checkConnectivity();
      if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
        setState(() {
          this.isConnected = !this.isConnected;
        });
      }
  }
}

class ListMenus extends StatefulWidget {
  const ListMenus({Key key, @required this.element,}) : super(key: key);
  final dynamic element;

  @override
  _ListMenusState createState() => _ListMenusState();
}

class _ListMenusState extends State<ListMenus> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.element.name),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Consumer<DetailProvider>(
                  builder: (context, state, _){
                    if (state.states == ResultState.HasData) {
                      return Image.network('https://restaurant-api.dicoding.dev/images/medium/' +
                          state.result.restaurant.pictureId);
                    } else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  } //
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Consumer<DatabaseProvider>(
                        builder: (context, provider, child) {
                          return FutureBuilder<bool>(
                              future: provider.isFavorited(widget.element.id),
                              builder: (context, snapshot) {
                                var isFavorited = snapshot.data ?? false;
                                var id = widget.element.id;
                                return isFavorited
                                  ? IconButton(
                                  highlightColor: Colors.white,
                                  icon: Icon(Icons.favorite, color: Colors.red,),
                                  onPressed: () {
                                    provider.removeFavorite(id);
                                    Fluttertoast.showToast(
                                        msg: "Remove from Favorite",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black54,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );

                                  },
                                ) : IconButton(
                                  icon: Icon(Icons.favorite_border, color : Colors.red),
                                  onPressed: () {
                                    provider.addFavorite(widget.element);
                                    Fluttertoast.showToast(
                                        msg: "Added to Favorite",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black54,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );

                                  },
                                );

                              }
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<DetailProvider>(
                    builder: (context, state, child) {
                      if (state.states == ResultState.HasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.result.restaurant.name + ' - ' + state.result.restaurant.city,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(height: 8,),
                            Text("Food & Drinks",
                              style: Theme.of(context).textTheme.caption,),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                Icon(Icons.star_rate_sharp, color:Colors.amber, size: 25,),
                                Text(state.result.restaurant.rating.toString()+ "      "),
                                Icon(Icons.location_on_outlined, size: 25,),
                                Text(state.result.restaurant.address)
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text("Kategori : "),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(state.result.restaurant.categories.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right :8.0, top: 8),
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          state.result.restaurant.categories[index].name,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Divider(color: Colors.grey,),
                            Text("Deskripsi Toko",style: Theme.of(context).textTheme.headline5,),
                            SizedBox(height: 8,),
                            Text(state.result.restaurant.description),
                            Divider(color: Colors.grey,),
                            Text("Daftar Menu", style: Theme.of(context).textTheme.headline5,),
                            SizedBox(height: 8,),
                            Text("Foods", style: Theme.of(context).textTheme.headline6,),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator(),);
                      }
                    }
                  ),

                  Container(
                    child: Consumer<DetailProvider>(
                      builder: (context, state, _){
                        if (state.states == ResultState.HasData) {
                          return GridView.count(
                            physics: ScrollPhysics(),
                            crossAxisCount: 2,
                            padding: EdgeInsets.all(5),
                            shrinkWrap: true,
                            children: List.generate(state.result.restaurant.menus.foods.length,
                              (index) => MenuCard(idx: state.result.restaurant.menus.foods[index].name,)
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Divider(color: Colors.grey,),
                  Text("Drinks", style: Theme.of(context).textTheme.headline6,),
                  Container(
                    child: Consumer<DetailProvider>(
                      builder: (context,state,_) {
                        if (state.states == ResultState.HasData) {
                          return GridView.count(
                            physics: ScrollPhysics(),
                            crossAxisCount: 2,
                            padding: EdgeInsets.all(5),
                            shrinkWrap: true,
                            children: List.generate(state.result.restaurant.menus.drinks.length,
                              (index) => MenuCard(idx: state.result.restaurant.menus.drinks[index].name,)
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Divider(color: Colors.grey,),
                  Text("Review", style: Theme.of(context).textTheme.headline5,),
                  Container(
                    child: Consumer<DetailProvider>(
                      builder: (context, state, _) {
                        if (state.states == ResultState.HasData) {
                          var account = state.result.restaurant.customerReviews;
                          return Column(
                            children: List.generate(state.result.restaurant.customerReviews.length,
                              (index) => Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.account_circle, size: 50,),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(account[index].name),
                                        Text(account[index].date),
                                        Text("\""+account[index].review+"\"",
                                          style: TextStyle(fontStyle: FontStyle.italic),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8,)
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ),
                  ),
                  Divider(color: Colors.grey,),
                  Container(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.green
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigation.intentWithData(
                              RestaurantReviewsPage.routeName, widget.element);
                        },
                        child: Text(" + Tambah Review  ",
                        style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

