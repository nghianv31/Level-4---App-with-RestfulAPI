import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': 'p1',
      'title': 'Minimalist Leather Backpack',
      'price': 120.00,
      'description': 'Được chế tác từ da Full Grain cao cấp, balo tối giản này mang lại thiết kế thanh lịch cùng sự bền bỉ đáng tin cậy cho nhu cầu sử dụng hàng ngày.',
      'imageUrl': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
      'rating': 4.8,
      'category': 'PHỤ KIỆN',
      'sku': 'BP-MIN-LTH-01'
    },
    {
      'id': 'p2',
      'title': 'Wireless Noise-Canceling Headphones',
      'price': 299.00,
      'description': 'Trải nghiệm âm thanh đỉnh cao với công nghệ chống ồn chủ động ANC tiên tiến, đệm tai siêu êm ái và thời gian sử dụng pin lên đến 30 giờ liên tục.',
      'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
      'rating': 4.9,
      'category': 'ÂM THANH',
      'sku': 'HP-WRL-ANC-02'
    },
    {
      'id': 'p3',
      'title': 'Mechanical Tactile Keyboard',
      'price': 149.00,
      'description': 'Bàn phím cơ không dây với switch gõ êm, khung nhôm nguyên khối vững chắc và đèn nền đơn sắc dịu mắt mang đến trải nghiệm gõ phím tuyệt vời.',
      'imageUrl': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80',
      'rating': 4.7,
      'category': 'PHỤ KIỆN',
      'sku': 'KB-MCH-TCT-03'
    },
    {
      'id': 'p4',
      'title': 'Premium Leather Watch',
      'price': 189.00,
      'description': 'Chiếc đồng hồ cổ điển tinh tế với mặt kính Sapphire chống trầy xước, bộ máy Quartz chính xác và dây đeo bằng da bê mềm mại, thanh lịch.',
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
      'rating': 4.6,
      'category': 'THỜI TRANG',
      'sku': 'WT-PRM-LTH-04'
    },
    {
      'id': 'p5',
      'title': 'Stainless Steel Thermos Bottle',
      'price': 35.00,
      'description': 'Bình giữ nhiệt bằng thép không gỉ 304 hai lớp, giữ nhiệt độ nóng đến 12 giờ hoặc giữ lạnh lên đến 24 giờ. Thiết kế gọn nhẹ dễ mang theo.',
      'imageUrl': 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&auto=format&fit=crop&q=80',
      'rating': 4.5,
      'category': 'ĐỒ GIA DỤNG',
      'sku': 'BT-STN-STL-05'
    },
    {
      'id': 'p6',
      'title': 'Smart Assistant Speaker',
      'price': 99.00,
      'description': 'Loa thông minh tích hợp trợ lý ảo giọng nói chất lượng cao. Thiết kế vải bọc sang trọng mang lại chất âm 360 độ sống động khắp căn phòng.',
      'imageUrl': 'https://images.unsplash.com/photo-1543512214-318c7553f230?w=600&auto=format&fit=crop&q=80',
      'rating': 4.4,
      'category': 'THIẾT BỊ',
      'sku': 'SP-SMR-AST-06'
    }
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    // Giả lập độ trễ mạng ngắn 800ms
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockProducts.map((json) => ProductModel.fromJson(json)).toList();
  }
}
