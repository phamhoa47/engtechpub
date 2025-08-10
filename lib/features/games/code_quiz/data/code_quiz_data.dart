final List<Map<String, dynamic>> quizQuestions = [
  // ===== CODE QUIZ 1 =====
  {
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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
    'category': 'code_quiz_1',
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

  // ===== CODE QUIZ 2 =====
  {
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
    'explanation': 'Unauthorized có nghĩa là không được phép, chưa được ủy quyền.',
  },
  {
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
    'explanation': 'Migrate có nghĩa là di chuyển, chuyển đổi cấu trúc dữ liệu.',
  },
  {
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
    'category': 'code_quiz_2',
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
  // ===== CODE QUIZ 3 (Python) =====
{
  'category': 'code_quiz_3',
  'code': '''
def authenticate(username, password):
    if username == "admin" and password == "1234":
        return True
    return False
''',
  'question': 'Từ "authenticate" có nghĩa là gì?',
  'options': ['Xác thực', 'Mã hóa', 'Sao lưu', 'Tạo mới'],
  'correctAnswer': 'Xác thực',
  'explanation': 'Authenticate nghĩa là xác thực người dùng khi đăng nhập.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def compress_data(data):
    import zlib
    return zlib.compress(data.encode())
''',
  'question': 'Từ "compress" có nghĩa là gì?',
  'options': ['Nén', 'Giải mã', 'Tách', 'Xóa'],
  'correctAnswer': 'Nén',
  'explanation': 'Compress nghĩa là nén dữ liệu để giảm kích thước.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def backup_file(filename):
    import shutil
    shutil.copy(filename, filename + ".bak")
''',
  'question': 'Từ "backup" có nghĩa là gì?',
  'options': ['Sao lưu', 'Khôi phục', 'Ghi đè', 'Cập nhật'],
  'correctAnswer': 'Sao lưu',
  'explanation': 'Backup là hành động sao lưu dữ liệu để tránh mất mát.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def encrypt(text, key):
    return "".join(chr(ord(c) + key) for c in text)
''',
  'question': 'Từ "encrypt" có nghĩa là gì?',
  'options': ['Mã hóa', 'Giải nén', 'Hiển thị', 'Phân tích'],
  'correctAnswer': 'Mã hóa',
  'explanation': 'Encrypt là quá trình chuyển đổi dữ liệu thành dạng bảo mật.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def parse_json(json_str):
    import json
    return json.loads(json_str)
''',
  'question': 'Từ "parse" có nghĩa là gì?',
  'options': ['Phân tích cú pháp', 'Tải xuống', 'Mã hóa', 'Nén'],
  'correctAnswer': 'Phân tích cú pháp',
  'explanation': 'Parse trong lập trình có nghĩa là phân tích và trích xuất dữ liệu từ chuỗi.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def rollback():
    print("Reverting changes...")
''',
  'question': 'Từ "rollback" có nghĩa là gì?',
  'options': ['Hoàn tác', 'Lưu lại', 'Xác nhận', 'Chia sẻ'],
  'correctAnswer': 'Hoàn tác',
  'explanation': 'Rollback có nghĩa là quay về trạng thái trước đó.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def deploy_app():
    print("Deploying application to server...")
''',
  'question': 'Từ "deploy" có nghĩa là gì?',
  'options': ['Triển khai', 'Phát triển', 'Sửa lỗi', 'Nén'],
  'correctAnswer': 'Triển khai',
  'explanation': 'Deploy là đưa ứng dụng lên môi trường hoạt động thực tế.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def synchronize_data():
    print("Syncing local data with server...")
''',
  'question': 'Từ "synchronize" có nghĩa là gì?',
  'options': ['Đồng bộ hóa', 'Giải mã', 'Xóa', 'Khởi tạo'],
  'correctAnswer': 'Đồng bộ hóa',
  'explanation': 'Synchronize nghĩa là làm cho dữ liệu hai bên giống nhau.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def validate_email(email):
    return "@" in email and "." in email
''',
  'question': 'Từ "validate" có nghĩa là gì?',
  'options': ['Xác minh', 'Giải mã', 'Tạo mới', 'Xóa'],
  'correctAnswer': 'Xác minh',
  'explanation': 'Validate là kiểm tra xem dữ liệu có hợp lệ hay không.',
},
{
  'category': 'code_quiz_3',
  'code': '''
def retry_connection():
    for i in range(3):
        print("Retrying...")
''',
  'question': 'Từ "retry" có nghĩa là gì?',
  'options': ['Thử lại', 'Bỏ qua', 'Thành công', 'Xóa'],
  'correctAnswer': 'Thử lại',
  'explanation': 'Retry nghĩa là thử lại thao tác sau khi thất bại.',
},

];
