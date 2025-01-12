import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unichat_app/ui/pagrs/Loign.dart'; // Adjusted the typo from 'Loign' to 'Login'

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: [
                  buildPage(
                    color: Colors.white, // Set background color to white
                    image: 'images/41.png',
                    title: 'Welcome to Trendy',
                    subtitle:
                        'Shop easily and discover the best deals and trendy products.',
                  ),
                  buildPage(
                      color: Colors.white, // Set background color to white
                      image: 'images/42.png',
                      title: 'The Latest Trends Await You',
                      subtitle:
                          'Discover trendy clothes for all tastes and occasions.'),
                  buildPage(
                    color: Colors.white, // Set background color to white
                    image: 'images/43.png',
                    title: 'A Smooth and Secure Shopping Experience',
                    subtitle: 'Pay easily and enjoy fast delivery services.',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Skip',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 1, 33, 80),
                      )),
                  onPressed: () => _controller.jumpToPage(2),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: Color.fromARGB(255, 1, 33, 80),
                    activeDotColor: Color.fromARGB(255, 1, 33, 80),
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 16,
                  ),
                ),
                TextButton(
                  child: Text(isLastPage ? 'Start' : 'Next',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 1, 33, 80),
                      )),
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              Loign())); // Adjusted to correct Login page
                    } else {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: color, // Set background color to white
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image,
              height: 250, fit: BoxFit.cover), // Improved image display
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 1, 33, 80),
                fontFamily: 'Tajawal'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 1, 33, 80),
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
