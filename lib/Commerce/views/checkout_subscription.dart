import 'package:flutter/material.dart';
import 'package:sweetmanager/Commerce/widgets/plan_card.dart';
import 'package:sweetmanager/Shared/widgets/base_layout.dart';

class CheckoutSubscription extends StatefulWidget {
  const CheckoutSubscription({super.key, required this.cardIdentifier});

  final int cardIdentifier;

  @override
  State<CheckoutSubscription> createState() => CheckoutSubscriptionState();
}

class CheckoutSubscriptionState extends State<CheckoutSubscription> {


  // Declare all the variables 

  final TextEditingController _cardOwnerController = TextEditingController();

  final TextEditingController _cardNumberController = TextEditingController();
  
  final TextEditingController _expiryDateController = TextEditingController();
  
  final TextEditingController _securityCodeController = TextEditingController();
  
  final TextEditingController _emailController = TextEditingController();

  late int cardIdentifier;

  @override
  void initState() {
    super.initState();

    // Initialize the cardIdentifier from widget's constructor
    cardIdentifier = widget.cardIdentifier;
  }

  @override
  void dispose() {
    _cardOwnerController.dispose();

    _cardNumberController.dispose();

    _expiryDateController.dispose();

    _securityCodeController.dispose();

    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(role: '', childScreen: getContentView());
  }

  Widget getContentView()
  {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('assets/images/back_login.png'), // Replace with your background image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Checkout Card
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Proceed to checkout',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cardOwnerController,
                    decoration: const InputDecoration(
                      labelText: 'Card owner name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Card number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryDateController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            labelText: 'Expiry date',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _securityCodeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Security Code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Access cardIdentifier here
                      print('Card identifier: $cardIdentifier');
                      print('Card owner: ${_cardOwnerController.text}');
                      print('Card number: ${_cardNumberController.text}');
                      print('Expiry date: ${_expiryDateController.text}');
                      print('Security code: ${_securityCodeController.text}');
                      print('Email: ${_emailController.text}');

                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 16),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  getPlanCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget getPlanCard()
  {
    if(cardIdentifier == 1)
    {
      return PlanCard(
        color: Colors.brown[200]!,
        planName: 'Basico',
        price: '29.50',
        features: const [
          'Max 5 Empleados',
          'Max 1 Administrador',
          'Max 50 Dormitorios',
          'Almacenamiento de 5 GB'
        ],
        buttonColor: Colors.black,
        behavior: (){ },
        textButton: 'Pendiente',
      );
    }
    else if(cardIdentifier == 2)
    {
      return PlanCard(
        color: Colors.white,
        borderColor: Colors.blueAccent,
        planName: 'Regular',
        price: '58.99',
        features: const [
          'Max 150 Habitaciones',
          'Max 3 Administradores',
          'Max 15 Trabajadores',
          'Almacenamiento de 20 GB'
        ],
        buttonColor: Colors.indigo[800]!,
        behavior: (){ },
        textButton: 'Pendiente',
      );
    }
    else
    {
      return PlanCard(
        color: const Color.fromARGB(255, 238, 192, 77),
        borderColor: Colors.transparent,
        planName: 'Premium',
        price: '110.69',
        features: const [
          'Dormitorios ilimitados',
          'Administradores ilimitados',
          'Trabajadores ilimitados',
          'Almacenamiento de 500 GB'
        ],
        buttonColor: const Color.fromARGB(255, 39, 89, 109),
        behavior: (){ },
        textButton: 'Pendiente',
        
      );
    }
  }
}