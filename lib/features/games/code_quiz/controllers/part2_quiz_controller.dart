import 'package:flutter/material.dart';
import '../../../dashboard/controllers/streak_controller.dart';
import 'package:provider/provider.dart';

class CodeQuiz2Controller extends ChangeNotifier {
  int currentIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  int correctCount = 0;
  int hearts = 3;

  final List<Map<String, dynamic>> questions = [
    {
      'code': '''
class DatabaseConnection {
    async establish() {
        try {
            await this.authenticate();
            this.isConnected = true;
        } catch (error) {
            throw new ConnectionError("Failed to establish connection");
        }
    }
}
        ''',
      'question': 'Từ "establish" có nghĩa là gì?',
      'options': ['Thiết lập', 'Hủy bỏ', 'Kiểm tra', 'Cập nhật'],
      'correctAnswer': 'Thiết lập',
      'explanation': 'Establish có nghĩa là thiết lập, tạo ra kết nối.',
    },
    {
      'code': '''
const middleware = (req, res, next) => {
    const token = req.headers.authorization;
    if (!token) {
        return res.status(401).json({
            error: "Unauthorized access"
        });
    }
    next();
};
        ''',
      'question': 'Từ "unauthorized" có nghĩa là gì?',
      'options': ['Được phép', 'Không được phép', 'Đã xác thực', 'Admin'],
      'correctAnswer': 'Không được phép',
      'explanation':
          'Unauthorized có nghĩa là không được phép, chưa được ủy quyền.',
    },
    {
      'code': '''
function optimizeQuery(query) {
    const optimized = query
        .select("id", "name", "email")
        .where("active", true)
        .limit(100)
        .orderBy("created_at", "desc");
    return optimized;
}
        ''',
      'question': 'Từ "optimize" có nghĩa là gì?',
      'options': ['Tối ưu hóa', 'Thực thi', 'Hủy bỏ', 'Tạo mới'],
      'correctAnswer': 'Tối ưu hóa',
      'explanation': 'Optimize có nghĩa là tối ưu hóa, cải thiện hiệu suất.',
    },
    {
      'code': '''
class EventEmitter {
    constructor() {
        this.listeners = new Map();
    }
    
    subscribe(event, callback) {
        if (!this.listeners.has(event)) {
            this.listeners.set(event, []);
        }
        this.listeners.get(event).push(callback);
    }
}
        ''',
      'question': 'Từ "subscribe" có nghĩa là gì?',
      'options': ['Đăng ký', 'Hủy đăng ký', 'Phát sự kiện', 'Xóa'],
      'correctAnswer': 'Đăng ký',
      'explanation': 'Subscribe có nghĩa là đăng ký, theo dõi sự kiện.',
    },
    {
      'code': '''
async function migrateDatabase() {
    const migrations = await loadMigrations();
    for (const migration of migrations) {
        console.log("Executing migration: " + migration.name);
        await migration.execute();
    }
}
        ''',
      'question': 'Từ "migrate" có nghĩa là gì?',
      'options': ['Di chuyển', 'Sao lưu', 'Xóa', 'Tạo'],
      'correctAnswer': 'Di chuyển',
      'explanation':
          'Migrate có nghĩa là di chuyển, chuyển đổi cấu trúc dữ liệu.',
    },
    {
      'code': '''
function encryptSensitiveData(data, key) {
    const encrypted = crypto
        .createCipher("aes-256-cbc", key)
        .update(data, "utf8", "hex");
    return encrypted;
}
        ''',
      'question': 'Từ "encrypt" có nghĩa là gì?',
      'options': ['Mã hóa', 'Giải mã', 'Nén', 'Giải nén'],
      'correctAnswer': 'Mã hóa',
      'explanation': 'Encrypt có nghĩa là mã hóa, bảo vệ dữ liệu.',
    },
    {
      'code': '''
class LoadBalancer {
    constructor(servers) {
        this.servers = servers;
        this.currentIndex = 0;
    }
    
    distribute(request) {
        const server = this.servers[this.currentIndex];
        this.currentIndex = (this.currentIndex + 1) % this.servers.length;
        return server.handle(request);
    }
}
        ''',
      'question': 'Từ "distribute" có nghĩa là gì?',
      'options': ['Phân phối', 'Thu thập', 'Lưu trữ', 'Xử lý'],
      'correctAnswer': 'Phân phối',
      'explanation': 'Distribute có nghĩa là phân phối, chia tải.',
    },
    {
      'code': '''
function debounce(func, delay) {
    let timeoutId;
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => {
            func.apply(this, args);
        }, delay);
    };
}
        ''',
      'question': 'Từ "debounce" có nghĩa là gì?',
      'options': ['Chống rung', 'Gia tốc', 'Lặp lại', 'Dừng'],
      'correctAnswer': 'Chống rung',
      'explanation': 'Debounce có nghĩa là chống rung, trì hoãn thực thi.',
    },
    {
      'code': '''
async function synchronizeData() {
    const localData = await getLocalData();
    const remoteData = await fetchRemoteData();
    
    const conflicts = detectConflicts(localData, remoteData);
    if (conflicts.length > 0) {
        await resolveConflicts(conflicts);
    }
}
        ''',
      'question': 'Từ "synchronize" có nghĩa là gì?',
      'options': ['Đồng bộ hóa', 'Sao chép', 'Xóa', 'Tạo'],
      'correctAnswer': 'Đồng bộ hóa',
      'explanation': 'Synchronize có nghĩa là đồng bộ hóa dữ liệu.',
    },
    {
      'code': '''
class Microservice {
    constructor(name, port) {
        this.name = name;
        this.port = port;
        this.dependencies = [];
    }
    
    async bootstrap() {
        await this.initializeDatabase();
        await this.startServer();
        console.log(this.name + " service is ready");
    }
}
        ''',
      'question': 'Từ "bootstrap" có nghĩa là gì?',
      'options': ['Khởi động', 'Tắt', 'Cấu hình', 'Kiểm tra'],
      'correctAnswer': 'Khởi động',
      'explanation': 'Bootstrap có nghĩa là khởi động, thiết lập hệ thống.',
    },
  ];

  // Chọn câu trả lời
  void selectAnswer(String answer) {
    if (!isAnswered) {
      selectedAnswer = answer;
      notifyListeners();
    }
  }

  // Xác nhận câu trả lời và kiểm tra đúng/sai
  bool confirmAnswer() {
    isAnswered = true;
    final isCorrect =
        selectedAnswer == questions[currentIndex]['correctAnswer'];
    if (isCorrect) correctCount++;
    notifyListeners();
    return isCorrect;
  }

  // Qua câu tiếp theo hoặc hiện tổng kết nếu hết
  void nextQuestion(BuildContext context) {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      selectedAnswer = null;
      isAnswered = false;
      notifyListeners();
    } else {
      _showSummaryDialog(context);
    }
  }

  // Hiện hộp thoại tổng kết khi hoàn thành bài
  Future<void> _showSummaryDialog(BuildContext context) async {
    final streakCtrl = Provider.of<StreakController>(context, listen: false);
    await streakCtrl.updateStreak();

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

  // Reset lại toàn bộ quiz (nếu muốn chơi lại từ đầu)
  void resetQuiz() {
    currentIndex = 0;
    correctCount = 0;
    selectedAnswer = null;
    isAnswered = false;
    notifyListeners();
  }
}
