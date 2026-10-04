import 'package:flutter/material.dart';
import 'models.dart';
import 'daylog_storage.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onHistoryTap;
  final VoidCallback? onInsightsTap;

  const HomeScreen({
    super.key,
    this.onHistoryTap,
    this.onInsightsTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedMood = -1;

  final TextEditingController journalController =
      TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {
      'icon': Icons.sentiment_very_satisfied_outlined,
      'label': 'Great',
    },
    {
      'icon': Icons.sentiment_satisfied_outlined,
      'label': 'Good',
    },
    {
      'icon': Icons.sentiment_neutral_outlined,
      'label': 'Okay',
    },
    {
      'icon': Icons.sentiment_dissatisfied_outlined,
      'label': 'Low',
    },
    {
      'icon': Icons.sentiment_very_dissatisfied_outlined,
      'label': 'Bad',
    },
  ];

  // Starts EMPTY now.
  final List<Task> tasks = [];

  @override
  void dispose() {
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  24,
                  22,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 38),

                    _buildMoodSection(),

                    const SizedBox(height: 38),

                    _buildTasksSection(),

                    const SizedBox(height: 38),

                    _buildJournalSection(),

                    const SizedBox(height: 32),

                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DAYLOG',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: Color(0xFF3F6B63),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Today',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.2,
                color: Color(0xFF202522),
              ),
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              weekdays[now.weekday - 1],
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF858B87),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              '${now.day} ${months[now.month - 1]}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF454B47),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // MOOD
  // ============================================================

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202522),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Take a moment to check in.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF858B87),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            moods.length,
            (index) => _buildMoodItem(index),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodItem(int index) {
    final mood = moods[index];
    final bool isSelected = selectedMood == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 58,
        height: 72,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE2ECE8)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3F6B63)
                : const Color(0xFFE7E8E5),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mood['icon'],
              size: 27,
              color: isSelected
                  ? const Color(0xFF3F6B63)
                  : const Color(0xFF858B87),
            ),

            const SizedBox(height: 6),

            Text(
              mood['label'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF3F6B63)
                    : const Color(0xFF858B87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TASKS
  // ============================================================

  Widget _buildTasksSection() {
    final completed =
        tasks.where((task) => task.completed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s tasks',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: Color(0xFF202522),
              ),
            ),

            Text(
              '$completed/${tasks.length}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF858B87),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Task container
        if (tasks.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE7E8E5),
              ),
            ),
            child: Column(
              children: List.generate(
                tasks.length,
                (index) => _buildTaskItem(index),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE7E8E5),
              ),
            ),
            child: const Center(
              child: Text(
                'No tasks added yet.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9AA09C),
                ),
              ),
            ),
          ),

        const SizedBox(height: 13),

        // Add task button
        GestureDetector(
          onTap: _showAddTaskDialog,
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2ECE8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 19,
                  color: Color(0xFF3F6B63),
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Add a task',
                style: TextStyle(
                  color: Color(0xFF68716C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADD TASK DIALOG
  // ============================================================

  void _showAddTaskDialog() {
    final TextEditingController taskController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Add a task',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Color(0xFF202522),
            ),
          ),
          content: TextField(
            controller: taskController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'What do you want to do?',
              hintStyle: const TextStyle(
                color: Color(0xFFB0B5B2),
              ),
              filled: true,
              fillColor: const Color(0xFFF7F7F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF69716C),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final title = taskController.text.trim();

                if (title.isEmpty) {
                  return;
                }

                setState(() {
                  tasks.add(
                    Task(
                      title: title,
                      completed: false,
                    ),
                  );
                });

                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F6B63),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(int index) {
    final task = tasks[index];

    return InkWell(
      onTap: () {
        setState(() {
          task.completed = !task.completed;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color: task.completed
                    ? const Color(0xFF3F6B63)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.completed
                      ? const Color(0xFF3F6B63)
                      : const Color(0xFFC7CCC9),
                ),
              ),
              child: task.completed
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 14,
                  color: task.completed
                      ? const Color(0xFF9EA4A0)
                      : const Color(0xFF454B47),
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // JOURNAL
  // ============================================================

  Widget _buildJournalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s on your mind?',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202522),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'A few words are enough.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF858B87),
          ),
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          height: 125,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE7E8E5),
            ),
          ),
          child: TextField(
            controller: journalController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF303632),
            ),
            decoration: const InputDecoration(
              hintText: 'Write something about your day...',
              hintStyle: TextStyle(
                color: Color(0xFFB0B5B2),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _saveDaylog() async {
    // Require at least one piece of information.
    if (selectedMood == -1 &&
        tasks.isEmpty &&
        journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add a mood, task, or journal entry first.',
          ),
        ),
      );
      return;
    }

    final now = DateTime.now();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final String date =
        '${weekdays[now.weekday - 1]}, '
        '${now.day} ${months[now.month - 1]}';

    final List<CheckIn> checkIns = [];

    if (selectedMood != -1) {
      checkIns.add(
        CheckIn(
          time:
              '${now.hour.toString().padLeft(2, '0')}:'
              '${now.minute.toString().padLeft(2, '0')}',
          mood: moods[selectedMood]['label'],
          note: journalController.text.trim(),
        ),
      );
    }

    final daylog = Daylog(
      date: date,
      checkIns: checkIns,
      tasks: tasks
          .map(
            (task) => Task(
              title: task.title,
              completed: task.completed,
            ),
          )
          .toList(),
      journal: journalController.text.trim(),
    );

    await DaylogStorage.saveDaylog(daylog);

    if (!mounted) return;

    setState(() {
      selectedMood = -1;
      tasks.clear();
      journalController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daylog entry saved'),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: ElevatedButton(
        onPressed: _saveDaylog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F6B63),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Save today\'s log',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}