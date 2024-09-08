import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';

class LoadingPageGif extends StatefulWidget {
  const LoadingPageGif({super.key});

  @override
  State<LoadingPageGif> createState() => _LoadingPageGifState();
}

class _LoadingPageGifState extends State<LoadingPageGif>
    with TickerProviderStateMixin {
  late AnimationController _loadingPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingPage = AnimationController(vsync: this);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _loadingPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(120, 0, 0, 0),
        child: Center(
            child: Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          decoration:
              BoxDecoration(color: AppColors.whiteA700, shape: BoxShape.circle),
          child: Image.asset(
            '$assetsUrl/logoLoader.gif',
            // controller: _loadingPage,
            // onLoaded: (composite) {
            //   _loadingPage
            //     ..duration = composite.duration
            //     ..forward();
            // },
            fit: BoxFit.cover,
          ),
        )

            // Image.asset(
            //    repeat: ImageRepeat.noRepeat,

            //   'assets/images/logoLoader.gif', )
            //CircularProgressIndicator()
            ));
  }
}
