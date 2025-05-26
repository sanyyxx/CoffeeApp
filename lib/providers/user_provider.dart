import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/coupon.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = '';
  double _bonusPoints = 0;
  List<Coupon> _purchasedCoupons = [];

  String get userName => _userName;
  double get bonusPoints => _bonusPoints;
  List<Coupon> get purchasedCoupons => _purchasedCoupons;

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final userData = await userDoc.get();

      if (!userData.exists) {
        // 🔹 Документ не найден — создаём нового пользователя
        await userDoc.set({
          'name': user.displayName ?? 'Новый пользователь',
          'bonusPoints': 0,
        });
        _userName = user.displayName ?? 'Новый пользователь';
        _bonusPoints = 0;
      } else {
        _userName = userData.data()?['name'] ?? '';
        _bonusPoints = userData.data()?['bonusPoints']?.toDouble() ?? 0;
      }

      notifyListeners();
      await loadPurchasedCoupons();
    }
  }

  Future<void> addBonusPoints(double points) async {
    final user = _auth.currentUser;
    if (user != null) {
      _bonusPoints += points;
      await _firestore.collection('users').doc(user.uid).update({
        'bonusPoints': _bonusPoints,
      });
      notifyListeners();
    }
  }

  Future<bool> purchaseCoupon(Coupon coupon) async {
    if (_bonusPoints >= coupon.bonusPrice) {
      final user = _auth.currentUser;
      if (user != null) {
        _bonusPoints -= coupon.bonusPrice;
        await _firestore.collection('users').doc(user.uid).update({
          'bonusPoints': _bonusPoints,
        });

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('coupons')
            .add(coupon.toMap());

        _purchasedCoupons.add(coupon);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> loadPurchasedCoupons() async {
    final user = _auth.currentUser;
    if (user != null) {
      final couponsQuery = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coupons')
          .get();

      _purchasedCoupons = couponsQuery.docs
          .map((doc) => Coupon.fromMap(doc.data()))
          .toList();
      notifyListeners();
    }
  }
}