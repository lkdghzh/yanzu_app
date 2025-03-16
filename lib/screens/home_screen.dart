import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'dart:math';
import '../utils/route_handler.dart';
import '../services/navigation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 轮播图数据
  final List<String> bannerImages = [
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
    'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
  ];

  // 功能入口数据
  final List<Map<String, dynamic>> features = [
    {
      'title': '生活缴费',
      'icon': Icons.payment,
      'color': Colors.blue,
      'urls': [
        'yanzu://webview?url=https://example.com/payment&title=生活缴费',
        'yanzu://webview?url=https://pay.example.com&title=生活缴费'
      ],
    },
    {
      'title': '房屋维修',
      'icon': Icons.build,
      'color': Colors.orange,
      'urls': [
        'yanzu://webview?url=https://example.com/repair&title=房屋维修',
        'yanzu://webview?url=https://fix.example.com&title=房屋维修'
      ],
    },
    {
      'title': '周边配套',
      'icon': Icons.location_on,
      'color': Colors.green,
      'urls': [
        'yanzu://webview?url=https://example.com/nearby&title=周边配套',
        'yanzu://webview?url=https://map.example.com&title=周边配套'
      ],
    },
    {
      'title': '租房攻略',
      'icon': Icons.article,
      'color': Colors.purple,
      'urls': [
        'yanzu://webview?url=https://example.com/guide&title=租房攻略',
        'yanzu://webview?url=https://blog.example.com&title=租房攻略'
      ],
    },
  ];

  String _getRandomUrl(List<String> urls) {
    final random = Random();
    return urls[random.nextInt(urls.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            title: const Text('租房'),
            floating: true,
            // pinned: true,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '搜索房源',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 主要内容
          SliverToBoxAdapter(
            child: Column(
              children: [
                // 轮播图
                Container(
                  height: 180,
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              bannerImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Text(
                              '精选房源 ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: bannerImages.length,
                    pagination: SwiperPagination(
                      margin: const EdgeInsets.only(bottom: 45),
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.white,
                        color: Colors.white.withOpacity(0.5),
                        size: 6.0,
                        activeSize: 7.0,
                        space: 4.0,
                      ),
                    ),
                    autoplay: true,
                    autoplayDelay: 4000,
                    duration: 500,
                  ),
                ),
                // 功能入口
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '常用功能',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          final feature = features[index];
                          return InkWell(
                            onTap: () {
                              NavigationService.navigateTo(
                                  _getRandomUrl(feature['urls']));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: feature['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    feature['icon'],
                                    color: feature['color'],
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  feature['title'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // 筛选条件
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterButton('区域'),
                      _buildFilterButton('租金'),
                      _buildFilterButton('户型'),
                      _buildFilterButton('更多'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 房源列表
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildHouseItem(),
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return TextButton(
      onPressed: () {
        // TODO: 实现筛选功能
      },
      child: Row(
        children: [
          Text(text),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Widget _buildHouseItem() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 房源图片
            Container(
              width: 120,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.home)),
            ),
            const SizedBox(width: 12),
            // 房源信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '整租·两室一厅·南北通透',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '80㎡ | 南北 | 精装修',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '¥3500/月',
                        style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '浦东新区',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
