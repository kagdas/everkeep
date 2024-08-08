// home_page.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Mood {
  final String emoji;
  final Color color;

  Mood(this.emoji, this.color);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  DateTime today = DateTime.now();
  DateTime? tappedDate;
  Map<DateTime, Mood> moodMap = {};

  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      tappedDate = day;
    });
  }

  void setMood(DateTime day, Mood mood) {
    setState(() {
      moodMap[DateTime(day.year, day.month, day.day)] = mood;
      if (isSameDay(day, DateTime.now())) {
        today = day;
        tappedDate = day;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      CalendarContent(
        today: today,
        onDaySelected: onDaySelected,
        moodMap: moodMap,
      ),
      const Text('Journal Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      const Text('Settings Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ];

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Everkeep'),
        centerTitle: true,
      ),
      body: Center(
        child: selectedIndex == 0
            ? Column(
                children: [
                  Expanded(
                    child: widgetOptions.elementAt(selectedIndex),
                  ),
                  if (tappedDate != null)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey[200],
                      child: MoodWidget(
                        date: tappedDate!,
                        setMood: setMood,
                      ),
                    ),
                ],
              )
            : widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF402E7A),
        unselectedItemColor: const Color(0xFF987D9A),
        backgroundColor: const Color(0xFFEECEB9),
        onTap: onItemTapped,
      ),
    );
  }
}

class CalendarContent extends StatelessWidget {
  final DateTime today;
  final void Function(DateTime, DateTime) onDaySelected;
  final Map<DateTime, Mood> moodMap;

  const CalendarContent({
    required this.today,
    required this.onDaySelected,
    required this.moodMap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "en_US",
      rowHeight: 43,
      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, today),
      focusedDay: today,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      calendarFormat: CalendarFormat.month,
      daysOfWeekVisible: true,
      onDaySelected: onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final mood = moodMap[DateTime(day.year, day.month, day.day)];
          final isSelected = isSameDay(day, today);

          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mood != null ? mood.color.withOpacity(0.3) : Colors.transparent,
              border: isSelected
                  ? Border.all(
                      color: Colors.pink.withOpacity(0.5),
                      width: 2,
                    )
                  : null,
              shape: BoxShape.rectangle,
            ),
            child: Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MoodWidget extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime, Mood) setMood;

  const MoodWidget({
    required this.date,
    super.key,
    required this.setMood,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood for ${date.toLocal().toString().split(' ')[0]}',
          style: Theme.of(context).textTheme.titleMedium ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _moodButton(context, '🤩', const Color(0xFF6BB6EF), date),
            _moodButton(context, '😃', const Color(0xFF7DED99), date),
            _moodButton(context, '😐', const Color(0xFFEDE97D), date),
            _moodButton(context, '😢', const Color(0xFFE09A64), date),
            _moodButton(context, '😡', const Color(0xFFED6D6D), date),
          ],
        ),
      ],
    );
  }

  Widget _moodButton(BuildContext context, String emoji, Color color, DateTime date) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        setMood(date, Mood(emoji, color));
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
