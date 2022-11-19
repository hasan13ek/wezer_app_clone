import 'package:first_lesson/data/models/detail/on_call_data.dart';
import 'package:first_lesson/data/models/helper/lat_lon.dart';
import 'package:first_lesson/data/models/weather_main_model.dart';
import 'package:first_lesson/data/repository/app_repository.dart';
import 'package:first_lesson/ui/widgets/my_custom_appbar.dart';
import 'package:first_lesson/ui/widgets/search_delegate_view.dart';
import 'package:first_lesson/utils/constants.dart';
import 'package:first_lesson/utils/images/app_images.dart';
import 'package:first_lesson/utils/my_utils.dart';
import 'package:first_lesson/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';


class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({Key? key}) : super(key: key);

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  bool isLoaded = false;
  bool isOn = false;
  bool isOn1 = false;
  bool isOn2 = false;
  LatLong? latLong;
  String query = "";
  OneCallData? oneCallData;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData _locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    if (_locationData.latitude != null) {
      setState(() {
        isLoaded = true;
      });
      latLong = LatLong(
        lat: _locationData.latitude!,
        long: _locationData.longitude!,
      );
    }

    print("LONGITUDE:${_locationData.longitude} AND ${_locationData.latitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        onSearchTap: () async {
          var searchText = await showSearch(
            context: context,
            delegate:
                SearchDelegateView(suggestionList: MyUtils.getPlaceNames()),
          );
          setState(() {
            query = searchText;
          });
          print("RESULTTTTT:$searchText");
        },
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.center,end: Alignment.bottomRight,colors: [const Color(0xffFEB054).withOpacity(0.6),const Color(0xffFEA14E)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (latLong != null)
              FutureBuilder<WeatherMainModel>(
                  future: query.isEmpty
                      ? AppRepository.getWeatherMainDataByLocation(
                      latLong: latLong!)
                      : AppRepository.getWeatherMainDataByQuery(query: query),
                  builder: (context, AsyncSnapshot<WeatherMainModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${data.name}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 26),),
                              const SizedBox(height: 10,),
                              Text("${data.sysInMain.country}",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 26),),
                            ],
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Row(
                              children: [
                              Image.network("http://openweathermap.org/img/w/${data.weatherModel[0].icon}.png",scale: 0.6,),
                                const SizedBox(width: 60,),
                              Column(
                                children: [
                                  Text("${data.mainInMain.temp.toInt()}°C",style: const TextStyle(fontSize: 44),),
                                  Text("${data.weatherModel[0].main}",style: const TextStyle(fontSize: 24),)
                                ],
                              )
                            ],),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Container(
                              width: 320,
                              height: 70,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white.withOpacity(0.3)),
                              child: Row(
                                children: [
                                  Expanded(child: Image.asset(AppImages.Homewind)),
                                  const Expanded(child: Text("Wind")),
                                  const SizedBox(width: 100,),
                                  Expanded(child: Text("${data.windInMain.speed.toInt()}km/h"))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Container(
                              width: 320,
                              height: 70,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white.withOpacity(0.3)),
                              child: Row(
                                children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Image.asset(AppImages.Homehumidity,scale: 1.4,),
                                  )),
                                  const Expanded(child: Text("Humidity")),
                                  const SizedBox(width: 120,),
                                  Expanded(child: Text("${data.mainInMain.humidity}%"))
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child: TextButton(onPressed: (){}, child: Text("Today",style: TextStyle(color: isOn?Colors.black:Colors.black.withOpacity(0.2)),))),
                              Expanded(child: TextButton(onPressed: (){}, child: Text("Tomorrow",style: TextStyle(color:  isOn?Colors.black:Colors.black.withOpacity(0.2))))),
                              Expanded(child: TextButton(onPressed: (){
                                Navigator.pushNamed(context, dailyScreen,
                                    arguments: oneCallData!.daily);
                              }, child: Text("Next 7 Days",style: TextStyle(color:  isOn?Colors.black:Colors.black.withOpacity(0.2)))))
                            ],
                          ),

                        ],);
                    } else {
                      return Text("Error:${snapshot.error.toString()}");
                    }
                  }),
            Visibility(
              visible: isLoaded == false,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            if (latLong != null)
              FutureBuilder<OneCallData>(
                future:
                AppRepository.getHourlyDailyWeather(latLong: latLong!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (snapshot.hasData) {
                    oneCallData = snapshot.data!;
                    return   Container(
                       width: double.infinity,
                       height: 120,
                       child: ListView.builder(itemBuilder: (BuildContext context , int index){
                          return Container(
                            margin: EdgeInsets.only(left: 8,right: 4),
                            width: 56,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(32)),color:Colors.white.withOpacity(0.2) ),
                            child: Column(
                              children: [
                                SizedBox(height: 14,),
                                Text("${TimeHour.getDateTime(oneCallData!.hourly[index].dt)}",style: TextStyle(color: Colors.grey),),
                                Image.network("http://openweathermap.org/img/w/${oneCallData?.hourly[index].weather[0].icon}.png"),
                                Text("${oneCallData?.hourly[index].temp.toInt()}°",style: TextStyle(fontWeight: FontWeight.w600),)
                              ],
                            ),
                          );
                       },
                         itemCount: oneCallData?.hourly.length,
                         scrollDirection: Axis.horizontal,
                       ),
                     );
                  } else {
                    return Text("Mana:${snapshot.error.toString()}");
                  }
                }
                ),
          ],
        ),
      ),
    );
  }
}