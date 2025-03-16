import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

// Main Plans Screen
class Plans extends StatefulWidget {
  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> _animatedImagePaths = [
    'images/5.png',
    'images/11.jpg',
    'images/4.jpg',
  ];
  final List<String> _staticImagePaths = [
    'images/9.jpg',
    'images/7.jpg',
    'images/8.jpg',
    'images/10.jpg',
  ];
  Timer? _timer;

  late VideoPlayerController _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  // Start autoplay of images
  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _animatedImagePaths.length;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // Initialize the video player for diary section
  _initializeVideoPlayer() {
    _videoController = VideoPlayerController.asset('videos/diet.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  // Toggle video play/pause
  void _toggleVideo() {
    setState(() {
      if (_isVideoPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.green,
            pinned: true,
            expandedHeight: 200.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "images/2.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Cards for different categories
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  buildOptionCard('Water Intake Tracker', Icons.local_drink, Colors.lightBlue, WaterTrackerScreen()),
                  buildOptionCard('Sleep Tracker', Icons.nightlight_round, Colors.purple, SleepTrackerScreen()),
                  buildOptionCard('Mood Tracker', Icons.mood, Colors.orange, MoodTrackerScreen()),
                  buildOptionCard('Habit Tracker', Icons.check_circle, Colors.teal, HabitTrackerScreen()),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          // Animated Images Section
          SliverToBoxAdapter(
            child: Container(
              height: 250.0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _animatedImagePaths.length,
                itemBuilder: (context, index) {
                  return buildImageContainer(_animatedImagePaths[index]);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          // Static Image Section
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return buildImageContainer(_staticImagePaths[index]);
              },
              childCount: _staticImagePaths.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          // Fitness Video Section (Diary)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Fitness Video Diary',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _videoController.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                      : CircularProgressIndicator(),
                  IconButton(
                    icon: Icon(
                      _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                    ),
                    onPressed: _toggleVideo,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build image containers
  Widget buildImageContainer(String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      width: double.infinity,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Helper method to build option cards for diary/plans functionality
  Widget buildOptionCard(String title, IconData icon, Color color, Widget screen) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for better look
      ),
      elevation: 5, // Adding shadow for depth
      child: InkWell(
        onTap: () {
          // Navigate to the respective screen on tap
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Daily Meal Planner Screen
class DailyMealScreen extends StatefulWidget {
  @override
  _DailyMealScreenState createState() => _DailyMealScreenState();
}

class _DailyMealScreenState extends State<DailyMealScreen> {
  List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];
  List<bool> mealStatus = [false, false, false];
  final double goal = 3; // Assuming 3 meals per day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Meal Planner'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(meals[index]),
            trailing: Checkbox(
              value: mealStatus[index],
              onChanged: (bool? value) {
                setState(() {
                  mealStatus[index] = value!;
                });
              },
            ),
            subtitle: LinearProgressIndicator(
              value: mealStatus[index] ? 1.0 : 0.0,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

// Mood Tracker Screen

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  String selectedMood = ''; // To store the selected mood
  String motivationalMessage = ''; // To store the motivational message

  // Function to handle mood selection and display message
  void _onMoodSelected(String mood) {
    setState(() {
      selectedMood = mood;
      motivationalMessage = _getMotivationalMessage(mood);
    });
  }

  // Function to return motivational message based on selected mood
  String _getMotivationalMessage(String mood) {
    switch (mood) {
      case 'Great!':
        return "Awesome! Keep shining!";
      case 'Good':
        return "You're doing great! Keep it up!";
      case 'Neutral':
        return "It's okay! Every day is a new opportunity.";
      case 'Bad':
        return "Stay strong, better days are ahead!";
      case 'Awful!':
        return "Don't worry, tomorrow will be better!";
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Background gradient-like color
      appBar: AppBar(
        title: Text('Mood Tracker'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How was your day today?',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Mood Section
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _onMoodSelected('Great!'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mood',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Notes Section
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _onMoodSelected('Good'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mood',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'I am feeling:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Mood Options
            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.center,
              children: [
                _buildMoodOption(Icons.sentiment_very_satisfied, 'Great!', Colors.green),
                _buildMoodOption(Icons.sentiment_satisfied, 'Good', Colors.lightGreen),
                _buildMoodOption(Icons.sentiment_neutral, 'Neutral', Colors.amber),
                _buildMoodOption(Icons.sentiment_dissatisfied, 'Bad', Colors.orange),
                _buildMoodOption(Icons.sentiment_very_dissatisfied, 'Awful!', Colors.red),
              ],
            ),
            SizedBox(height: 20),
            // Display selected mood and motivational message
            if (selectedMood.isNotEmpty) ...[
              Text(
                'You selected: $selectedMood',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                motivationalMessage,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Action for navigating or saving mood
                if (selectedMood.isNotEmpty) {
                  // Add any additional actions for the "Continue" button, if needed.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Your mood has been saved!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mood option widget
  Widget _buildMoodOption(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () => _onMoodSelected(label), // Select mood on tap
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(15),
            child: Icon(
              icon,
              color: color,
              size: 40,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


// Habit Tracker Screen


class HabitTrackerScreen extends StatefulWidget {
  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final Map<String, List<String>> habits = {
    'Monday': [
      'Read 10 pages of a book',
      'Meditate for 5 minutes',
      'Exercise for 30 minutes',
      'Drink 2 liters of water',
      'Eat a healthy breakfast',
      'Sleep 8 hours',
      'Write in a journal',
      'Plan tomorrow’s tasks',
      'Avoid social media before bed',
      'Stretch before sleep'
    ],
    'Tuesday': [
      'Walk for 30 minutes',
      'Practice gratitude',
      'Read 10 pages of a book',
      'Eat a healthy lunch',
      'Drink 2 liters of water',
      'Meditate for 5 minutes',
      'Avoid junk food',
      'Work on a hobby',
      'Write in a journal',
      'Stretch before sleep'
    ],
    'Wednesday': [
      'Read 10 pages of a book',
      'Meditate for 10 minutes',
      'Go for a run',
      'Drink green tea',
      'Eat a balanced lunch',
      'Plan weekly goals',
      'Do a random act of kindness',
      'Take a 15-minute walk',
      'Listen to a podcast',
      'Go to bed early'
    ],
    'Thursday': [
      'Drink a glass of water after waking up',
      'Write 3 things you are grateful for',
      'Read a motivational article',
      'Eat a healthy breakfast',
      'Exercise for 20 minutes',
      'Avoid sugar for the day',
      'Organize your workspace',
      'Spend time with family',
      'Do deep breathing exercises',
      'Reflect on your day'
    ],
    'Friday': [
      'Review weekly achievements',
      'Meditate for 15 minutes',
      'Drink 8 glasses of water',
      'Walk 10,000 steps',
      'Eat a healthy dinner',
      'Plan the weekend',
      'Declutter your home',
      'Practice mindfulness',
      'Avoid screen time before bed',
      'Stretch for 10 minutes'
    ],
    'Saturday': [
      'Wake up early',
      'Do a fun workout',
      'Have a healthy smoothie',
      'Read 20 pages of a book',
      'Spend time outdoors',
      'Cook a healthy meal',
      'Watch an inspiring video',
      'Call a loved one',
      'Write your thoughts in a journal',
      'Go to bed on time'
    ],
    'Sunday': [
      'Plan the week ahead',
      'Review weekly habits',
      'Read a self-help book',
      'Go for a nature walk',
      'Prepare healthy meals for the week',
      'Drink herbal tea',
      'Do yoga or stretching',
      'Organize your space',
      'Write in your gratitude journal',
      'Get 8 hours of sleep'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: daysOfWeek.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Habit Tracker'),
          bottom: TabBar(
            isScrollable: true,
            tabs: daysOfWeek.map((day) => Tab(text: day)).toList(),
          ),
        ),
        body: TabBarView(
          children: daysOfWeek.map((day) {
            return HabitList(day: day, habits: habits[day]!);
          }).toList(),
        ),
      ),
    );
  }
}
class HabitList extends StatefulWidget {
  final String day;
  final List<String> habits;

  HabitList({required this.day, required this.habits});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  late List<bool> isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = List<bool>.filled(widget.habits.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: widget.habits.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(
            widget.habits[index],
            style: TextStyle(fontSize: 16.0),
          ),
          value: isChecked[index],
          onChanged: (value) {
            setState(() {
              isChecked[index] = value!;
            });
          },
        );
      },
    );
  }
}

// Water Intake Tracker Screen

class WaterTrackerScreen extends StatefulWidget {
  @override
  _WaterTrackerScreenState createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  double _waterIntake = 0.0;  // Current water intake
  double _goal = 2.0; // Goal in liters
  List<String> _waterHistory = []; // List to hold history of intake

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data from shared preferences when the screen initializes
  }

  // Load saved data from shared preferences
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = prefs.getDouble('waterIntake') ?? 0.0;
      _waterHistory = prefs.getStringList('waterHistory') ?? [];
    });
  }

  // Save data to shared preferences
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('waterIntake', _waterIntake);
    await prefs.setStringList('waterHistory', _waterHistory);
  }

  // Function to log water intake
  void _logWater() {
    setState(() {
      final time = DateFormat('hh:mm a').format(DateTime.now());
      _waterHistory.insert(0, 'Drank $_waterIntake L at $time');
      _saveData();  // Save data after logging
    });
  }

  // Function to increase water intake
  void _addWater() {
    setState(() {
      _waterIntake += 0.25;  // Increase intake by 0.25L
      _saveData();  // Save data after updating
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Tracker'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Water Log Section
              Text(
                'Log Your Water Intake',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              // Water Intake Display
              Text(
                'Current Water Intake: ${_waterIntake.toStringAsFixed(2)} L',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Goal Display
              Text(
                'Your Goal: $_goal L',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Add Water Button
              ElevatedButton(
                onPressed: _addWater,
                child: Text('Add 0.25L'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              SizedBox(height: 20),
              // Log Water Button
              ElevatedButton(
                onPressed: _logWater,
                child: Text('Log Water'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              SizedBox(height: 40),
              // Water History Section
              Text(
                'Water Intake History',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Display Water History
              _waterHistory.isNotEmpty
                  ? Column(
                children: _waterHistory.map((entry) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        entry,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }).toList(),
              )
                  : Text(
                'No water logs available yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class SleepTrackerScreen extends StatefulWidget {
  @override
  _SleepTrackerScreenState createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  DateTime? _sleepStart;
  DateTime? _sleepEnd;
  double _sleepHours = 0.0;
  double _goal = 8.0;
  double _sleepQuality = 5.0;
  List<Map<String, dynamic>> _sleepHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSleepHistory();
  }

  // Function to calculate hours slept
  void _calculateSleepHours() {
    if (_sleepStart != null && _sleepEnd != null) {
      final difference = _sleepEnd!.difference(_sleepStart!);
      setState(() {
        _sleepHours = difference.inHours + (difference.inMinutes % 60) / 60;
      });
    }
  }

  // Function to log sleep entry
  void _logSleep() async {
    if (_sleepStart != null && _sleepEnd != null) {
      setState(() {
        _sleepHistory.insert(0, {
          'start': DateFormat('hh:mm a').format(_sleepStart!),
          'end': DateFormat('hh:mm a').format(_sleepEnd!),
          'hours': _sleepHours.toStringAsFixed(1),
          'quality': _sleepQuality.toStringAsFixed(1),
        });
      });
      await _saveSleepHistory();
    }
  }

  // Function to save sleep history to SharedPreferences
  Future<void> _saveSleepHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyList = _sleepHistory.map((entry) {
      return '${entry['start']},${entry['end']},${entry['hours']},${entry['quality']}';
    }).toList();
    await prefs.setStringList('sleepHistory', historyList);
  }

  // Function to load sleep history from SharedPreferences
  Future<void> _loadSleepHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? historyList = prefs.getStringList('sleepHistory');
    if (historyList != null) {
      setState(() {
        _sleepHistory = historyList.map((entry) {
          var parts = entry.split(',');
          return {
            'start': parts[0],
            'end': parts[1],
            'hours': parts[2],
            'quality': parts[3],
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sleep Log Section
              Text(
                'Log Your Sleep',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              // Sleep Start Time Picker
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'Start Time: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _sleepStart = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      },
                      child: Text(
                        _sleepStart == null
                            ? 'Select Time'
                            : DateFormat('hh:mm a').format(_sleepStart!),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Sleep End Time Picker
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    'End Time: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _sleepEnd = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      },
                      child: Text(
                        _sleepEnd == null
                            ? 'Select Time'
                            : DateFormat('hh:mm a').format(_sleepEnd!),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Sleep Duration Calculation
              ElevatedButton(
                onPressed: () {
                  _calculateSleepHours();
                },
                child: Text('Calculate Sleep Duration'),
              ),
              SizedBox(height: 20),
              // Display Calculated Sleep Hours
              Text(
                'Total Sleep Hours: ${_sleepHours.toStringAsFixed(1)} hrs',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              // Sleep Quality Rating
              Text(
                'Rate Your Sleep Quality: ',
                style: TextStyle(fontSize: 18),
              ),
              Slider(
                value: _sleepQuality,
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: _sleepQuality.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _sleepQuality = value;
                  });
                },
                activeColor: Colors.orangeAccent,
                inactiveColor: Colors.orange,
              ),
              SizedBox(height: 20),
              // Log Sleep Button
              ElevatedButton(
                onPressed: () {
                  _logSleep();
                },
                child: Text('Log Sleep'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              SizedBox(height: 40),
              // Sleep History Section
              Text(
                'Sleep History',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Display Sleep History
              _sleepHistory.isNotEmpty
                  ? Column(
                children: _sleepHistory.map((entry) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        '${entry['start']} - ${entry['end']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Sleep: ${entry['hours']} hrs | Quality: ${entry['quality']}/10',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
              )
                  : Text(
                'No sleep logs available yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

