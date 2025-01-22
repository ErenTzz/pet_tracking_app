import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Her sayfa için arka plan ve tema renkleri
  final List<Color> backgroundColors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.deepPurpleAccent,
  ];

  final List<Color> textColors = [
    Colors.white,
    Colors.black,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: backgroundColors[_currentIndex], // Arka plan rengi
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                OnboardingPage(
                  image: 'assets/images/features1.png',
                  title: 'Hoşgeldiniz',
                  description: 'Evcil hayvan bakımını kolaylaştırıyoruz.',
                  textColor: textColors[0],
                ),
                OnboardingPage(
                  image: 'assets/images/welcome.png',
                  title: 'Harika Özellikler',
                  description: 'Beslenme takibi, sağlık durumu kaydı.',
                  textColor: textColors[1],
                ),
                OnboardingPage(
                  image: 'assets/images/features2.png',
                  title: 'Daha Fazlası',
                  description: 'Evcil hayvanlarınız için en iyisi!',
                  textColor: textColors[0],
                  isLastPage: true,
                  onButtonPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ],
            ),
            // Baloncuk göstergesi
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(backgroundColors.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 12 : 8,
                    height: _currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Color textColor;
  final bool isLastPage;
  final VoidCallback? onButtonPressed;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.textColor,
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
          Image.asset(image, height: 325),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor, // Dinamik text rengi
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 20,
              color: textColor, // Dinamik text rengi
            ),
            textAlign: TextAlign.center,
          ),
          if (isLastPage) ...[
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Buton rengi
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Haydi Başlayalım',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
