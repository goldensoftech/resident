import 'package:resident/app_export.dart';

class RemittaScreen extends StatefulWidget {
  const RemittaScreen({super.key});

  @override
  State<RemittaScreen> createState() => _RemittaScreenState();
}

class _RemittaScreenState extends State<RemittaScreen>
    with CustomAlerts, CustomAppBar {
  @override
  void initState() {
    getCategories(context);
    super.initState();
  }

  void getCategories(context) async {
    if (ResponseData.remitaCategories.isEmpty) {
      ResponseData.remitaCategories =
          await TransactionBackend().getRemitaCategories(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteA700,
        appBar: customAppBar(title: "Remita"),
        body: Scrollbar(
          radius: const Radius.circular(5),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Text(
                "Remita Payments",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.baseBlack),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 20,
                              crossAxisCount: 2),
                      shrinkWrap: true,
                      itemCount: DummyData().rrrItems.length,
                      itemBuilder: (ctx, index) {
                        final shortCut = DummyData().rrrItems[index];
                        return BillItem(
                          logoUrl: billsInactvIcon,
                          pageToNavigate: shortCut['pageToGo'],
                          title: shortCut['title'],
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
