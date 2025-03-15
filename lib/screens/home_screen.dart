import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('租房'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 搜索栏
          Container(
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
          // 房源列表
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 这里替换为实际的房源数量
              itemBuilder: (context, index) {
                return _buildHouseItem();
              },
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