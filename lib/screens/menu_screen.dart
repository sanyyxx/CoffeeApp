import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import 'item_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MenuItem> _drinks = [
    MenuItem(
      id: '1',
      name: 'Капучино',
      description: 'Классический итальянский кофе с нежной молочной пенкой',
      composition: 'Эспрессо, молоко, молочная пена',
      price: 1000,
      imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=300',
      category: 'drinks',
    ),
    MenuItem(
      id: '2',
      name: 'Латте',
      description: 'Нежный кофе с большим количеством молока',
      composition: 'Эспрессо, молоко, небольшое количество пены',
      price: 1000,
      imageUrl: 'https://images.unsplash.com/photo-1561882468-9110e03e0f78?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      category: 'drinks',
    ),
    MenuItem(
      id: '3',
      name: 'Американо',
      description: 'Классический черный кофе',
      composition: 'Эспрессо, горячая вода',
      price: 800,
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      category: 'drinks',
    ),
    MenuItem(
      id: '4',
      name: 'Раф',
      description: 'Кофе с ванильным сиропом и взбитыми сливками',
      composition: 'Эспрессо, сливки, ванильный сироп',
      price: 1200,
      imageUrl: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=300',
      category: 'drinks',
    ),
  ];

  final List<MenuItem> _desserts = [
    MenuItem(
      id: '5',
      name: 'Круассан',
      description: 'Свежий французский круассан с хрустящей корочкой',
      composition: 'Мука, масло, дрожжи, соль',
      price: 900,
      imageUrl: 'https://images.unsplash.com/photo-1691480162735-9b91238080f6?q=80&w=1160&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      category: 'desserts',
    ),
    MenuItem(
      id: '6',
      name: 'Пончик',
      description: 'Сладкий пончик с глазурью',
      composition: 'Мука, сахар, яйца, глазурь',
      price: 700,
      imageUrl: 'https://images.unsplash.com/photo-1562945431-ce2b63d5a7fe?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      category: 'desserts',
    ),
    MenuItem(
      id: '7',
      name: 'Чизкейк',
      description: 'Нежный чизкейк с ягодами',
      composition: 'Творожный сыр, печенье, ягоды',
      price: 1000,
      imageUrl: 'https://images.unsplash.com/photo-1524351199678-941a58a3df50?w=300',
      category: 'desserts',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Меню',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.brown[800],
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.brown[800],
          tabs: [
            Tab(text: 'Напитки'),
            Tab(text: 'Десерты'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMenuGrid(_drinks),
          _buildMenuGrid(_desserts),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(List<MenuItem> items) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildMenuCard(items[index]);
        },
      ),
    );
  }

  Widget _buildMenuCard(MenuItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${item.price.toInt()} ₸',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[600],
                    ),
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