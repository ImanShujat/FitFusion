import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderApp extends StatefulWidget {
  @override
  _ReminderAppState createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<Map<String, dynamic>> _reminders = [];

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchReminders();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> _scheduleNotification(int id, String title, String description, DateTime dateTime) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'food_channel',
      'Food Notifications',
      channelDescription: 'Notifications for food reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      description,
      tz.TZDateTime.from(dateTime, tz.local),
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _addReminder() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    DateTime dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (title.isNotEmpty && description.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.100.22/reminders/add.php'),
          body: {
            'title': title,
            'description': description,
            'date': dateTime.toIso8601String(),
          },
        );

        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          if (responseData['success']) {
            _titleController.clear();
            _descriptionController.clear();
            _fetchReminders();
            _scheduleNotification(responseData['id'], title, description, dateTime);
          }
        } else {
          print('Failed to add reminder.');
        }
      } catch (e) {
        print('Error adding reminder: $e');
      }
    } else {
      print('Title and description cannot be empty');
    }
  }

  Future<void> _fetchReminders() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.100.22/reminders/get.php'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _reminders = responseData.map((data) => {
            'id': data['id'],
            'title': data['title'],
            'description': data['description'],
            'date': data['date'],
            'time': data['time'],
            'isEnabled': true,
          }).toList();
        });
      } else {
        print('Failed to fetch reminders.');
      }
    } catch (e) {
      print('Error fetching reminders: $e');
    }
  }

  Future<void> _updateReminder(int id) async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    DateTime dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    try {
      final response = await http.post(
        Uri.parse('http://192.168.73.169/reminders/update.php'),
        body: {
          'id': id.toString(),
          'title': title,
          'description': description,
          'date': dateTime.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success']) {
          _fetchReminders();
          _scheduleNotification(id, title, description, dateTime);
        }
      } else {
        print('Failed to update reminder.');
      }
    } catch (e) {
      print('Error updating reminder: $e');
    }
  }

  Future<void> _deleteReminder(int id) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.73.169/reminders/delete.php'),
        body: {'id': id.toString()},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success']) {
          _fetchReminders();
        }
      } else {
        print('Failed to delete reminder.');
      }
    } catch (e) {
      print('Error deleting reminder: $e');
    }
  }

  void _toggleReminder(int id, bool isEnabled) {
    setState(() {
      _reminders.firstWhere((reminder) => reminder['id'] == id)['isEnabled'] = isEnabled;
    });

    final reminder = _reminders.firstWhere((reminder) => reminder['id'] == id);

    if (isEnabled) {
      _scheduleNotification(id, reminder['title'], reminder['description'], DateTime.parse(reminder['date']));
    } else {
      _deleteReminder(id); // cancel notification when disabled
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Reminder App'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("Time: ${_selectedTime.format(context)}"),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addReminder,
              child: Text('Add Reminder'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final reminder = _reminders[index];
                  return ListTile(
                    title: Text(reminder['title'] ?? ''),
                    subtitle: Text("${reminder['description']} - ${reminder['date']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: reminder['isEnabled'],
                          onChanged: (value) {
                            setState(() {
                              reminder['isEnabled'] = value;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _titleController.text = reminder['title'];
                            _descriptionController.text = reminder['description'];
                            _selectedDate = DateTime.parse(reminder['date']);
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Edit Reminder'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: _titleController),
                                      TextField(controller: _descriptionController),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _updateReminder(reminder['id']);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Android initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Initialization settings
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Meal schedule list
  final List<Map<String, String>> meals = [
    {'name': 'Breakfast', 'time': '08:00'},
    {'name': 'Lunch', 'time': '13:00'},
    {'name': 'Dinner', 'time': '19:00'},
  ];

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  // Request notification permission (iOS only, ignored on Android)
  void requestNotificationPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  // Schedule notification
  Future<void> scheduleMealNotification(String mealName, DateTime dateTime) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meal_channel',
      'Meal Notifications',
      channelDescription: 'Notifications for meal reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      mealName.hashCode, // Unique ID for each meal
      'Meal Reminder', // Notification Title
      'It\'s time for your $mealName!', // Notification Body
      tz.TZDateTime.from(dateTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancel notification
  Future<void> cancelNotification(String mealName) async {
    await flutterLocalNotificationsPlugin.cancel(mealName.hashCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$mealName notification canceled!")),
    );
  }

  // Show time picker and reschedule
  Future<void> showTimePickerAndSchedule(String mealName) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime now = DateTime.now();
      DateTime newScheduleTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (newScheduleTime.isBefore(now)) {
        newScheduleTime = newScheduleTime.add(Duration(days: 1));
      }

      await scheduleMealNotification(mealName, newScheduleTime);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$mealName rescheduled for ${pickedTime.format(context)}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Meal Reminder"),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(meal['name']!, style: TextStyle(fontSize: 18)),
              subtitle: Text("Scheduled Time: ${meal['time']}"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Schedule') {
                    DateTime now = DateTime.now();
                    List<String> timeParts = meal['time']!.split(':');
                    DateTime mealTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      int.parse(timeParts[0]),
                      int.parse(timeParts[1]),
                    );

                    scheduleMealNotification(meal['name']!, mealTime);
                  } else if (value == 'Reschedule') {
                    showTimePickerAndSchedule(meal['name']!);
                  } else if (value == 'Cancel') {
                    cancelNotification(meal['name']!);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'Schedule',
                    child: Text('Schedule'),
                  ),
                  PopupMenuItem(
                    value: 'Reschedule',
                    child: Text('Reschedule'),
                  ),
                  PopupMenuItem(
                    value: 'Cancel',
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

