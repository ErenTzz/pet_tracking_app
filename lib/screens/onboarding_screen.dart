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
        duration: Duration(milliseconds: 500),
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
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4),
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
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor, // Dinamik text rengi
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 20,
              color: textColor, // Dinamik text rengi
            ),
            textAlign: TextAlign.center,
          ),
          if (isLastPage) ...[
            SizedBox(height: 40),
            InkWell(
              onTap: onButtonPressed,
              borderRadius: BorderRadius.circular(25),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withValues(alpha: 1.5),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Haydi Başlayalım',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
