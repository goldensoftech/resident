import 'package:carousel_slider/carousel_slider.dart'hide CarouselController;
import 'package:resident/app_export.dart';

class AdvertItem extends StatefulWidget {
  const AdvertItem({super.key});

  @override
  State<AdvertItem> createState() => _AdvertItemState();
}

class _AdvertItemState extends State<AdvertItem> {
  final imgList = [slide1, slide2, slide3];
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CarouselSlider(
        options: CarouselOptions(
            animateToClosest: true,
            aspectRatio: 2.8,
            pauseAutoPlayOnTouch: true,
            autoPlay: true,
            enableInfiniteScroll: true,
            viewportFraction: 1),
        items: imgList
            .map(
              (advert) => Container(
                // padding: const EdgeInsets.all(5.0),
                width: displaySize.width,
                height: 100,
                child: SvgPicture.asset(
                  advert,
                  fit: BoxFit.contain,
                ),
              ),

              //   Image.network(advert.imgUrl,
              //     height: size.height/5,
              //       fit: BoxFit.contain, // Adjust the BoxFit property
              //  ///  width:  size,
              //  ///
              //       errorBuilder: (context, url, error) => SvgPicture.asset(
              //           '${assetsUrl}/advert1.png',
              //           fit: BoxFit.contain))
            )
            .toList(),
      ),
    );
  }
}
