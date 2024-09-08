import 'package:resident/app_export.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int pageChanged = 0;

  @override
  Widget build(BuildContext context) {
    AuthBackend().setFirstTimeOnAppFalse();
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: Scaffold(
          backgroundColor: AppColors.whiteA700,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Column(children: [
                Stack(
                  children: [
                    SizedBox(
                        width: displaySize.width,
                        height: displaySize.height * .52,
                        child: Image.asset(fit: BoxFit.cover, slideBg)),
                    Positioned(
                      top: displaySize.height * .05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: AppColors.gold100,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.topRight,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                navigateRemoveAll(context, const Dashboard());
                              },
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.baseBlack,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaySize.width,
                            height: displaySize.height,
                            child: PageView.builder(
                              allowImplicitScrolling: true,
                              controller: _controller,
                              onPageChanged: (index) {
                                setState(() {
                                  pageChanged = index;
                                });
                              },
                              itemCount: DummyData().slides.length,
                              itemBuilder: (context, index) {
                                return OnboardingSlide(
                                  title: DummyData().slides[index]['title'],
                                  description: DummyData().slides[index]
                                      ['description'],
                                  image: DummyData().slides[index]['image'],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   top:
                    //   child: SizedBox(
                    //     height: displaySize.height * 0.2,
                    //   ),
                    // )
                  ],
                ),
                SizedBox(
                  height: displaySize.height * 0.03,
                ),
                Text('${DummyData().slides[pageChanged]['title']}\nEasily',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: AppColors.black900,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: displaySize.height * 0.02),
                SizedBox(
                  width: displaySize.width * 0.45,
                  child: Text(
                      '${DummyData().slides[pageChanged]['description']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w400)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: WormEffect(
                        dotHeight: 3,
                        dotWidth: 26,
                        radius: 10,
                        dotColor: Colors.black12,
                        activeDotColor: AppColors.appGold),
                  ),
                ),
                SizedBox(
                  width: displaySize.width * 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.appGold,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))
                        //minimumSize: const Size.fromHeight(60)
                        ),
                    //onPressed: () => context.replace('/signup'),
                    onPressed: () =>
                        //  navigateRemoveAll(context, const Dashboard()),
                        navigateRemoveAll(context, const SignUpScreen()),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteA700),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                TextButton(
                  // onPressed: () => context.replace('/signup'),
                  onPressed: () =>
                      navigateRemoveAll(context, const LoginScreen()),
                  // navigateReplace(context, const SignupPageOne()),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    AppColors.whiteA700,
                  )),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              ]),
            ],
          )),
    );
  }
}
