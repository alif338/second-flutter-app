import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_restaurant_detail.dart';
import 'package:restaurant_app/data/api/api_restaurant_search.dart';
import 'package:restaurant_app/provider/detail_provider.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/restaurant_search';
  final String query;
  RestaurantSearchPage({@required this.query});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
        create: (context) => SearchProvider(restaurantSearch: ApiRestaurantSearch(query: query)),
      child: ResultSearch(query: query,),);
  }
}

class ResultSearch extends StatelessWidget {
  final String query;
  const ResultSearch({@required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search result of : $query'
        ,style: TextStyle(fontStyle: FontStyle.italic),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Consumer<SearchProvider>(
              builder: (context, state, _){
                if (state.states == ResStates.HasData) {
                  return ListView.builder(
                    itemCount: state.result.restaurants.length,
                    itemBuilder: (context, idx) {
                      var resSearch = state.result.restaurants[idx];
                      return _searchResultItems(context, resSearch);
                    },
                  );
                } else if (state.states == ResStates.loading) {
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  return Center(child: Text("No Data"),);
                }
              },
            ),
      ),

    );
  }
}

Widget _searchResultItems(BuildContext context, element) {
  return Material(
    child:InkWell(
      onTap: (){
        ChangeNotifierProvider<DetailProvider>(
          create: (_) => DetailProvider(restaurantDetail: ApiRestaurantDetail(baseId: element.id)),
          child: RestaurantDetailPage(element: element,),
        );
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
