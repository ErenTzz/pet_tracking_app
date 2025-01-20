import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingPage(
            image: 'assets/images/welcome.png',
            title: 'Uygulamaya Hoşgeldiniz',
            description:
                'Evcil hayvan bakımını kolaylaştıran uygulamamız sizi bekliyor!',
          ),
          OnboardingPage(
            image: 'assets/images/features1.png',
            title: 'Özellikler',
            description:
                'Beslenme takibi, sağlık durumu kaydı ve hatırlatıcılar.',
          ),
          OnboardingPage(
            image: 'assets/images/features2.png',
            title: 'Ve Daha Fazlası',
            description:
                'Evcil hayvanlarınız için harika bir takip deneyimi sunuyoruz!',
            isLastPage: true,
            onButtonPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool isLastPage;
  final VoidCallback? onButtonPressed;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.isLastPage = false,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          if (isLastPage) ...[
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('Uygulamayı Kullan'),
            ),
          ]
        ],
      ),
    );
  }
}
