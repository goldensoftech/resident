import 'package:resident/app_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(Phoenix(
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            Widget error =
                Text('......rendering error....: ${errorDetails.summary}');
            if (child is Scaffold || child is Navigator) {
              error = Scaffold(
                body: Center(
                  child: error,
                ),
              );
            }
            return ErrorScreen();
          };
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Resident',
            // You can use the library anywhere in the app even in theme
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Mulish',
              dividerTheme: const DividerThemeData(
                color: Colors.transparent,
              ),

              // textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.0.sp, displayColor: Colors.black),
            ),
            home: const SplashScreen(),
          );
        });
  }
}
