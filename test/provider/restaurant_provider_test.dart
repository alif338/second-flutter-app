import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_restaurant_main.dart';
import 'package:restaurant_app/data/restaurants.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// class MockClient extends Mock implements http.Client {}

void main() {
  group('Parsing JSON test', (){

    ApiRestaurantMain apiResto;
    String jsonParser = '''
    {
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
            {
                "id": "rqdv5juczeskfw1e867",
                "name": "Melting Pot",
                "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
                "pictureId": "14",
                "city": "Medan",
                "rating": 4.2
            },
            {
                "id": "s1knt6za9kkfw1e867",
                "name": "Kafe Kita",
                "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
                "pictureId": "25",
                "city": "Gorontalo",
                "rating": 4
            }
        ]
    }
      ''';

    setUp(() {
      apiResto = ApiRestaurantMain();
    });

    test('Parsing should be done (From local JSON)', () {
      var result = Restaurants.fromJson(json.decode(jsonParser));
      var test = result.restaurants.length;

      expect(test, 2);
    });

    // test('Parsing should be done (From internet JSON)', () async {
    //
    //   final client = MockClient();
    //
    //   when(client.get('https://restaurant-api.dicoding.dev/list'))
    //       .thenAnswer((_) async => http.Response(jsonParser, 200));
    //
    //   final _data = await apiResto.mainList();
    //   final content = _data.restaurants.map((x) => x.name);
    //   expect(content.contains('Melting Pot'), true);
    // });

    test('Fetch restaurant data JSON and parsing them', () async {
      apiResto.client = MockClient((request) async {
        final restoMap = {
          "error": false,
          "message": "success",
          "count": 20,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2
            },
            {
              "id": "s1knt6za9kkfw1e867",
              "name": "Kafe Kita",
              "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
              "pictureId": "25",
              "city": "Gorontalo",
              "rating": 4
            }
          ]
        };
        return http.Response(json.encode(restoMap), 200);
      });

      final _data = await apiResto.mainList();
      final content = _data.restaurants.map((x) => x.name);
      expect(content.contains('Melting Pot'), true);
    });
    
    test('Throws exception if fetch restaurant data is failed', () async {
      apiResto.client = MockClient((request) async {
        return http.Response(json.encode(''), 404);
      });

      try {
        apiResto.mainList();
      } on NullThrownError catch(e) {
        expect(e.toString(), 'Throw of null.');
      }
    });

    // test('throws an exception if the http call completes with error', () {
    //   final client = MockClient();
    //   when(client.get('https://restaurant-api.dicoding.dev/list'))
    //     .thenAnswer((_) async => http.Response('Not Found', 404));
    //
    //   final test = apiResto.mainList();
    //   expect(test, test.whenComplete(() => throw Exception('Failed to load Resto')));
    //   print('Exception ini dipanggil apabila terdapat masalah pada link API ataupun pada '
    //       'koneksi internet');
    // });

  });
}


