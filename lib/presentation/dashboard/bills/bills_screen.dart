import 'package:resident/app_export.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> with CustomAppBar {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: defaultAppBar(title: "Bills"),
          backgroundColor: AppColors.whiteA700,
          body: Scrollbar(
            radius: const Radius.circular(5),
            child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                children: [
                  const Text(
                    "Explore our range of services designed to simplify your life",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 40,
                                    mainAxisSpacing: 20,
                                    crossAxisCount: 2),
                            shrinkWrap: true,
                            itemCount: DummyData().billItems.length,
                            itemBuilder: (ctx, index) {
                              final shortCut = DummyData().billItems[index];
                              return BillItem(
                                logoUrl: shortCut['logoUrl'],
                                pageToNavigate: shortCut['pageToGo'],
                                title: shortCut['title'],
                                isApplyColor:
                                    shortCut['color'] == null ? true : false,
                              );
                            }),
                      ),
                    ],
                  ),
                ]),
          ),
        ));
  }
}
