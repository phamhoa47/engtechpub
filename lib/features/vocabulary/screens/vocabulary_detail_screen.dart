import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VocabularyDetailScreen extends StatefulWidget {
  final String word;
  final String phonetic;
  final String meaning;
  final String example;
  final String exampleVi;
  final String imageUrl;
  final bool showFull;

  const VocabularyDetailScreen({
    super.key,
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.example,
    required this.exampleVi,
    required this.imageUrl,
    this.showFull = false,
  });

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  late bool _showBack;
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _showBack = widget.showFull;
  }

  void _toggleCard() {
    setState(() {
      _showBack = !_showBack;
    });
  }

  void _speak() async {
    await tts.setLanguage("en-US");
    await tts.speak(widget.word);
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, height: 150);
    } else {
      return Image.asset(imageUrl, height: 150);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Flashcards"),
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onDoubleTap: _toggleCard,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                      animation: rotateAnim,
                      child: child,
                      builder: (context, child) {
                        final isBack = (child?.key == const ValueKey('back'));
                        final angle = isBack ? pi - rotateAnim.value : rotateAnim.value;
                        return Transform(
                          transform: Matrix4.rotationY(angle),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                    );
                  },
                  switchInCurve: Curves.easeInOut,
                  layoutBuilder: (currentChild, previousChildren) =>
                      Stack(children: [if (currentChild != null) currentChild, ...previousChildren]),
                  child: _showBack
                      ? _buildBackCard(key: const ValueKey('back'))
                      : _buildFrontCard(key: const ValueKey('front')),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () {}, // TODO: Previous
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                ),
                OutlinedButton.icon(
                  onPressed: () {}, // TODO: Next
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard({required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.word, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(widget.phonetic, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey)),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, size: 30, color: Colors.deepPurple),
            onPressed: _speak,
          ),
          const SizedBox(height: 12),
          if (widget.imageUrl.isNotEmpty) _buildImage(widget.imageUrl),
        ],
      ),
    );
  }

  Widget _buildBackCard({required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("📖 Nghĩa:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(widget.meaning, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          const Text("💬 Ví dụ:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(widget.example, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 6),
          Text("→ ${widget.exampleVi}", style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.deepPurpleAccent),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    );
  }
}
