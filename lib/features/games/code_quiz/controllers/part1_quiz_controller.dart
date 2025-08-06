import 'package:flutter/material.dart';
import '../../../dashboard/controllers/streak_controller.dart';
import '../../../dashboard/controllers/mission_controller.dart';
import 'package:provider/provider.dart';

class CodeQuizController extends ChangeNotifier {
  int currentIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  int correctCount = 0;
  int hearts = 3;

  final List<Map<String, dynamic>> questions = [
    {
      'code': '''
function calculateSum(a, b) {
    return a + b;
}
const result = calculateSum(5, 3);
console.log("The result is: " + result);
      ''',
      'question': 'Từ "calculate" trong đoạn code có nghĩa là gì?',
      'options': ['Tính toán', 'Kiểm tra', 'Hiển thị', 'Lưu trữ'],
      'correctAnswer': 'Tính toán',
      'explanation': 'Calculate có nghĩa là tính toán, thực hiện phép tính.',
    },
    {
      'code': '''
const user = {
    name: "John",
    age: 25,
    email: "john@example.com"
};
if (user.age >= 18) {
    console.log("User is an adult");
}
        ''',
      'question': 'Từ "adult" trong đoạn code có nghĩa là gì?',
      'options': ['Trẻ em', 'Người lớn', 'Tuổi teen', 'Người già'],
      'correctAnswer': 'Người lớn',
      'explanation': 'Adult có nghĩa là người lớn, người trưởng thành.',
    },
    {
      'code': '''
function validatePassword(password) {
    if (password.length < 8) {
        return false;
    }
    return true;
}
        ''',
      'question': 'Từ "validate" có nghĩa là gì?',
      'options': ['Xác thực', 'Mã hóa', 'Xóa bỏ', 'Tạo mới'],
      'correctAnswer': 'Xác thực',
      'explanation': 'Validate có nghĩa là xác thực, kiểm tra tính hợp lệ.',
    },
    {
      'code': '''
const database = {
    connect: function() {
        console.log("Connected to database");
    },
    disconnect: function() {
        console.log("Disconnected from database");
    }
};
        ''',
      'question': 'Từ "disconnect" có nghĩa là gì?',
      'options': ['Kết nối', 'Ngắt kết nối', 'Khởi tạo', 'Cập nhật'],
      'correctAnswer': 'Ngắt kết nối',
      'explanation': 'Disconnect có nghĩa là ngắt kết nối, tách rời.',
    },
    {
      'code': '''
function processOrder(order) {
    if (order.status === "pending") {
        order.status = "processing";
        console.log("Order is being processed");
    }
}
        ''',
      'question': 'Từ "pending" có nghĩa là gì?',
      'options': ['Đang xử lý', 'Đang chờ', 'Hoàn thành', 'Bị hủy'],
      'correctAnswer': 'Đang chờ',
      'explanation': 'Pending có nghĩa là đang chờ, chưa được xử lý.',
    },
    {
      'code': '''
const apiResponse = await fetch("/api/users");
if (apiResponse.ok) {
    const users = await apiResponse.json();
    renderUserList(users);
}
        ''',
      'question': 'Từ "render" có nghĩa là gì?',
      'options': ['Tải xuống', 'Hiển thị', 'Xóa bỏ', 'Lưu trữ'],
      'correctAnswer': 'Hiển thị',
      'explanation': 'Render có nghĩa là hiển thị, vẽ lên màn hình.',
    },
    {
      'code': '''
function authenticate(username, password) {
    const credentials = {
        username: username,
        password: password
    };
    return verifyCredentials(credentials);
}
        ''',
      'question': 'Từ "credentials" có nghĩa là gì?',
      'options': ['Thông tin đăng nhập', 'Mật khẩu', 'Tên người dùng', 'Token'],
      'correctAnswer': 'Thông tin đăng nhập',
      'explanation': 'Credentials có nghĩa là thông tin đăng nhập, chứng thư.',
    },
    {
      'code': '''
class Repository {
    constructor(name) {
        this.name = name;
        this.initialized = false;
    }
    
    initialize() {
        this.initialized = true;
    }
}
        ''',
      'question': 'Từ "initialize" có nghĩa là gì?',
      'options': ['Khởi tạo', 'Hủy bỏ', 'Cập nhật', 'Kiểm tra'],
      'correctAnswer': 'Khởi tạo',
      'explanation': 'Initialize có nghĩa là khởi tạo, thiết lập ban đầu.',
    },
    {
      'code': '''
const cache = new Map();

function getCachedData(key) {
    if (cache.has(key)) {
        return cache.get(key);
    }
    return null;
}
        ''',
      'question': 'Từ "cache" có nghĩa là gì?',
      'options': ['Bộ nhớ đệm', 'Cơ sở dữ liệu', 'File', 'Biến'],
      'correctAnswer': 'Bộ nhớ đệm',
      'explanation': 'Cache có nghĩa là bộ nhớ đệm, lưu trữ tạm thời.',
    },
    {
      'code': '''
function deployApplication() {
    console.log("Building application...");
    console.log("Running tests...");
    console.log("Deploying to production...");
    console.log("Deployment completed successfully!");
}
        ''',
      'question': 'Từ "deploy" có nghĩa là gì?',
      'options': ['Triển khai', 'Xây dựng', 'Kiểm tra', 'Xóa bỏ'],
      'correctAnswer': 'Triển khai',
      'explanation': 'Deploy có nghĩa là triển khai, đưa ứng dụng lên production.',
    },
  ];

  void restoreHearts() {
    hearts = 3;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    if (!isAnswered) {
      selectedAnswer = answer;
      notifyListeners();
    }
  }

  bool confirmAnswer(BuildContext context) {
    isAnswered = true;
    final isCorrect =
        selectedAnswer == questions[currentIndex]['correctAnswer'];
    if (isCorrect) {
      correctCount++;

      // ✅ Cập nhật nhiệm vụ "trả lời đúng 10 câu"
      context.read<MissionController>().updateMissionProgress(
        context,
        'daily_correct_10',
      );
    }
    notifyListeners();
    return isCorrect;
  }

  void nextQuestion(BuildContext context) {
    if (hearts <= 0) return;
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      selectedAnswer = null;
      isAnswered = false;
      notifyListeners();
    } else {
      _showSummaryDialog(context);
    }
  }

  Future<void> _showSummaryDialog(BuildContext context) async {
    final streakCtrl = Provider.of<StreakController>(context, listen: false);
    await streakCtrl.updateStreak();

    // ✅ Thêm cập nhật nhiệm vụ "hoàn thành 1 bài học" nếu làm hết toàn bộ
    context.read<MissionController>().updateMissionProgress(
      context,
      'daily_complete_lesson',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Hoàn thành"),
        content: Text(
          "Bạn đã trả lời đúng $correctCount / ${questions.length} câu.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
