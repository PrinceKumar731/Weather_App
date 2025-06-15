import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  final IconData icon;  
  final String time;
  final String value;

  const HourlyForecastWidget({
    super.key,
    required this.icon,
    required this.time,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 6,
                    child: Container(
                      width:100,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(time,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Icon(icon,size: 32,),
                          const SizedBox(height: 8,),
                          Text(value),
                        ],
                      ),
                    ),
   );
  }
}