import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/components/lesson/chapter_title.dart';
import 'package:signflow/services/progress_service.dart';

class UnitTitle extends StatefulWidget {
  const UnitTitle(
    this.title,
    this.unit,
    this.chapters,
    this.ikon, {
    super.key,
    required this.isLocked,
    required this.completedChapters,
    this.onChapterComplete,
  });

  final String title;
  final int unit;
  final List<Map<String, dynamic>> chapters;
  final IconData ikon;
  final bool isLocked;
  final Set<String> completedChapters;
  final Function(String)?
  onChapterComplete; 

  @override
  State<UnitTitle> createState() => _UnitTitleState();
}

class _UnitTitleState extends State<UnitTitle> {
  bool showChapters = false;
  final ProgressService _progressService = ProgressService();

  void toggleChapters() {
    setState(() {
      showChapters = !showChapters;
    });
  }

  Future<bool> _checkIfChapterIsLocked(
    int unitNumber,
    int actualChapterNumber,
  ) async {
    if (widget.isLocked) return true;

    if (actualChapterNumber == 1) return false;

    final prevChapterKey = '${widget.unit}-${actualChapterNumber - 1}';

    final progressData = await _progressService.loadProgress(
      3,
    ); // Assuming max HP 3
    final completedChapters = progressData['completedChapters'] as Set<String>;

    return !completedChapters.contains(prevChapterKey);
  }

  void _handleChapterComplete(String chapterKey) {
    widget.onChapterComplete?.call(
      chapterKey,
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.unitButtonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: widget.isLocked ? null : toggleChapters,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.menu, color: AppColors.chipColor),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 2,
                  color: AppColors.separatorColor,
                  height: 110,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: AppTextStyles.title),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.unitLabelBackground,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'UNIT ${widget.unit}',
                              style: AppTextStyles.unitLabel,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${widget.chapters.length} ${AppText.enText['chapter_label_prefix']!.trim()}',
                            style: AppTextStyles.chapterText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  widget.isLocked ? Icons.lock : widget.ikon,
                  color: AppColors.chipColor,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        if (showChapters)
          Column(
            children:
                widget.chapters.asMap().entries.map((entry) {
                  final chapter = entry.value;
                  final actualChapterNumber = chapter['chapter'] as int;

                  return FutureBuilder<bool>(
                    future: _checkIfChapterIsLocked(
                      widget.unit,
                      actualChapterNumber,
                    ),
                    builder: (context, snapshot) {
                      final isChapterLocked = snapshot.data ?? true;

                      final chapterKey = '${widget.unit}-$actualChapterNumber';
                      final isCompleted = widget.completedChapters.contains(
                        chapterKey,
                      );

                      return ChapterTitle(
                        unit: widget.unit,
                        chapter: actualChapterNumber,
                        title: chapter['title'],
                        completed: isCompleted,
                        locked: isChapterLocked,
                        onChapterComplete:
                            _handleChapterComplete, 
                      );
                    },
                  );
                }).toList(),
          ),
      ],
    );
  }
}
