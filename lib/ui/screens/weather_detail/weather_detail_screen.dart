import 'package:first_lesson/data/models/detail/daily_item/daily_item.dart';
import 'package:first_lesson/utils/images/app_images.dart';
import 'package:first_lesson/utils/time_utils.dart';
import 'package:flutter/material.dart';

class WeatherDailyScreen extends StatefulWidget {
  const WeatherDailyScreen({Key? key, required this.daily}) : super(key: key);

  final List<DailyItem> daily;

  @override
  State<WeatherDailyScreen> createState() => _WeatherDailyScreenState();
}

class _WeatherDailyScreenState extends State<WeatherDailyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xffFEB054),
        title: const Text("Next 7 Days"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.center,end: Alignment.bottomRight,colors: [Color(0xffFEB054),Color(0xffFEA14E)])
          ),
          child: Column(
            children: [
              Container(
                width: 310,
                height: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),color: Colors.white.withOpacity(0.4)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text("${TimeWeek.getDateTime(widget.daily[1].dt)}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80),
                          child: Text("${widget.daily[1].dailyTemp.day.toInt()}°",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        ),
                        Expanded(child: Image.network("http://openweathermap.org/img/w/${widget.daily[1].weather[0].icon}.png",scale: 0.6,)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Image.asset(AppImages.Homewind,scale: 1.6,),
                            Text("${widget.daily[1].windSpeed.toInt()}km/h")
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(AppImages.Homehumidity,scale: 1.6,),
                            Text("${widget.daily[1].humidity.toInt()} %")
                          ],
                        ),


                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20,),
              ListView.builder(itemBuilder: (BuildContext context, int index){
                return Container(
                  padding: EdgeInsets.only(left: 16,right: 10),
                  margin: EdgeInsets.only(top: 8,left: 20,right: 20,bottom: 10),
                  width: 310,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white.withOpacity(0.3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${TimeWeek.getDateTime(widget.daily[index].dt)}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                      Row(
                        children: [
                          Text("${widget.daily[index].dailyTemp.day.toInt()}°",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                          Image.network("http://openweathermap.org/img/w/${widget.daily[index].weather[0].icon}.png"),
                        ],
                      ),

                    ],
                  ),
                );
              },
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,)
            ],
          ),
        ),
      ),
    );
  }
}