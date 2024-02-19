import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}


class _GraphScreenState extends State<GraphScreen> {
  int selectedIndex = 0;
  List<LineChartBarData> temperatureDummy = [
    LineChartBarData(spots: const [
      FlSpot(0, 2),
      FlSpot(1, 1),
      FlSpot(2, 2),
      FlSpot(3, 2),
      FlSpot(4, 2),
      FlSpot(5, 3),
      FlSpot(6, 2),
      FlSpot(7, 3),
      FlSpot(8, 2),
      FlSpot(9, 2),
      FlSpot(10, 3),
      FlSpot(11, 4),
      FlSpot(12, 4),
      FlSpot(13, 5),
      FlSpot(14, 5),
    ]),

    LineChartBarData(spots: const [
      FlSpot(0, 2),
      FlSpot(1, 1),
      FlSpot(2, 2),
      FlSpot(3, 3),
      FlSpot(4, 2),
      FlSpot(5, 0),
      FlSpot(6, 2),
      FlSpot(7, 3),
      FlSpot(8, 3),
      FlSpot(9, 3),
      FlSpot(10, 4),
      FlSpot(11, 5),
      FlSpot(12, 4),
      FlSpot(13, 6),
      FlSpot(14, 6),

    ]),
  ];

  List<LineChartBarData> humidityDummy = [
    LineChartBarData(spots: const [
      FlSpot(0, 30),
      FlSpot(1, 28),
      FlSpot(2, 27),
      FlSpot(3, 27),
      FlSpot(4, 28),
      FlSpot(5, 26),
      FlSpot(6, 25),
      FlSpot(7, 41),
      FlSpot(8, 41),
      FlSpot(9, 40),
      FlSpot(10, 49),
      FlSpot(11, 38),
      FlSpot(12, 35),
      FlSpot(13, 49),
      FlSpot(14, 45),
    ]),
    LineChartBarData(spots: const [
      FlSpot(0, 30),
      FlSpot(1, 31),
      FlSpot(2, 30),
      FlSpot(3, 32),
      FlSpot(4, 28),
      FlSpot(5, 27),
      FlSpot(6, 27),
      FlSpot(7, 47),
      FlSpot(8, 46),
      FlSpot(9, 46),
      FlSpot(10, 44),
      FlSpot(11, 42),
      FlSpot(12, 38),
      FlSpot(13, 48),
      FlSpot(14, 48),
    ]),
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                ElevatedButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () {},
                ),
                const SizedBox(width: 10,),
                DropdownButton<int>(
                  value: selectedIndex,
                  items: const [
                    DropdownMenuItem(
                      child: const Text("hardware 1"),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: const Text("hardware 2"),
                      value: 1
                    )
                  ],
                  onChanged: (int? index) {
                    if (index != null) {
                      setState(() {
                        selectedIndex = index;
                      });
                    }
                  },
                )
              ],
            )
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            alignment: Alignment.center,
            child: const Text(
              "温度",
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),

          Container(
            height: 235,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              color: Colors.white,
              child: LineChart(
                LineChartData(
                  lineTouchData: const LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: defaultLineTooltipItem,
                        tooltipBgColor: Colors.white,
                        tooltipRoundedRadius: 2.0
                    )
                  ),
                  gridData: const FlGridData(
                    horizontalInterval: 5.0,             // 背景グリッドの横線間隔
                    verticalInterval: 1.0,
                  ),
                  titlesData: const FlTitlesData(
                    show: true,                          // タイトルの有無
                    bottomTitles: AxisTitles(            // 下側に表示するタイトル設定
                      axisNameWidget: Text("時間[h]"),
                      axisNameSize: 32.0,
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text("温度[℃]"),
                      axisNameSize: 32.0
                    )
                  ),
                  minX: 0,
                  maxX: 23,
                  minY: -10,
                  maxY: 40,

                  lineBarsData: [
                    temperatureDummy[selectedIndex],
                  ],

                ),
              ),
            )
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            alignment: Alignment.center,
            child: const Text(
              "土壌湿度",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ),

          Container(
              height: 235,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                color: Colors.white,
                child: LineChart(
                  LineChartData(
                    lineTouchData: const LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: defaultLineTooltipItem,
                        tooltipBgColor: Colors.white,
                        tooltipRoundedRadius: 2.0
                      )
                    ),
                    gridData: const FlGridData(
                      horizontalInterval: 5.0,             // 背景グリッドの横線間隔
                      verticalInterval: 1.0,
                    ),
                    titlesData: const FlTitlesData(
                      show: true,                          // タイトルの有無
                      bottomTitles: AxisTitles(            // 下側に表示するタイトル設定
                        axisNameWidget: Text("湿度[%]"),
                        axisNameSize: 32.0,
                      ),
                      leftTitles: AxisTitles(
                          axisNameWidget: Text("温度[℃]"),
                          axisNameSize: 32.0
                      )
                    ),
                    minX: 0,
                    maxX: 23,
                    minY: 0,
                    maxY: 100,

                    lineBarsData: [
                      humidityDummy[selectedIndex],
                    ],

                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}