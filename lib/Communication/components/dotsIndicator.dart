import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../components/notificationCard.dart';

class DotsIndicator extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageSelected;

  const DotsIndicator({required this.currentPage, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () => onPageSelected(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index ? Colors.blue : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}