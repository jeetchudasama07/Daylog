import 'package:flutter/material.dart';
import 'daylog_details_screen.dart';
import 'daylog_storage.dart';
import 'models.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Daylog> history = DaylogStorage.getDaylogs().reversed.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 34),

              _buildMonthHeader(),

              const SizedBox(height: 14),

              if (history.isEmpty)
                _buildEmptyState()
              else
                _buildHistoryList(
                  context,
                  history,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR JOURNEY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
            color: Color(0xFF3F6B63),
          ),
        ),

        SizedBox(height: 7),

        Text(
          'History',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
            color: Color(0xFF202522),
          ),
        ),

        SizedBox(height: 7),

        Text(
          'Look back at your days.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF858B87),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // MONTH HEADER
  // ------------------------------------------------------------

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your entries',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF303632),
          ),
        ),

        Text(
          '${DaylogStorage.count} '
          '${DaylogStorage.count == 1 ? 'entry' : 'entries'}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF858B87),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7E4),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 38,
            color: Color(0xFF9AA09C),
          ),

          SizedBox(height: 14),

          Text(
            'No entries yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF303632),
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Your saved days will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF858B87),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HISTORY LIST
  // ------------------------------------------------------------

  Widget _buildHistoryList(
    BuildContext context,
    List<Daylog> history,
  ) {
    return Column(
      children: List.generate(
        history.length,
        (index) {
          return _buildHistoryItem(
            context,
            history[index],
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // HISTORY ITEM
  // ------------------------------------------------------------

  Widget _buildHistoryItem(
    BuildContext context,
    Daylog daylog,
  ) {
    final completed =
        daylog.tasks.where((task) => task.completed).length;

    final total = daylog.tasks.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DaylogDetailsScreen(
              daylog: daylog,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE5E7E4),
          ),
        ),
        child: Row(
          children: [
            _buildDateBlock(daylog),

            const SizedBox(width: 16),

            Expanded(
              child: _buildHistoryInfo(
                daylog,
                completed,
                total,
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFFB0B5B2),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // DATE BLOCK
  // ------------------------------------------------------------

  Widget _buildDateBlock(Daylog daylog) {
    final date = DateTime.tryParse(daylog.date);

    if (date == null) {
      return Container(
        width: 54,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F2),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(
          Icons.calendar_today_outlined,
          size: 22,
          color: Color(0xFF3F6B63),
        ),
      );
    }

    const weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F2),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            '${date.day}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF303632),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            weekdays[date.weekday - 1],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF858B87),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HISTORY INFORMATION
  // ------------------------------------------------------------

  Widget _buildHistoryInfo(
    Daylog daylog,
    int completed,
    int total,
  ) {
    final date = DateTime.tryParse(daylog.date);

    String formattedDate = daylog.date;

    if (date != null) {
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

      formattedDate =
          '${weekdays[date.weekday - 1]}, '
          '${date.day} ${months[date.month - 1]}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF303632),
          ),
        ),

        const SizedBox(height: 9),

        Row(
          children: [
            ...List.generate(
              daylog.checkIns.length > 3
                  ? 3
                  : daylog.checkIns.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  _getMoodIcon(
                    daylog.checkIns[index].mood,
                  ),
                  size: 19,
                  color: const Color(0xFF3F6B63),
                ),
              ),
            ),

            if (daylog.checkIns.isNotEmpty)
              const SizedBox(width: 4),

            Text(
              '${daylog.checkIns.length} '
              '${daylog.checkIns.length == 1 ? 'check-in' : 'check-ins'}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF858B87),
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 15,
              color: Color(0xFF858B87),
            ),

            const SizedBox(width: 5),

            Text(
              '$completed/$total tasks completed',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF858B87),
              ),
            ),
          ],
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