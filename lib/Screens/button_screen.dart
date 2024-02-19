import 'package:flutter/material.dart';
import 'package:souzouseisaku/Utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';


class ButtonScreen extends StatefulWidget {
  const ButtonScreen({Key? key}) : super(key: key);

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}


class _ButtonScreenState extends State<ButtonScreen> {
  bool isStop = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: Text("スケジュール設定"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScheduleScreen()));
              },
            ),
            const SizedBox(height: 5,),
            ElevatedButton(
              child: Text("水やり${isStop ? "開始" : "停止"}"),
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 200));
                dialog(context, '水やりを${isStop ? "開始" : "停止"}しました');
                setState(() {
                  isStop = !isStop;
                });
              },
            ),
          ],
        ),
      )
    );
  }
}


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; // 選択している日付
  List<String> _selectedEvents = [];

  //Map形式で保持　keyが日付　値が文字列
  final sampleMap = {
    DateTime.utc(2023, 2,20): ['firstEvent', 'secondEvent'],
    DateTime.utc(2023, 2,5): ['thirdEvent', 'fourthEvent'],
  };

  final sampleEvents = {
    DateTime.utc(2023, 2,20): ['firstEvent', 'secondEvent'],
    DateTime.utc(2023, 2,5): ['thirdEvent', 'fourthEvent']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2024, 12, 31),
              focusedDay: _focusedDay,
              eventLoader: (date) { // イベントドット処理
                return sampleMap[date] ?? [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents = sampleEvents[selectedDay] ?? [];
                });
              }
            ),
            ElevatedButton(
              child: Text(
                "日付選択",
              ),
              onPressed: () => _selectTime(context).then((value) {
                Navigator.of(context).pop();
                dialog(context, "スケジュールを設定しました");
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
}
