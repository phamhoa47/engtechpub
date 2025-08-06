import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import '../models/vocabulary_item.dart';
import 'package:appta/features/games/word_sprint_game/word_sprint_screen.dart';
import 'package:appta/features/games/game_quiz/vocabulary_quiz_screen.dart';

class VocabularyFlashcardPage extends StatefulWidget {
  final List<VocabularyItem> items;
  final int initialIndex;

  const VocabularyFlashcardPage({
    super.key,
    required this.items,
    this.initialIndex = 0,
  });

  @override
  State<VocabularyFlashcardPage> createState() =>
      _VocabularyFlashcardPageState();
}

class _VocabularyFlashcardPageState extends State<VocabularyFlashcardPage> {
  late PageController _pageController;
  late int currentIndex;
  final FlutterTts _tts = FlutterTts();
  final List<GlobalKey<FlipCardState>> _cardKeys = [];
  Timer? _flipTimer;
  Timer? _autoNextTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    debugPrint("📌 Flashcard initState()");
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
    _cardKeys.addAll(
      List.generate(widget.items.length, (_) => GlobalKey<FlipCardState>()),
    );
    _startAutoFlipAndNext();
  }

  @override
  void dispose() {
    debugPrint("♻️ dispose() Flashcard");
    _isDisposed = true;
    _stopTimers();
    _pageController.dispose();
    super.dispose();
  }

  void _stopTimers() {
    debugPrint("⏹ Huỷ timer");
    _flipTimer?.cancel();
    _autoNextTimer?.cancel();
  }

  void _startAutoFlipAndNext() {
    _stopTimers();
    debugPrint("⏳ Bắt đầu auto flip + auto next cho card $currentIndex");

    _flipTimer = Timer(const Duration(seconds: 3), () {
      if (!_isDisposed) {
        debugPrint("🔄 Auto Flip card $currentIndex");
        _cardKeys[currentIndex].currentState?.toggleCard();
      }
    });

    _autoNextTimer = Timer(const Duration(seconds: 5), () {
      if (!_isDisposed) {
        debugPrint("➡️ Auto Next card");
        _nextCard();
      }
    });
  }

  void _speak(String text) async {
    debugPrint("🔊 Phát âm: $text");
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1);
    await _tts.speak(text);
  }

  void _nextCard() {
    if (currentIndex < widget.items.length - 1 && !_isDisposed) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevCard() {
    if (currentIndex > 0 && !_isDisposed) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _confirmExit() {
    _stopTimers();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận thoát"),
        content: const Text("Bạn có muốn thoát khỏi chế độ Flashcard không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Không"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // đóng dialog
              Navigator.pop(context); // thoát về list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade100,
            ),
            child: const Text("Có"),
          ),
        ],
      ),
    );
  }

  void _showGameMenu(BuildContext context) {
    _stopTimers(); // 🔹 Dừng auto flip/next trước khi chuyển sang game
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "🎮 Chọn chế độ chơi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Nút chơi Quiz
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.blueAccent),
                title: const Text("Quiz từ vựng"),
                subtitle: const Text("Trả lời câu hỏi chọn nghĩa đúng"),
                onTap: () {
                  Navigator.pop(context); // đóng menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VocabularyQuizScreen(items: widget.items),
                    ),
                  );
                },
              ),
              const Divider(),

              // Nút chơi Word Sprint
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.redAccent),
                title: const Text("Word Sprint"),
                subtitle: const Text("Chạy đua với thời gian để chọn nghĩa đúng"),
                onTap: () {
                  Navigator.pop(context); // đóng menu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WordSprintScreen(items: widget.items),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("Không có từ vựng", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text('Flashcards (${currentIndex + 1}/${widget.items.length})'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: _confirmExit,
        ),
        actions: [
          IconButton(
            tooltip: "Chơi game từ vựng",
            icon: const Icon(Icons.videogame_asset, color: Colors.orange),
            onPressed: () {
              _showGameMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / widget.items.length,
            backgroundColor: Colors.grey.shade300,
            color: Colors.greenAccent,
            minHeight: 4,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                _stopTimers();
                setState(() => currentIndex = index);
                _startAutoFlipAndNext();
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlipCard(
                      key: _cardKeys[index],
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildFrontCard(item),
                      back: _buildBackCard(item),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _prevCard,
                          icon: const Icon(Icons.arrow_back_ios, size: 18),
                          label: const Text("Back"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade100,
                            foregroundColor: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _cardKeys[currentIndex].currentState?.toggleCard(),
                          icon: const Icon(Icons.flip_camera_android, size: 18),
                          label: const Text("Flip"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade100,
                            foregroundColor: Colors.deepPurple.shade900,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _nextCard,
                          icon: const Icon(Icons.arrow_forward_ios, size: 18),
                          label: const Text("Next"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade100,
                            foregroundColor: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(VocabularyItem item) {
    return _buildCard(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.word,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.pronunciation,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Icon(item.icon, size: 140, color: Colors.blueGrey),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(
              Icons.volume_up_rounded,
              color: Colors.amber,
              size: 32,
            ),
            onPressed: () => _speak(item.word),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(VocabularyItem item) {
    return _buildCard(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.meaning,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.example,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              item.exampleVi,
              style: const TextStyle(fontSize: 16, color: Colors.pinkAccent),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380, maxHeight: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1),
      ),
      child: child,
    );
  }
}
