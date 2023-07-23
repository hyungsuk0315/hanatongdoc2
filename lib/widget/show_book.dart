import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/date_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ShowBook extends StatelessWidget {
  const ShowBook({super.key});
  @override
  Widget build(BuildContext context)  {
    return SizedBox(
      width: 200.0,
      height: 300.0,
      child: Scaffold(
          body:Column(
              children: [
                //Text('asdafs')
                Text(context.watch<DatePickup>().curDate.toString()),
                Text(context.watch<DatePickup>().strDate.toString()),
                CarouselSlider(
                  options: CarouselOptions(
                      height: 100.0,
                      enableInfiniteScroll: false,
                  ),
                  items: context.watch<DatePickup>().bibleList.map((script) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.amber
                            ),
                            child: Column(
                                children: [
                                  //Text(context.watch<DatePickup>().verses)
                                ]
                            )
                        );
                      },
                    );
                  }).toList(),
                )
              ],
            ),


        ),
    );
  }
}



