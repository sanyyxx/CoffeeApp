import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import 'auth_screen.dart';
import 'my_coupons_screen.dart';
import '../models/coupon.dart';

class ProfileScreen extends StatelessWidget {
  final List<Coupon> availableCoupons = [
    Coupon(
      id: '1',
      name: 'Капучино',
      bonusPrice: 100,
      description: 'Бесплатный капучино',
    ),
    Coupon(
      id: '2',
      name: 'Латте',
      bonusPrice: 100,
      description: 'Бесплатный латте',
    ),
    Coupon(
      id: '3',
      name: 'Американо',
      bonusPrice: 80,
      description: 'Бесплатный американо',
    ),
    Coupon(
      id: '4',
      name: 'Раф',
      bonusPrice: 120,
      description: 'Бесплатный раф',
    ),
    Coupon(
      id: '5',
      name: 'Круассан',
      bonusPrice: 90,
      description: 'Бесплатный круассан',
    ),
    Coupon(
      id: '6',
      name: 'Пончик',
      bonusPrice: 70,
      description: 'Бесплатный пончик',
    ),
    Coupon(
      id: '7',
      name: 'Чизкейк',
      bonusPrice: 100,
      description: 'Бесплатный чизкейк',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Профиль',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isAuthenticated) {
            return AuthScreen();
          }

          return Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              // Загружаем данные пользователя при первом входе
              WidgetsBinding.instance.addPostFrameCallback((_) {
                userProvider.loadUserData();
              });

              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Приветствие
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.brown[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Здравствуйте, ${userProvider.userName}!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Добро пожаловать в Coffee Shop',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Круговая шкала бонусов
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
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
                        children: [
                          Text(
                            'Ваши бонусы',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                            ),
                          ),
                          SizedBox(height: 16),
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: (userProvider.bonusPoints % 100) / 100,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[800]!),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '${userProvider.bonusPoints.toInt()}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown[800],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Мои купоны кнопка
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyCouponsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 0),
                      ),
                      child: Text(
                        'Мои купоны',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Доступные купоны
                    Text(
                      'Купоны для обмена',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 16),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: availableCoupons.length,
                      itemBuilder: (context, index) {
                        final coupon = availableCoupons[index];
                        final canPurchase = userProvider.bonusPoints >= coupon.bonusPrice;

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: canPurchase ? Colors.green : Colors.grey[300]!,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coupon.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[800],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      coupon.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${coupon.bonusPrice} бонусов',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.brown[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: canPurchase ? () => _purchaseCoupon(context, userProvider, coupon) : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canPurchase ? Colors.green : Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Купить',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24),

                    // Кнопка выхода
                    ElevatedButton(
                      onPressed: () {
                        auth.signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 0),
                      ),
                      child: Text(
                        'Выйти',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _purchaseCoupon(BuildContext context, UserProvider userProvider, Coupon coupon) async {
    final success = await userProvider.purchaseCoupon(coupon);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Купон "${coupon.name}" успешно куплен!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Недостаточно бонусов для покупки купона'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}