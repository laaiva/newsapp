import 'dart:convert';
import 'package:untitled/NewsView.dart';
import 'package:untitled/category2.dart';
import 'package:untitled/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = [
    "Top News",
    "India",
    "Finance",
    "Health"
  ];

  bool isLoading = true;
  getNews()async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=4c6842085864405aa40688fd1a921192";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

      });
    });

  }
  getNewsByQuery(String query) async {
    String url = "";
    int i = 0;
    Map element;
    url = "https://newsapi.org/v2/everything?q=$query&from=2024-11-15&sortBy=publishedAt&apiKey=4c6842085864405aa40688fd1a921192";


    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for(element in data['articles'])
        {

          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });

          if(i == 5) break;

        }
    });
  }
  // getNewsByQuery(String query) async {
  //   String url =
  //       "https://newsapi.org/v2/everything?q=$query&from=2021-06-28&sortBy=publishedAt&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
  //   Response response = await get(Uri.parse(url));
  //   Map data = jsonDecode(response.body);
  //   setState(() {
  //     data["articles"].forEach((element) {
  //       NewsQueryModel newsQueryModel = new NewsQueryModel();
  //       newsQueryModel = NewsQueryModel.fromMap(element);
  //       newsModelList.add(newsQueryModel);
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //     });
  //   });
  //
  // }
  //
  //
  //
  //
  //
  getNewsofTech() async {
    String url = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=4c6842085864405aa40688fd1a921192";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

      });
    });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getNewsByQuery("corona");
    // getNewsofIndia();
    getNews();
    getNewsofTech();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KHABAR"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Wala Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category2(Query: searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        print(value);
                        if(value == "")print("BLANK SPACE");
                          else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Category2(Query: value)));
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search Health"),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder:(context) =>Category2(Query: navBarItem[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    })),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: isLoading ?  Container(height: 200, child: Center(child: CircularProgressIndicator())) : CarouselSlider(
                options: CarouselOptions(
                    height: 200, autoPlay: true, enlargeCenterPage: true),
                items: newsModelListCarousel.map((instance) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                        child : InkWell(
                          onTap:()
                          {
                            //print("hello");
                            launchUrl(Uri.parse(instance.newsUrl));
                            // launchUrl(http://github.com/laaiva/newsapp);
                            //Navigator.push(context,MaterialPageRoute(builder: (context) => NewsView(instance.newsUrl)));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child : Stack(
                                  children : [
                                    ClipRRect(
                                        borderRadius : BorderRadius.circular(10),
                                        child : Image.network(instance.newsImg , fit: BoxFit.fitHeight, width: double.infinity,)
                                    ) ,
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                          
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          child : Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                                              child:Container( margin: EdgeInsets.symmetric(horizontal: 10), child: Text(instance.newsHead , style: TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),))
                                          ),
                                        )
                                    ),
                                  ]
                              )
                          ),
                        )
                    );
                  });
                }).toList(),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text("LATEST NEWS " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28
                        ),),
                      ],
                    ),
                  ),
                  isLoading ? Container(height: MediaQuery.of(context).size.height - 350, child : Center(child: CircularProgressIndicator())):
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),

                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].newsHead,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}...." : newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12)
                                                ,)
                                            ],
                                          )))
                                ],
                              )),
                        );
                      }),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Category2(Query: "Election")));}, child: Text("SHOW MORE")),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  final List items = ["HELLO MAN", "NAMAS STAY", "DIRTY FELLOW"];
}























// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   TextEditingController searchController = new TextEditingController();
//   List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
//   List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
//   List<String> navBarItem = [
//     "Top News",
//     "India",
//     "World",
//     "Finance",
//     "Health"
//   ];
//
//   bool isLoading = true;
//
//   // need to make a different function for the carousel
//
//   getNews()async {
//     String url =
//         "https://newsapi.org/v2/top-headlines?country=us&apiKey=4c6842085864405aa40688fd1a921192";
//     Response response = await get(Uri.parse(url));
//     Map data = jsonDecode(response.body);
//     setState(() {
//       data["articles"].forEach((element) {
//         NewsQueryModel newsQueryModel = new NewsQueryModel();
//         newsQueryModel = NewsQueryModel.fromMap(element);
//         newsModelList.add(newsQueryModel);
//         newsModelListCarousel.add(newsQueryModel);
//         setState(() {
//           isLoading = false;
//         });
//
//       });
//     });
//
//   }
//
//
//
//   // getNewsByQuery(String query) async {
//   //   String url =
//   //       "https://newsapi.org/v2/top-headlines?country=us&apiKey=4c6842085864405aa40688fd1a921192";
//   //   Response response = await get(Uri.parse(url));
//   //   Map data = jsonDecode(response.body);
//   //   setState(() {
//   //     data["articles"].forEach((element) {
//   //       NewsQueryModel newsQueryModel = new NewsQueryModel();
//   //       newsQueryModel = NewsQueryModel.fromMap(element);
//   //       newsModelList.add(newsQueryModel);
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //
//   //     });
//   //   });
//   //
//   // }
//
//
//
//
//
//   // getNewsofIndia() async {
//   //   String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=4c6842085864405aa40688fd1a921192";
//   //   Response response = await get(Uri.parse(url));
//   //   Map data = jsonDecode(response.body);
//   //   setState(() {
//   //     data["articles"].forEach((element) {
//   //       NewsQueryModel newsQueryModel = new NewsQueryModel();
//   //       newsQueryModel = NewsQueryModel.fromMap(element);
//   //       newsModelListCarousel.add(newsQueryModel);
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //
//   //     });
//   //   });
//   //
//   //
//   // }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getNews();
//     super.initState();
//
//     //getNewsByQuery("corona");
//     //getNewsofIndia();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("ARNE NEWS"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               //Search Wala Container
//
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(24)),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       if ((searchController.text).replaceAll(" ", "") == "") {
//                         print("Blank search");
//                       } else {
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
//                       }
//                     },
//                     child: Container(
//                       child: Icon(
//                         Icons.search,
//                         color: Colors.blueAccent,
//                       ),
//                       margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
//                     ),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: searchController,
//                       textInputAction: TextInputAction.search,
//                       onSubmitted: (value) {
//                         print(value);
//                       },
//                       decoration: InputDecoration(
//                           border: InputBorder.none, hintText: "Search Health"),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//                 height: 50,
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: navBarItem.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           //Navigator.push(context,MaterialPageRoute(builder:(context) =>Category2(Query: navBarItem[index])));
//                            print(navBarItem[index]);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           margin: EdgeInsets.symmetric(horizontal: 5),
//                           decoration: BoxDecoration(
//                               color: Colors.blueAccent,
//                               borderRadius: BorderRadius.circular(15)),
//                           child: Center(
//                             child: Text(navBarItem[index],
//                                 style: TextStyle(
//                                     fontSize: 19,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                       );
//                     })),
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 15),
//               child: CarouselSlider(
//                 options: CarouselOptions(
//                     height: 200, autoPlay: true, enlargeCenterPage: true),
//                     //items: items.map((item){
//                       // idhar ya toh remove this or use static images
//
//                     items: newsModelListCarousel.map((instance) {
//                   return Builder(builder: (BuildContext context) {
//                     return Container(
//
//                         child : Card(
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                             child : Stack(
//                                 children : [
//                                   ClipRRect(
//                                       borderRadius : BorderRadius.circular(10),
//                                       //child : Image.asset("images/news.jpeg" , fit: BoxFit.fitHeight, height: double.infinity,)
//                                       //child : Image.network(instance.newsImg, fit: BoxFit.fitHeight, height: double.infinity,)
//                                       child : Image.network(instance.newsImg , fit: BoxFit.fitHeight, width: double.infinity,)
//                                   ) ,
//                                   Positioned(
//                                       left: 0,
//                                       right: 0,
//                                       bottom: 0,
//                                       child: Container(
//
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             gradient: LinearGradient(
//                                                 colors: [
//                                                   Colors.black12.withOpacity(0),
//                                                   Colors.black
//                                                 ],
//                                                 begin: Alignment.topCenter,
//                                                 end: Alignment.bottomCenter
//                                             )
//                                         ),
//                                         child : Container(
//                                             padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
//                                             //child:Text("NEWS HEADLINE IDHAR HAI" , style: TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),)
//                                             child:Container( margin: EdgeInsets.symmetric(horizontal: 10), child: Text(instance.newsHead , style: TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),))
//                                         ),
//                                       )
//                                   ),
//                                 ]
//                             )
//                         )
//                     );
//                   });
//                 }).toList(),
//               ),
//             ),
//             Container(
//               child: Column(
//                 children: [
//                   Container(
//                     margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//
//                         Text("LATEST NEWS " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28
//                         ),),
//                       ],
//                     ),
//                   ),
//                   ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: newsModelList.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           child: Card(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15)),
//                               elevation: 1.0,
//                               child: Stack(
//                                 children: [
//                                   ClipRRect(
//                                       borderRadius: BorderRadius.circular(15),
//                                       child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),
//
//                                   Positioned(
//                                       left: 0,
//                                       right: 0,
//                                       bottom: 0,
//                                       child: Container(
//
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(15),
//                                               gradient: LinearGradient(
//                                                   colors: [
//                                                     Colors.black12.withOpacity(0),
//                                                     Colors.black
//                                                   ],
//                                                   begin: Alignment.topCenter,
//                                                   end: Alignment.bottomCenter
//                                               )
//                                           ),
//                                           padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 newsModelList[index].newsHead,
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                               Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}...." : newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12)
//                                                 ,)
//                                             ],
//                                           )))
//                                 ],
//                               )),
//                         );
//                       }),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(onPressed: () {}, child: Text("SHOW MORE")),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   final List items = ["HELLO MAN", "NAMAS STAY", "DIRTY FELLOW"];
// }

