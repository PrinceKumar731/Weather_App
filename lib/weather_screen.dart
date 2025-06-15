import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/hourlyforecast.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weatherforecastitem.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String,dynamic>> getCurrentWeather() async{

      print('hi');
      String cityname ='Pune';
      String country = 'in';
      final res= await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityname,$country&APPID=$openWeatherAPIkey'),);
      final data = jsonDecode(res.body);
      if(data['cod']!='200'){
        throw Exception(data['message']);
      }
      return data;
    //  data['list'][0]['main']['temp'];   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',style: TextStyle(
          fontWeight:FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            print("refreshed");
          }, 
          icon: const Icon(Icons.refresh))
        ],
      ),
      body:FutureBuilder(
        future: getCurrentWeather(),
        builder:(context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            print('error');
            return Center(child: Text(snapshot.error.toString(),style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),));
          }

          final data = snapshot.data!;

          final currentweatherdata = data['list'][0];

          final currenttemperature = currentweatherdata['main']['temp'];
          final currentSky = currentweatherdata['weather'][0]['main'];

          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10,),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('$currenttemperature K',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16,),
                            Icon(
                              currentSky=='Clouds' || currentSky== 'Rain'?Icons.cloud:Icons.sunny,
                              size: 64,
                            ),
                            SizedBox(height: 16,),
                            Text(currentSky,style: TextStyle(fontSize: 20),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Weather Forecast",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                  for(int i=1;i<=5;i++)
                    HourlyForecastWidget(
                      icon:data['list'][i]['weather'][0]['main']=='Clouds' || data['list'][i]['weather'][0]['main']=='Rain'?Icons.cloud:Icons.sunny,
                      time: data['list'][i]['dt_txt'].substring(11),
                      value: '${data['list'][i]['main']['temp']}',)      
                  ]              
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Additional Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  additonalinfoitem(
                    icon: Icons.water_drop_rounded,
                    label:'Humidity',
                    value:'${currentweatherdata['main']['humidity']}'
                  ),
                  additonalinfoitem(
                    icon: Icons.air,
                    label:'Wind Speed',
                    value:'${currentweatherdata['wind']['speed']}'
                  ),
                  additonalinfoitem(
                    icon: Icons.umbrella_rounded,
                    label:'Pressure',
                    value:'${currentweatherdata['main']['pressure']}',
                  ),
                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}
