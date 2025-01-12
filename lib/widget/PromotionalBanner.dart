import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // استيراد مكتبة url_launcher

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({Key? key}) : super(key: key);

  // دالة لفتح الرابط
  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'تعذر فتح الرابط: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Featured Offers",
            style: TextStyle(
              color: Color(0xFF053C8E),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.25,
          child: PageView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              final List<Map<String, String>> promos = [
                {
                  'image': 'images/adidas.png',
                  'title': 'For every \seeking excellence',
                  'buttonText': 'اكتشف العروض',
                  'url': 'https://www.adidas.com'
                },
                {
                  'image': 'images/naik.png',
                  'title': 'For every seeking excellence',
                  'buttonText': 'احجز موعدك',
                  'url': 'https://www.nike.com'
                },
              ];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          promos[index]['image']!,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            print(
                                'Error loading image: ${promos[index]['image']}');
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promos[index]['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              SizedBox(
                                height: screenSize.height * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final String? url = promos[index]
                                        ['url']; // التحقق من الرابط
                                    if (url != null) {
                                      _openLink(url);
                                    } else {
                                      print('الرابط غير متوفر');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF053C8E),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    promos[index]['buttonText']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenSize.width * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
