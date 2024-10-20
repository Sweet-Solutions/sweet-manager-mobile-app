import 'package:flutter/material.dart';
import 'package:sweetmanager/Commerce/views/checkout_subscription.dart';
import 'package:sweetmanager/Commerce/widgets/plan_card.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class SubscriptionPlansView extends StatelessWidget{
  

  const SubscriptionPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(role: '', childScreen: getContentView(context));
  }

  Widget getContentView(BuildContext context)
  {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back_login.png'), // Replace with your background image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Centered Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select a plan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Basic Plan Card
                    PlanCard(
                      color: Colors.brown[200]!,
                      planName: 'Basic',
                      price: '29.50',
                      features: const [
                        'Maximum 5 Workers',
                        'Maximum 1 Admins',
                        'Maximum 50 Rooms',
                        '5GB Storage',
                      ],
                      buttonColor: Colors.black,
                      behavior: () {
                        // Connection to checkout subscription dart view
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutSubscription(cardIdentifier: 1,)));
                      },
                      textButton: 'COMENZAR',
                    ),
                    const SizedBox(height: 20),
                    // Regular Plan Card
                    PlanCard(
                      color: Colors.white,
                      borderColor: Colors.blueAccent,
                      planName: 'Regular',
                      price: '58.99',
                      features: const [
                        'Maximum 15 Workers',
                        'Maximum 3 Admins',
                        'Maximum 150 Rooms',
                        '20GB Storage',
                      ],
                      buttonColor: Colors.indigo[800]!,
                      behavior: () {
                        // Connection to checkout subscription dart view
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutSubscription(cardIdentifier: 2,)));
                      },
                      textButton: 'COMENZAR',
                    ),
                    const SizedBox(height: 20,),
                    PlanCard(
                      color: const Color.fromARGB(255, 238, 192, 77),
                      borderColor: Colors.transparent,
                      planName: 'Premium',
                      price: '110.69',
                      features: const [
                        'Unlimited Workers',
                        'Unlimited Admins',
                        'Unlimited Rooms',
                        '500 GB Storage',
                      ],
                      buttonColor: const Color.fromARGB(255, 39, 89, 109),
                      behavior: () {
                        // Connection to checkout subscription dart view
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutSubscription(cardIdentifier: 3,)));
                      },
                      textButton: 'COMENZAR',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}