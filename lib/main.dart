import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart To-Do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: HomePage(),
    );
  }
}

// Custom Task Model with Deadline
class Task {
  String title;
  DateTime? deadline;
  bool isDone;

  Task({required this.title, this.deadline, this.isDone = false});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController task = TextEditingController();
  final List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart To-Do'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: task,
              decoration: InputDecoration(
                labelText: 'Enter a Task',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (task.text.trim().isEmpty) return;

                      // Date Picker
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (selectedDate == null) return;

                      // Time Picker
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime == null) return;

                      // Combine date + time
                      DateTime deadline = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      setState(() {
                        tasks.add(Task(title: task.text.trim(), deadline: deadline));
                        task.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: Text(
                      'Add Task',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text("No tasks yet"))
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.purple[200],
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tasks[index].title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (tasks[index].deadline != null)
                          Text(
                            'Due: ${tasks[index].deadline!.day}/${tasks[index].deadline!.month} ${tasks[index].deadline!.hour.toString().padLeft(2, '0')}:${tasks[index].deadline!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.black87, fontSize: 12),
                          ),
                      ],
                    ),
                    leading: Checkbox(
                      value: tasks[index].isDone,
                      onChanged: (bool? value) {
                        setState(() {
                          tasks[index].isDone = value!;
                        });
                      },
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
