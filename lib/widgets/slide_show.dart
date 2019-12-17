import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:safe_journey/pages/Place_page.dart';

class MySlideShow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SlideShowState();
  }
}

class SlideShowState extends State<MySlideShow> {
  CarouselSlider carouselSlider;

  int _current = 0;
  List imgList = [
    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          carouselSlider = CarouselSlider(
            height: deviceHeight / 1.8,
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: true,
            reverse: false,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 2000),
            pauseAutoPlayOnTouch: Duration(seconds: 10),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: _places.map((place) {
              return Builder(builder: (BuildContext context) {
                return _slideshowBuilder(context, place);
              });
            }).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(imgList, (index, url) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(
                    vertical: deviceHeight / 60, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.black45 : Colors.white,
                ),
              );
            }),
          ),
          /*SizedBox(
            height: 20.0,
          ),*/
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: goToPrevious,
                child: Text("<"),
              ),
              OutlineButton(
                onPressed: goToNext,
                child: Text(">"),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  Widget _slideshowBuilder(BuildContext context, Map<String, dynamic> place) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return PlacePage(place);
          }),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: orientation == Orientation.landscape
            ? EdgeInsets.symmetric(horizontal: deviceWidth * 0.07)
            : EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
        borderOnForeground: true,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            _imageBuilder(deviceHeight, place['imageURL']),
            _descriptionBuilder(place['name']),
          ],
        ),
      ),
    );
  }

  Widget _imageBuilder(double deviceHeight, String imgUrl) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      margin: EdgeInsets.all(deviceHeight / 70),
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 5.0, // has the effect of extending the shadow
            offset: Offset(
              10.0, // horizontal, move right 10
              10.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        child: Image.network(
          imgUrl,
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height / 2.6,
        ),
      ),
    );
  }

  Widget _descriptionBuilder(String name) {
    return Container(
      alignment: Alignment.bottomCenter,
      // width: deviceWidth * 0.40,
      child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.black26),
          child: Text(
            name,
            textAlign: TextAlign.center,
          )),
    );
  }

  List<Map<String, dynamic>> _places = [
    {
      "name": "Dead sea",
      "description": "A good place for your holyday.",
      "imageURL":
          "https://images.memphistours.com/large/1049635127_Salt+Formations+9.jpg",
      "address": "Jerico - north east",
    },
    {
      "name": "Hisham palace",
      "description":
          "The Historical palace of -khalifa- Hisham bin Abd-Almalik ",
      "imageURL":
          "http://1remva49c8bs3jvwod2dqqqs.wpengine.netdna-cdn.com/wp-content/uploads/2015/06/Hisham-Palace-1.jpg",
      "address": "Jericho - 5 KM to the north of the city",
    },
    {
      "name": "Haddad hotel",
      "description": "5 stars hotel for tourists",
      "imageURL":
          "https://www.hotelpigonnet.com/sites/hotel-pigonnet.com/files/styles/image_front/public/blocs_hp/hotel-le-pigonnet-aix-en-provence-le-chambres.jpg?itok=xU_fg98M",
      "address": "Jenin - to the west of Jannat",
    },
    {
      "name": "Banana land",
      "description": "Many games for children",
      "imageURL":"https://murtahil.com/wp-content/uploads/2018/07/IMG_43073.jpg",
      "address": "Ramalla - Al-Ersal street",
    }
  ];
}
