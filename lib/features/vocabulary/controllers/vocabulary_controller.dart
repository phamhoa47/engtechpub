import 'package:flutter/material.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class VocabularyController extends ChangeNotifier {
  String searchQuery = '';

  final List<VocabularyItem> items = [
    // ==== AI ====
    VocabularyItem(
      word: "Algorithm",
      pronunciation: "/ˈæl.ɡə.rɪ.ðəm/",
      meaning: "Thuật toán",
      example:
          "An algorithm is a step-by-step procedure for solving a problem.",
      exampleVi: "Thuật toán là một quy trình từng bước để giải quyết vấn đề.",
      icon: Icons.functions,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Neural Network",
      pronunciation: "/ˈnjʊə.rəl ˈnet.wɜːk/",
      meaning: "Mạng nơ-ron",
      example: "Neural networks are inspired by the human brain.",
      exampleVi: "Mạng nơ-ron được lấy cảm hứng từ bộ não con người.",
      icon: Icons.memory,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Machine Learning",
      pronunciation: "/məˈʃiːn ˈlɜː.nɪŋ/",
      meaning: "Học máy",
      example: "Machine learning allows systems to learn from data.",
      exampleVi: "Học máy cho phép hệ thống học từ dữ liệu.",
      icon: Icons.computer,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Deep Learning",
      pronunciation: "/diːp ˈlɜː.nɪŋ/",
      meaning: "Học sâu",
      example: "Deep learning uses neural networks with many layers.",
      exampleVi: "Học sâu sử dụng mạng nơ-ron với nhiều tầng.",
      icon: Icons.layers,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Natural Language Processing",
      pronunciation: "/ˈnætʃ.ər.əl ˈlæŋ.ɡwɪdʒ ˈprəʊ.ses.ɪŋ/",
      meaning: "Xử lý ngôn ngữ tự nhiên",
      example: "NLP is used in chatbots and translation systems.",
      exampleVi:
          "Xử lý ngôn ngữ tự nhiên được sử dụng trong chatbot và hệ thống dịch thuật.",
      icon: Icons.translate,
      topic: "AI",
    ),

    // ==== Cybersecurity ====
    VocabularyItem(
      word: "Firewall",
      pronunciation: "/ˈfaɪər.wɔːl/",
      meaning: "Tường lửa",
      example: "A firewall protects the network from attacks.",
      exampleVi: "Tường lửa bảo vệ mạng khỏi các cuộc tấn công.",
      icon: Icons.shield,
      topic: "Cybersecurity",
    ),
    VocabularyItem(
      word: "Encryption",
      pronunciation: "/ɪnˈkrɪp.ʃən/",
      meaning: "Mã hóa",
      example: "Encryption keeps data secure.",
      exampleVi: "Mã hóa giữ dữ liệu an toàn.",
      icon: Icons.lock,
      topic: "Cybersecurity",
    ),
    VocabularyItem(
      word: "Malware",
      pronunciation: "/ˈmæl.weər/",
      meaning: "Phần mềm độc hại",
      example: "Malware can damage or steal data.",
      exampleVi: "Phần mềm độc hại có thể phá hoại hoặc đánh cắp dữ liệu.",
      icon: Icons.bug_report,
      topic: "Cybersecurity",
    ),
    VocabularyItem(
      word: "Phishing",
      pronunciation: "/ˈfɪʃ.ɪŋ/",
      meaning: "Lừa đảo trực tuyến",
      example: "Phishing emails trick users into revealing passwords.",
      exampleVi: "Email lừa đảo đánh lừa người dùng tiết lộ mật khẩu.",
      icon: Icons.email,
      topic: "Cybersecurity",
    ),
    VocabularyItem(
      word: "Two-Factor Authentication",
      pronunciation: "/tuː ˈfæk.tər ɔːˌθen.tɪˈkeɪ.ʃən/",
      meaning: "Xác thực hai yếu tố",
      example: "Two-factor authentication adds an extra layer of security.",
      exampleVi: "Xác thực hai yếu tố bổ sung một lớp bảo mật bổ sung.",
      icon: Icons.verified_user,
      topic: "Cybersecurity",
    ),

    // ==== DevOps ====
    VocabularyItem(
      word: "Continuous Integration",
      pronunciation: "/kənˈtɪn.ju.əs ˌɪn.tɪˈɡreɪ.ʃən/",
      meaning: "Tích hợp liên tục",
      example: "CI helps detect problems early by integrating code often.",
      exampleVi:
          "CI giúp phát hiện lỗi sớm bằng cách tích hợp code thường xuyên.",
      icon: Icons.sync,
      topic: "DevOps",
    ),
    VocabularyItem(
      word: "Continuous Deployment",
      pronunciation: "/kənˈtɪn.ju.əs dɪˈplɔɪ.mənt/",
      meaning: "Triển khai liên tục",
      example: "CD automatically deploys code after passing tests.",
      exampleVi: "CD tự động triển khai code sau khi vượt qua kiểm thử.",
      icon: Icons.cloud_upload,
      topic: "DevOps",
    ),
    VocabularyItem(
      word: "Container",
      pronunciation: "/kənˈteɪ.nər/",
      meaning: "Container",
      example: "Containers package applications with their dependencies.",
      exampleVi: "Container đóng gói ứng dụng cùng các phụ thuộc.",
      icon: Icons.all_inbox,
      topic: "DevOps",
    ),
    VocabularyItem(
      word: "Kubernetes",
      pronunciation: "/ˌkuː.bəˈnɛ.tiːz/",
      meaning: "Hệ thống quản lý container Kubernetes",
      example: "Kubernetes orchestrates containerized applications.",
      exampleVi: "Kubernetes điều phối các ứng dụng chạy trong container.",
      icon: Icons.dashboard,
      topic: "DevOps",
    ),

    // ==== Frontend ====
    VocabularyItem(
      word: "Responsive Design",
      pronunciation: "/rɪˈspɒn.sɪv dɪˈzaɪn/",
      meaning: "Thiết kế đáp ứng",
      example: "Responsive design adapts to different screen sizes.",
      exampleVi:
          "Thiết kế đáp ứng thích nghi với các kích thước màn hình khác nhau.",
      icon: Icons.phone_android,
      topic: "Frontend",
    ),
    VocabularyItem(
      word: "Framework",
      pronunciation: "/ˈfreɪm.wɜːk/",
      meaning: "Bộ khung",
      example: "React is a popular JavaScript framework for building UIs.",
      exampleVi:
          "React là một framework JavaScript phổ biến để xây dựng giao diện người dùng.",
      icon: Icons.web,
      topic: "Frontend",
    ),
    VocabularyItem(
      word: "Component",
      pronunciation: "/kəmˈpəʊ.nənt/",
      meaning: "Thành phần",
      example: "Components are reusable pieces of UI.",
      exampleVi: "Component là những phần giao diện có thể tái sử dụng.",
      icon: Icons.widgets,
      topic: "Frontend",
    ),

    // ==== Backend ====
    VocabularyItem(
      word: "API",
      pronunciation: "/ˌeɪ.piːˈaɪ/",
      meaning: "Giao diện lập trình ứng dụng",
      example: "An API allows different software systems to communicate.",
      exampleVi: "API cho phép các hệ thống phần mềm khác nhau giao tiếp.",
      icon: Icons.api,
      topic: "Backend",
    ),
    VocabularyItem(
      word: "Database",
      pronunciation: "/ˈdeɪ.tə.beɪs/",
      meaning: "Cơ sở dữ liệu",
      example: "A database stores and organizes data.",
      exampleVi: "Cơ sở dữ liệu lưu trữ và tổ chức dữ liệu.",
      icon: Icons.storage,
      topic: "Backend",
    ),
    VocabularyItem(
      word: "Authentication",
      pronunciation: "/ɔːˌθen.tɪˈkeɪ.ʃən/",
      meaning: "Xác thực",
      example: "Authentication verifies a user's identity.",
      exampleVi: "Xác thực kiểm tra danh tính của người dùng.",
      icon: Icons.lock_open,
      topic: "Backend",
    ),

    // ==== Data ====
    VocabularyItem(
      word: "Data Mining",
      pronunciation: "/ˈdeɪ.tə ˌmaɪ.nɪŋ/",
      meaning: "Khai phá dữ liệu",
      example: "Data mining discovers patterns in large datasets.",
      exampleVi: "Khai phá dữ liệu phát hiện các mẫu trong tập dữ liệu lớn.",
      icon: Icons.search,
      topic: "Data",
    ),
    VocabularyItem(
      word: "Data Visualization",
      pronunciation: "/ˈdeɪ.tə ˌvɪʒ.u.əl.aɪˈzeɪ.ʃən/",
      meaning: "Trực quan hóa dữ liệu",
      example: "Data visualization makes information easier to understand.",
      exampleVi: "Trực quan hóa dữ liệu giúp thông tin dễ hiểu hơn.",
      icon: Icons.bar_chart,
      topic: "Data",
    ),
    VocabularyItem(
      word: "Big Data",
      pronunciation: "/ˌbɪɡ ˈdeɪ.tə/",
      meaning: "Dữ liệu lớn",
      example: "Big data technologies handle massive amounts of data.",
      exampleVi: "Công nghệ dữ liệu lớn xử lý khối lượng dữ liệu khổng lồ.",
      icon: Icons.storage_rounded,
      topic: "Data",
    ),
    VocabularyItem(
      word: "Supervised Learning",
      pronunciation: "/ˈsuː.pə.vaɪzd ˈlɜː.nɪŋ/",
      meaning: "Học có giám sát",
      example: "Supervised learning uses labeled data to train models.",
      exampleVi:
          "Học có giám sát sử dụng dữ liệu đã gán nhãn để huấn luyện mô hình.",
      icon: Icons.school,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Unsupervised Learning",
      pronunciation: "/ˌʌnˈsuː.pə.vaɪzd ˈlɜː.nɪŋ/",
      meaning: "Học không giám sát",
      example: "Unsupervised learning finds patterns in unlabeled data.",
      exampleVi: "Học không giám sát tìm các mẫu trong dữ liệu chưa gán nhãn.",
      icon: Icons.scatter_plot,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Reinforcement Learning",
      pronunciation: "/ˌriː.ɪnˈfɔːs.mənt ˈlɜː.nɪŋ/",
      meaning: "Học tăng cường",
      example: "Reinforcement learning learns through trial and error.",
      exampleVi: "Học tăng cường học qua thử và sai.",
      icon: Icons.videogame_asset,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Model",
      pronunciation: "/ˈmɒd.əl/",
      meaning: "Mô hình",
      example: "The AI model predicts whether an email is spam.",
      exampleVi:
          "Mô hình AI dự đoán liệu một email có phải là thư rác hay không.",
      icon: Icons.model_training,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Training Data",
      pronunciation: "/ˈtreɪ.nɪŋ ˈdeɪ.tə/",
      meaning: "Dữ liệu huấn luyện",
      example: "Training data is essential for building accurate models.",
      exampleVi:
          "Dữ liệu huấn luyện rất quan trọng để xây dựng các mô hình chính xác.",
      icon: Icons.dataset,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Bias",
      pronunciation: "/ˈbaɪ.əs/",
      meaning: "Thiên lệch",
      example: "Bias in AI can lead to unfair decisions.",
      exampleVi:
          "Thiên lệch trong AI có thể dẫn đến các quyết định không công bằng.",
      icon: Icons.balance,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Overfitting",
      pronunciation: "/ˌəʊ.vəˈfɪt.ɪŋ/",
      meaning: "Quá khớp",
      example:
          "Overfitting happens when a model learns noise instead of patterns.",
      exampleVi:
          "Quá khớp xảy ra khi mô hình học cả nhiễu thay vì chỉ học mẫu.",
      icon: Icons.warning,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Classification",
      pronunciation: "/ˌklæs.ɪ.fɪˈkeɪ.ʃən/",
      meaning: "Phân loại",
      example: "Image classification assigns labels to pictures.",
      exampleVi: "Phân loại hình ảnh gán nhãn cho các bức ảnh.",
      icon: Icons.label,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Clustering",
      pronunciation: "/ˈklʌs.tər.ɪŋ/",
      meaning: "Phân cụm",
      example: "Clustering groups similar data points together.",
      exampleVi: "Phân cụm nhóm các điểm dữ liệu tương tự lại với nhau.",
      icon: Icons.groups,
      topic: "AI",
    ),
    VocabularyItem(
      word: "Inference",
      pronunciation: "/ˈɪn.fər.əns/",
      meaning: "Suy luận",
      example:
          "Inference is the process of making predictions using a trained model.",
      exampleVi:
          "Suy luận là quá trình đưa ra dự đoán bằng mô hình đã huấn luyện.",
      icon: Icons.insights,
      topic: "AI",
    ),
  ];

  // 🔍 Cập nhật từ khóa tìm kiếm
  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  // 🔍 Lấy kết quả tìm kiếm
  List<VocabularyItem> get filteredItems {
    if (searchQuery.isEmpty) return [];
    return items.where((item) {
      return item.word.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.meaning.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // 📌 Lấy từ vựng theo chủ đề
  List<VocabularyItem> getByTopic(String topic) {
    return items.where((item) => item.topic == topic).toList();
  }

  // ❤️ Đổi trạng thái yêu thích
  void toggleFavorite(VocabularyItem item) {
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }

  // 📚 Đổi trạng thái đã học
  void toggleLearned(VocabularyItem item) {
    item.isLearned = !item.isLearned;
    notifyListeners();
  }
}
