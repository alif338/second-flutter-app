import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/db/database_provider.dart';
import 'package:restaurant_app/provider/enum/result_state.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantFavoritePage extends StatefulWidget {
  static const routeName = '/restaurant_favorite';

  @override
  _RestaurantFavoritePageState createState() => _RestaurantFavoritePageState();
}

class _RestaurantFavoritePageState extends State<RestaurantFavoritePage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorite'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Consumer<DatabaseProvider>(
          builder: (context, provider, child){
            if (provider.state == ResultState.HasData) {
              return ListView.builder(
                itemCount: provider.favorite.length,
                itemBuilder: (context, index) {
                  var resItem = provider.favorite[index];
                  return _favoriteResultItem(context, resItem);
                }
              );
            } else if (provider.state == ResultState.loading) {
              return Center(child: CircularProgressIndicator(),);
            } else {
              return Center(child: Text(provider.message));
            }
          },
        )
      ),
    );
  }

}

Widget _favoriteResultItem(BuildContext context, element) {
  return Material(
    child:InkWell(
      onTap: (){
        Navigator.pushNamed(context,
            RestaurantDetailPage.routeName, arguments: element);
      },
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