import 'package:flutter/material.dart';
import 'daylog_storage.dart';
import 'models.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Daylog> daylogs =
        DaylogStorage.getDaylogs();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
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

              const SizedBox(height: 30),

              _buildPeriodSelector(),

              const SizedBox(height: 25),

              _buildMoodOverview(daylogs),

              const SizedBox(height: 22),

              _buildMoodTrend(daylogs),

              const SizedBox(height: 22),

              _buildProductivity(daylogs),

              const SizedBox(height: 22),

              _buildPatternCard(daylogs),
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
          'YOUR PATTERNS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
            color: Color(0xFF3F6B63),
          ),
        ),

        SizedBox(height: 7),

        Text(
          'Insights',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
            color: Color(0xFF202522),
          ),
        ),

        SizedBox(height: 7),

        Text(
          'A clearer picture of your days.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF858B87),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PERIOD SELECTOR
  // ------------------------------------------------------------

  Widget _buildPeriodSelector() {
    return Row(
      children: [
        _periodButton('7 days', true),

        const SizedBox(width: 8),

        _periodButton('30 days', false),

        const SizedBox(width: 8),

        _periodButton('All time', false),
      ],
    );
  }

  Widget _periodButton(
    String text,
    bool selected,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF3F6B63)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? const Color(0xFF3F6B63)
              : const Color(0xFFE5E7E4),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected
              ? Colors.white
              : const Color(0xFF69716C),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MOOD OVERVIEW
  // ------------------------------------------------------------

  Widget _buildMoodOverview(
    List<Daylog> daylogs,
  ) {
    final checkIns = daylogs
        .expand((daylog) => daylog.checkIns)
        .toList();

    final moodScores = {
      'Great': 10,
      'Good': 8,
      'Okay': 6,
      'Low': 4,
      'Bad': 2,
    };

    double averageMood = 0;

    if (checkIns.isNotEmpty) {
      final total = checkIns.fold<int>(
        0,
        (sum, checkIn) =>
            sum + (moodScores[checkIn.mood] ?? 6),
      );

      averageMood = total / checkIns.length;
    }

    String moodLabel = 'No data';

    if (averageMood >= 8.5) {
      moodLabel = 'Great';
    } else if (averageMood >= 6.5) {
      moodLabel = 'Good';
    } else if (averageMood >= 4.5) {
      moodLabel = 'Okay';
    } else if (averageMood > 0) {
      moodLabel = 'Low';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7E4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mood overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF303632),
                ),
              ),

              if (checkIns.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2ECE8),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    moodLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F6B63),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                checkIns.isEmpty
                    ? '—'
                    : averageMood.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                  color: Color(0xFF202522),
                ),
              ),

              if (checkIns.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(
                    left: 7,
                    bottom: 7,
                  ),
                  child: Text(
                    '/ 10',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF858B87),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            'Average mood',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF858B87),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _moodCount(
                Icons.sentiment_very_satisfied_outlined,
                _countMood(daylogs, 'Great'),
                'Great',
              ),
              _moodCount(
                Icons.sentiment_satisfied_outlined,
                _countMood(daylogs, 'Good'),
                'Good',
              ),
              _moodCount(
                Icons.sentiment_neutral_outlined,
                _countMood(daylogs, 'Okay'),
                'Okay',
              ),
              _moodCount(
                Icons.sentiment_dissatisfied_outlined,
                _countMood(daylogs, 'Low'),
                'Low',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _countMood(
    List<Daylog> daylogs,
    String mood,
  ) {
    int count = 0;

    for (final daylog in daylogs) {
      for (final checkIn in daylog.checkIns) {
        if (checkIn.mood == mood) {
          count++;
        }
      }
    }

    return count.toString();
  }

  Widget _moodCount(
    IconData icon,
    String count,
    String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: const Color(0xFF3F6B63),
        ),

        const SizedBox(height: 6),

        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF303632),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF9AA09C),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // MOOD TREND
  // ------------------------------------------------------------

  Widget _buildMoodTrend(
    List<Daylog> daylogs,
  ) {
    final values = _getMoodTrendValues(daylogs);

    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7E4),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Mood trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF303632),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Your mood across the week',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF858B87),
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: List.generate(
                values.length,
                (index) {
                  return Column(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 22,
                        height: values[index] == 0
                            ? 8
                            : 125 * values[index],
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF3F6B63),
                          borderRadius:
                              BorderRadius.circular(7),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        days[index],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9AA09C),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _getMoodTrendValues(
    List<Daylog> daylogs,
  ) {
    final values = List<double>.filled(7, 0);

    for (final daylog in daylogs) {
      final date = DateTime.tryParse(daylog.date);

      if (date == null ||
          daylog.checkIns.isEmpty) {
        continue;
      }

      double total = 0;

      for (final checkIn in daylog.checkIns) {
        total += _moodScore(checkIn.mood);
      }

      final average =
          total / daylog.checkIns.length;

      values[date.weekday - 1] =
          average / 10;
    }

    return values;
  }

  double _moodScore(String mood) {
    switch (mood) {
      case 'Great':
        return 10;

      case 'Good':
        return 8;

      case 'Okay':
        return 6;

      case 'Low':
        return 4;

      case 'Bad':
        return 2;

      default:
        return 6;
    }
  }

  // ------------------------------------------------------------
  // PRODUCTIVITY
  // ------------------------------------------------------------

Widget _buildProductivity(
  List<Daylog> daylogs,
) {
  int completed = 0;
  int total = 0;

  for (final daylog in daylogs) {
    total += daylog.tasks.length;

    completed += daylog.tasks
        .where((task) => task.completed)
        .length;
  }

  // Calculate completion percentage
  double percentage = 0.0;

  if (total > 0) {
    percentage = completed / total;
  }

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xFFE5E7E4),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Productivity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF303632),
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'How consistently you completed your tasks',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF858B87),
          ),
        ),

        const SizedBox(height: 22),

        Row(
          children: [
            SizedBox(
              width: 82,
              height: 82,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 82,
                    height: 82,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 7,
                      backgroundColor: const Color(0xFFE9ECE9),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3F6B63),
                      ),
                    ),
                  ),

                  Text(
                    '${(percentage * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF303632),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 22),

            Expanded(
              child: Column(
                children: [
                  _productivityRow(
                    'Tasks completed',
                    '$completed / $total',
                  ),

                  const SizedBox(height: 10),

                  _productivityRow(
                    'Days logged',
                    '${daylogs.length}',
                  ),

                  const SizedBox(height: 10),

                  _productivityRow(
                    'Daily average',
                    daylogs.isEmpty
                        ? '0 tasks'
                        : '${(total / daylogs.length).toStringAsFixed(1)} tasks',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _productivityRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF858B87),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF454B47),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PATTERN CARD
  // ------------------------------------------------------------

  Widget _buildPatternCard(
    List<Daylog> daylogs,
  ) {
    String message;

    if (daylogs.isEmpty) {
      message =
          'Start saving your daily logs and Daylog will '
          'show useful patterns here.';
    } else {
      message =
          'Keep logging your days. As you collect more '
          'entries, Daylog will make your patterns clearer.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE2ECE8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFF3F6B63),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              size: 19,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Something to notice',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF303632),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF59645F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}