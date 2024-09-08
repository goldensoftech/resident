import 'package:resident/app_export.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteA700,
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            allowImplicitScrolling: false,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              setState(() => _currentIndex = value);
            },
            children: [
              const HomeScreen(),
              const BillsScreen(),
              if (AuthBackend.isLoggedIn()) const TransactionScreen(),
              if (AuthBackend.isLoggedIn()) const ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            elevation: 0,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            selectedLabelStyle: TextStyle(
                color: AppColors.appGold,
                fontSize: 10,
                fontWeight: FontWeight.w400),
            unselectedLabelStyle: TextStyle(
                color: AppColors.iconlightGrey,
                fontSize: 10,
                fontWeight: FontWeight.w700),
            items: [
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    homeActvIcon,
                  ),
                  icon: SvgPicture.asset(homeInactvIcon),
                  label: "Home"),
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    billsActvIcon,
                  ),
                  icon: SvgPicture.asset(billsInactvIcon),
                  label: "Bills"),
              if (AuthBackend.isLoggedIn())
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      cardActvIcon,
                    ),
                    icon: SvgPicture.asset(cardInactvIcon),
                    label: "Transactions"),
              if (AuthBackend.isLoggedIn())
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      profileActvIcon,
                    ),
                    icon: SvgPicture.asset(profileIactvIcon),
                    label: "Profile"),
            ]),
      ),
    );
  }
}
