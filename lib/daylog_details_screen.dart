import 'package:flutter/material.dart';
import 'models.dart';

class DaylogDetailsScreen extends StatelessWidget {
  final Daylog daylog;

  const DaylogDetailsScreen({
    super.key,
    required this.daylog,
  });

  @override
  Widget build(BuildContext context) {
    final completed =
        daylog.tasks.where((task) => task.completed).length;

    final total = daylog.tasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context),

                    const SizedBox(height: 30),

                    _buildDateHeader(),

                    const SizedBox(height: 35),

                    _buildSectionTitle(
                      'CHECK-INS',
                      '${daylog.checkIns.length} '
                      '${daylog.checkIns.length == 1 ? 'check-in' : 'check-ins'}',
                    ),

                    const SizedBox(height: 16),

                    _buildCheckIns(),

                    const SizedBox(height: 36),

                    _buildSectionTitle(
                      'TODAY\'S TASKS',
                      '$completed/$total completed',
                    ),

                    const SizedBox(height: 15),

                    _buildTasks(),

                    const SizedBox(height: 36),

                    _buildJournalSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E7E4),
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 19,
              color: Color(0xFF454B47),
            ),
          ),
        ),

        const Spacer(),

        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7E4),
            ),
          ),
          child: const Icon(
            Icons.more_horiz,
            size: 20,
            color: Color(0xFF69716C),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // DATE HEADER
  // ------------------------------------------------------------

  Widget _buildDateHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          daylog.date,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: Color(0xFF202522),
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Your day at a glance.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF858B87),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _buildSectionTitle(
    String title,
    String trailing,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: Color(0xFF3F6B63),
          ),
        ),

        Text(
          trailing,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF858B87),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // CHECK-INS
  // ------------------------------------------------------------

  Widget _buildCheckIns() {
    if (daylog.checkIns.isEmpty) {
      return const Text(
        'No check-ins recorded.',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFF858B87),
        ),
      );
    }

    return Column(
      children: List.generate(
        daylog.checkIns.length,
        (index) {
          final checkIn = daylog.checkIns[index];

          return _buildCheckInItem(
            checkIn,
            isLast: index == daylog.checkIns.length - 1,
          );
        },
      ),
    );
  }

  Widget _buildCheckInItem(
    CheckIn checkIn, {
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            checkIn.time,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF69716C),
            ),
          ),
        ),

        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFE2ECE8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getMoodIcon(checkIn.mood),
                size: 20,
                color: const Color(0xFF3F6B63),
              ),
            ),

            if (!isLast)
              Container(
                width: 1,
                height: 66,
                color: const Color(0xFFDDE1DE),
              ),
          ],
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 1,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkIn.mood,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF303632),
                  ),
                ),

                const SizedBox(height: 5),

                if (checkIn.note.isNotEmpty)
                  Text(
                    checkIn.note,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: Color(0xFF858B87),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TASKS
  // ------------------------------------------------------------

  Widget _buildTasks() {
    if (daylog.tasks.isEmpty) {
      return const Text(
        'No tasks recorded.',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFF858B87),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7E4),
        ),
      ),
      child: Column(
        children: List.generate(
          daylog.tasks.length,
          (index) {
            return _buildTaskItem(
              daylog.tasks[index],
              isLast: index == daylog.tasks.length - 1,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    Task task, {
    required bool isLast,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0xFFEDEEEB),
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
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
                fontSize: 13,
                color: task.completed
                    ? const Color(0xFF9EA4A0)
                    : const Color(0xFF454B47),
                decoration:
                    task.completed
                        ? TextDecoration.lineThrough
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // JOURNAL
  // ------------------------------------------------------------

  Widget _buildJournalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'JOURNAL',
          daylog.journal.trim().isEmpty ? '0 entries' : '1 entry',
        ),

        const SizedBox(height: 15),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE5E7E4),
            ),
          ),
          child: Text(
            daylog.journal.trim().isEmpty
                ? 'No journal entry for this day.'
                : daylog.journal,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF454B47),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // MOOD ICON
  // ------------------------------------------------------------

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'Great':
        return Icons.sentiment_very_satisfied_outlined;

      case 'Good':
        return Icons.sentiment_satisfied_outlined;

      case 'Okay':
        return Icons.sentiment_neutral_outlined;

      case 'Low':
        return Icons.sentiment_dissatisfied_outlined;

      case 'Bad':
        return Icons.sentiment_very_dissatisfied_outlined;

      default:
        return Icons.sentiment_neutral_outlined;
    }
  }
}