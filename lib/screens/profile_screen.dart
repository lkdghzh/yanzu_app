import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 用户信息卡片
          _buildUserInfoCard(),
          const SizedBox(height: 10),
          // 功能列表
          _buildFunctionList(),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.blue,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '点击登录',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '登录后体验更多功能',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionList() {
    return Column(
      children: [
        _buildFunctionGroup('房源管理', [
          _buildFunctionItem(Icons.home, '我的房源'),
          _buildFunctionItem(Icons.add_circle_outline, '发布房源'),
          _buildFunctionItem(Icons.favorite_border, '我的收藏'),
        ]),
        const SizedBox(height: 10),
        _buildFunctionGroup('账户管理', [
          _buildFunctionItem(Icons.person_outline, '个人资料'),
          _buildFunctionItem(Icons.security, '账户安全'),
          _buildFunctionItem(Icons.settings, '设置'),
        ]),
      ],
    );
  }

  Widget _buildFunctionGroup(String title, List<Widget> items) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _buildFunctionItem(IconData icon, String title) {
    return InkWell(
      onTap: () {
        // TODO: 实现对应功能
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
} 