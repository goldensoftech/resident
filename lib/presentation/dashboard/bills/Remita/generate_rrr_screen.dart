import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:resident/app_export.dart';
import 'package:resident/repository/backend/payment_gateways.backend.dart';

import '../../../../constants/api.dart';

class GenerateRRRScreen extends StatefulWidget {
  const GenerateRRRScreen({super.key});

  @override
  State<GenerateRRRScreen> createState() => _GenerateRRRScreenState();
}

class _GenerateRRRScreenState extends State<GenerateRRRScreen>
    with CustomAppBar, CustomWidgets, ErrorSnackBar {
  int selectedNetworkIndex = 0;
  TextEditingController searchController = TextEditingController();
  final Map<String, TextEditingController> _controllers = {};
  final _formKey = GlobalKey<FormState>();
  int selectedAmountIndex = 0;

  RemitaCategory? selectedCatgory;
  List<RemitaBillerProduct> products = [];
  RemitaBillerProduct? selectedProduct;
  // List<RemitaCategory> _allUtitlities = [];
  List<RemitaCategory> _filteredUtitlities = [];
  RemitaDetails? rrrDetails;
  RemitaCustomer? customer;
  Map<String, Set<String>> selectedMultiOptions = {}; // Stores selected options

  Future<void>? _request;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  double totalPrice = 0.0;
  @override
  void initState() {
    fecthProducts();
    // _allUtitlities = ResponseData.remitaCategories;
    _filteredUtitlities = ResponseData.remitaCategories;
    searchController.addListener(() {
      _filterUtilities(searchController.text);
    });
    super.initState();
  }

  void fecthProducts() async {
    if (ResponseData.remitaCategories.isEmpty) {
      ResponseData.remitaCategories =
          await TransactionBackend().getRemitaCategories(context);
    }
  }

  void _filterUtilities(String searchText) {
    if (searchText.isEmpty) {
      _filteredUtitlities = ResponseData.remitaCategories;
    } else {
      _filteredUtitlities = ResponseData.remitaCategories
          .where((utility) =>
              utility.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  Map<String, Map<String, Map<String, dynamic>>> selectedItemsWithQty = {};

  Future<void> _fetchProduct(String id) async {
    products =
        await TransactionBackend().getBillerProduct(context, productId: id);
    setState(() {
      products;
    });
  }

  Future<void> initiatePayment() async {
    //  {"variable_name": "account_number", "value": "1111111111111"},
    // {"variable_name": "minimum_vend_amount", "value": "900"},

    final List<Map<String, dynamic>> customFields = [];
    for (final field in selectedProduct!.fields) {
      if (field.varName != "amount_item_list") {
        customFields.add({
          "variable_name": field.varName,
          "value": _controllers[field.varName]?.text ?? '',
        });
      }
    }
    // print("AMount value is ${customer.amount}");
    final List<Map<String, dynamic>> customFieldsMultiSelectWithPrice = [];
    selectedItemsWithQty.forEach((fieldName, items) {
      final List<Map<String, dynamic>> itemsList = [];
      items.forEach((itemName, details) {
        itemsList.add({
          "unitPrice": details['amount'],
          "fixedPrice": details[
              'isFixed'], // Assuming this is dynamic based on your logic
          "quantity": details['quantity'],
          "code": details['code'], // Use itemName or another unique identifier
          "itemName": itemName,
          "selectedListId":
              details['ID'], // Replace with actual ID if available
          "selected": true,
        });
      });
      customFieldsMultiSelectWithPrice.add({
        "variable_name": fieldName,
        "value": itemsList,
      });
    });

    // Build customFieldsMultiSelect
    // final List<Map<String, dynamic>> customFieldsMultiSelect = [];
    // selectedMultiOptions.forEach((fieldName, selectedOptions) {
    //   customFieldsMultiSelect.add({
    //     "variable_name": fieldName,
    //     "value": selectedOptions.toList(),
    //   });
    // });
    if (ResponseData.loginResponse != null &&
        ResponseData.loginResponse!.isLoggedIn == true) {
      _emailController.text = ResponseData.loginResponse!.user!.userName!;
      _phoneController.text = ResponseData.loginResponse!.user!.phoneNumber!;
      _nameController.text =
          "${ResponseData.loginResponse!.user!.firstName!} ${ResponseData.loginResponse!.user!.lastName!}";
    }

    rrrDetails = await TransactionBackend().initiateRemitaPayment(context,
        billPaymentProductId: selectedProduct!.productId,
        amount: double.parse(_amountController.text),
        customFieldsMultiSelectWithPrice: customFieldsMultiSelectWithPrice,
        customerId: "11111",
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        customFields: customFields,
        name: _nameController.text);
    setState(() {
      rrrDetails;
    });
  }

  Future<void> vaidateRmtCustomer(context) async {
    customer = await TransactionBackend().validateRemitaCustomer(context,
        productId: selectedProduct!.productId, customerId: "1111111111111");

    if (customer != null) {
      // await initiatePayment(customer!);
    }
    setState(() {
      customer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: customAppBar(title: "Generate RRR"),
                backgroundColor: AppColors.whiteA700,
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    children: [
                      Text(
                        'Payment Details',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.baseBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _categoryController,
                        readOnly: true,
                        onTap: () {
                          _filterUtilities('');
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.whiteA700,
                              showDragHandle: true,
                              enableDrag: true,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              builder: (context) {
                                return Container(
                                  color: AppColors.whiteA700,
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20),
                                  child: Scrollbar(
                                    radius: const Radius.circular(5),
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          child: Text(
                                            "Select payment ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.baseBlack,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: searchController,
                                          style: const TextStyle(height: 1),
                                          cursorOpacityAnimates: true,
                                          cursorWidth: 1,
                                          // onChanged: filterUtilities,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                            //labelStyle: const TextStyle(color: Colors.black54),
                                            hintText: 'Search Biller',
                                            filled: true,
                                            fillColor: AppColors.lightGrey,
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.schemeColor),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(28.r),
                                                borderSide: BorderSide.none),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: AppColors.schemeColor,
                                              size: 18,
                                            ),

                                            suffixIcon: searchController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    onPressed: () {
                                                      searchController.clear();
                                                      _filterUtilities("");
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons
                                                          .clear_circled_solid,
                                                      color: AppColors.grey500,
                                                    ))
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            itemCount: _filteredUtitlities
                                                .length,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    Divider(
                                                        height: 1,
                                                        color:
                                                            AppColors.grey200),
                                            itemBuilder: (ctx, index) {
                                              final data =
                                                  _filteredUtitlities[index];
                                              return ListTile(
                                                tileColor: AppColors.whiteA700,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                onTap: () {
                                                  setState(() {
                                                    selectedProduct = null;
                                                    _productController.text =
                                                        "";
                                                    selectedCatgory = data;
                                                    selectedItemsWithQty
                                                        .clear();
                                                    _categoryController.text =
                                                        data.name;
                                                    _request =
                                                        _fetchProduct(data.id);
                                                    selectedProduct = null;
                                                  });
                                                  navigateBack(context);
                                                  _request;
                                                },
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Image.network(
                                                      data.logoUrl ?? remitaUrl,
                                                      height: 40,
                                                      width: 40,
                                                      errorBuilder:
                                                          (ctx, url, error) =>
                                                              Image.asset(
                                                                remittaImg,
                                                                height: 40,
                                                                width: 40,
                                                              ),
                                                      fit: BoxFit.contain),
                                                ),
                                                title: Text(
                                                  data.name,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                        style: const TextStyle(height: 1),
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            //labelStyle: const TextStyle(color: Colors.black54),
                            hintText: 'Select category',
                            filled: true,
                            fillColor: AppColors.lightGrey,
                            hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.grey700),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.r)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: SvgPicture.asset(
                              arrowDown,
                              height: 14,
                              width: 14,
                              fit: BoxFit.scaleDown,
                              color: AppColors.grey400,
                              //size: 18,
                            )),
                      ),
                      if (selectedCatgory != null && products.isNotEmpty)
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _productController,
                              readOnly: true,
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: AppColors.whiteA700,
                                    showDragHandle: true,
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    builder: (context) {
                                      return Container(
                                        color: AppColors.whiteA700,
                                        constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 20),
                                        child: Scrollbar(
                                          radius: const Radius.circular(5),
                                          child: ListView(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                child: Text(
                                                  "Select product ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppColors.baseBlack,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: searchController,
                                                style:
                                                    const TextStyle(height: 1),
                                                cursorOpacityAnimates: true,
                                                cursorWidth: 1,
                                                // onChanged: filterUtilities,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 15),
                                                  //labelStyle: const TextStyle(color: Colors.black54),
                                                  hintText: 'Search Biller',
                                                  filled: true,
                                                  fillColor:
                                                      AppColors.lightGrey,
                                                  hintStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .schemeColor),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      borderSide:
                                                          BorderSide.none),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      28.r),
                                                          borderSide:
                                                              BorderSide.none),
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color:
                                                        AppColors.schemeColor,
                                                    size: 18,
                                                  ),

                                                  suffixIcon: searchController
                                                          .text.isNotEmpty
                                                      ? IconButton(
                                                          onPressed: () {
                                                            searchController
                                                                .clear();
                                                            _filterUtilities(
                                                                "");
                                                          },
                                                          icon: Icon(
                                                            CupertinoIcons
                                                                .clear_circled_solid,
                                                            color: AppColors
                                                                .grey500,
                                                          ))
                                                      : const SizedBox.shrink(),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ListView.separated(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  itemCount: products.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ScrollPhysics(),
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                              int index) =>
                                                          Divider(
                                                              height: 1,
                                                              color: AppColors
                                                                  .grey200),
                                                  itemBuilder: (ctx, index) {
                                                    final data =
                                                        products[index];
                                                    return ListTile(
                                                      tileColor:
                                                          AppColors.whiteA700,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 10),
                                                      onTap: () {
                                                        setState(() {
                                                          selectedProduct =
                                                              data;
                                                          _productController
                                                                  .text =
                                                              data.productName;
                                                          _amountController
                                                                  .text =
                                                              data.amount
                                                                  .toString();
                                                          // _request =
                                                          //     _fetchProduct(data.id);
                                                          // for (var field in products) {
                                                          //   _controllers[field.varName] = TextEditingController();
                                                          // }
                                                        });
                                                        print(selectedProduct);
                                                        _controllers.clear();
                                                        for (var field
                                                            in data.fields) {
                                                          _controllers[field
                                                                  .varName] =
                                                              TextEditingController();
                                                          selectedItemsWithQty
                                                              .clear();
                                                        }
                                                        for (var i
                                                            in data.fields) {
                                                          print(
                                                              "${i.displayName} required ${i.required}");
                                                        }

                                                        navigateBack(context);
                                                      },
                                                      leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        child: Image.network(
                                                            selectedCatgory!
                                                                    .logoUrl ??
                                                                remitaUrl,
                                                            height: 40,
                                                            width: 40,
                                                            errorBuilder: (ctx,
                                                                    url,
                                                                    error) =>
                                                                Image.asset(
                                                                  remittaImg,
                                                                  height: 40,
                                                                  width: 40,
                                                                ),
                                                            fit:
                                                                BoxFit.contain),
                                                      ),
                                                      title: Text(
                                                        data.productName,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                              style: const TextStyle(height: 1),
                              cursorOpacityAnimates: true,
                              cursorWidth: 1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                  //labelStyle: const TextStyle(color: Colors.black54),
                                  hintText: 'Select category',
                                  filled: true,
                                  fillColor: AppColors.lightGrey,
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey700),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.r)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: SvgPicture.asset(
                                    arrowDown,
                                    height: 14,
                                    width: 14,
                                    fit: BoxFit.scaleDown,
                                    color: AppColors.grey400,
                                    //size: 18,
                                  )),
                            ),
                          ],
                        ),
                      if (selectedProduct != null)
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              readOnly: selectedProduct!.isAmountFixed,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter amount';
                                } else if (value == '0' ||
                                    value == "0.00" ||
                                    value == "0.0") {
                                  return 'Please enter a valid  amount';
                                }
                                return null;
                              },
                              style: const TextStyle(height: 1),
                              cursorOpacityAnimates: true,
                              cursorWidth: 1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Amount To Pay',

                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey700),

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w, color: AppColors.formGrey),
                                    borderRadius: BorderRadius.circular(8.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide:
                                      BorderSide(color: AppColors.appGold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ...selectedProduct!.fields.map((field) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    readOnly:
                                        (field.type == FieldType.multiselect ||
                                                field.type ==
                                                    FieldType.singleselect ||
                                                field.type ==
                                                    FieldType
                                                        .multiselectwithprice ||
                                                field.type == FieldType.date)
                                            ? true
                                            : false,
                                    onTap: () {
                                      if (field.type ==
                                          FieldType.multiselectwithprice) {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: AppColors.whiteA700,
                                          showDragHandle: true,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          builder: (context) {
                                            // Initialize selectedItemsWithQty for this field if it doesn't exist
                                            selectedItemsWithQty.putIfAbsent(
                                                field.varName, () => {});

                                            // Function to calculate the total price
                                            double calculateTotalPrice() {
                                              return selectedItemsWithQty[
                                                      field.varName]!
                                                  .entries
                                                  .fold(0.0, (sum, entry) {
                                                double amount = entry
                                                        .value['amount'] ??
                                                    0.0; // Ensure amount is a double
                                                int quantity =
                                                    entry.value['quantity'] ??
                                                        1;
                                                return sum +
                                                    (amount * quantity);
                                              });
                                            }

                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Select Items & Enter Quantity",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: field
                                                                  .options
                                                                  ?.length ??
                                                              0, // Null check for field.options
                                                          itemBuilder:
                                                              (ctx, index) {
                                                            final data = field
                                                                    .options![
                                                                index]; // Safe access after null check
                                                            bool isOptionFixed =
                                                                data.isFixed ??
                                                                    false;
                                                            bool isSelected =
                                                                selectedItemsWithQty[field
                                                                            .varName]
                                                                        ?.containsKey(
                                                                            data.displayName) ??
                                                                    false;
                                                            int quantity = selectedItemsWithQty[
                                                                        field
                                                                            .varName]?[data
                                                                        .displayName]
                                                                    ?[
                                                                    'quantity'] ??
                                                                1;
                                                            double unitPrice = double
                                                                    .tryParse(data
                                                                            .value ??
                                                                        '0.0') ??
                                                                0.0; // Handle null value for data.value
                                                            double
                                                                enteredAmount =
                                                                selectedItemsWithQty[
                                                                            field
                                                                                .varName]?[data
                                                                            .displayName]
                                                                        ?[
                                                                        'amount'] ??
                                                                    unitPrice;

                                                            // Create a TextEditingController for each item
                                                            final TextEditingController
                                                                amountController =
                                                                TextEditingController(
                                                              text: enteredAmount
                                                                  .toStringAsFixed(
                                                                      2), // Pre-fill with the stored amount
                                                            );

                                                            return Card(
                                                              color: AppColors
                                                                  .whiteA700,
                                                              elevation: 2,
                                                              child: ListTile(
                                                                title: Text(data
                                                                    .displayName),
                                                                subtitle:
                                                                    isOptionFixed
                                                                        ? Text(
                                                                            "Unit Price: ₦${unitPrice.toStringAsFixed(2)}")
                                                                        : SizedBox(
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                40,
                                                                            child:
                                                                                TextField(
                                                                              controller: amountController, // Use the controller
                                                                              keyboardType: TextInputType.number,
                                                                              decoration: const InputDecoration(
                                                                                labelText: "Enter Amount",
                                                                                border: OutlineInputBorder(),
                                                                              ),
                                                                              onChanged: (val) {
                                                                                setState(() {
                                                                                  double newAmount = double.tryParse(val) ?? 0.0; // Ensure newAmount is a double
                                                                                  selectedItemsWithQty[field.varName]!.update(
                                                                                    data.displayName, // Use displayName as the key
                                                                                    (value) => {
                                                                                      'amount': newAmount,
                                                                                      'code': data.code,
                                                                                      'ID': data.fieldId,
                                                                                      'isFixed': isOptionFixed,
                                                                                      'quantity': value['quantity'],
                                                                                    },
                                                                                    ifAbsent: () => {
                                                                                      'amount': newAmount,
                                                                                      'code': data.code,
                                                                                      'ID': data.fieldId,
                                                                                      'isFixed': isOptionFixed,
                                                                                      'quantity': 1,
                                                                                    },
                                                                                  );
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                trailing:
                                                                    isSelected
                                                                        ? Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              IconButton(
                                                                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    if (quantity > 1) {
                                                                                      selectedItemsWithQty[field.varName]![data.displayName]!['quantity'] = quantity - 1;
                                                                                    } else {
                                                                                      selectedItemsWithQty[field.varName]!.remove(data.displayName);
                                                                                    }
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Text("$quantity", style: const TextStyle(fontSize: 16)),
                                                                              IconButton(
                                                                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    selectedItemsWithQty[field.varName]!.update(
                                                                                      data.displayName, // Use displayName as the key
                                                                                      (value) => {
                                                                                        'code': data.code,
                                                                                        'isFixed': isOptionFixed,
                                                                                        'ID': data.fieldId,
                                                                                        'amount': value['amount'].toDouble(), // Ensure amount is a double
                                                                                        'quantity': value['quantity'] + 1,
                                                                                      },
                                                                                      ifAbsent: () => {
                                                                                        'code': data.code,
                                                                                        'ID': data.fieldId,
                                                                                        'isFixed': isOptionFixed,
                                                                                        'amount': isOptionFixed ? unitPrice.toDouble() : 0.0, // Ensure amount is a double
                                                                                        'quantity': 1,
                                                                                      },
                                                                                    );
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : IconButton(
                                                                            icon:
                                                                                Icon(Icons.add, color: AppColors.appGold),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                selectedItemsWithQty[field.varName]!.putIfAbsent(
                                                                                  data.displayName, // Use displayName as the key
                                                                                  () => {
                                                                                    'code': data.code,
                                                                                    'isFixed': isOptionFixed,
                                                                                    'ID': data.fieldId,
                                                                                    'amount': isOptionFixed ? unitPrice.toDouble() : 0.0, // Ensure amount is a double
                                                                                    'quantity': 1,
                                                                                  },
                                                                                );
                                                                              });
                                                                            },
                                                                          ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              "Total Amount",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      14)),
                                                          Text(
                                                              "₦${calculateTotalPrice().toStringAsFixed(2)}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      14)),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          _controllers.putIfAbsent(
                                                              field.varName,
                                                              () =>
                                                                  TextEditingController());
                                                          _controllers[field
                                                                      .varName]
                                                                  ?.text =
                                                              "Items: ${selectedItemsWithQty[field.varName]!.entries.map((e) => "${e.value['quantity']} x ₦${e.value['amount'].toStringAsFixed(2)}").join(", ")}\nTotal: ₦${calculateTotalPrice().toStringAsFixed(2)}";
                                                          _amountController
                                                                  .text =
                                                              calculateTotalPrice()
                                                                  .toStringAsFixed(
                                                                      2);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Confirm Selection"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      } else if (field.type ==
                                          FieldType.multiselect) {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: AppColors.whiteA700,
                                          showDragHandle: true,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          builder: (context) {
                                            // Ensure selectedMultiOptions[field.varName] is initialized
                                            selectedMultiOptions.putIfAbsent(
                                                field.varName,
                                                () => <String>{});

                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 20),
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                        "Select Options",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: field
                                                                  .options
                                                                  ?.length ??
                                                              0, // Null check for field.options
                                                          itemBuilder:
                                                              (ctx, index) {
                                                            final data = field
                                                                    .options![
                                                                index]; // Safe access after null check
                                                            bool isSelected =
                                                                selectedMultiOptions[field
                                                                            .varName]
                                                                        ?.contains(
                                                                            data.displayName) ??
                                                                    false;

                                                            return CheckboxListTile(
                                                              key: ValueKey(data
                                                                  .displayName), // Unique key for each checkbox
                                                              title: Text(data
                                                                  .displayName),
                                                              value: isSelected,
                                                              onChanged: (bool?
                                                                  selected) {
                                                                setState(() {
                                                                  if (selected ==
                                                                      true) {
                                                                    selectedMultiOptions[field
                                                                            .varName]
                                                                        ?.add(data
                                                                            .displayName);
                                                                  } else {
                                                                    selectedMultiOptions[field
                                                                            .varName]
                                                                        ?.remove(
                                                                            data.displayName);
                                                                  }
                                                                });
                                                              },
                                                              activeColor:
                                                                  AppColors
                                                                      .appGold,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Ensure _controllers[field.varName] is initialized
                                                          _controllers.putIfAbsent(
                                                              field.varName,
                                                              () =>
                                                                  TextEditingController());

                                                          // Map selected values to their display names
                                                          final selectedDisplayNames = field
                                                              .options
                                                              ?.where((option) =>
                                                                  selectedMultiOptions[field
                                                                          .varName]
                                                                      ?.contains(
                                                                          option
                                                                              .displayName) ??
                                                                  false)
                                                              .map((option) =>
                                                                  option
                                                                      .displayName)
                                                              .join(", ");

                                                          _controllers[field
                                                                      .varName]
                                                                  ?.text =
                                                              selectedDisplayNames ??
                                                                  "";
                                                          _controllers[field
                                                                      .varName]
                                                                  ?.text =
                                                              _controllers[field
                                                                      .varName]!
                                                                  .text
                                                                  .trim();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Confirm Selection"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      } else if (field.type ==
                                          FieldType.singleselect) {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                AppColors.whiteA700,
                                            showDragHandle: true,
                                            enableDrag: true,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            builder: (context) {
                                              print(
                                                  "Opti legth ${field.options.length}");
                                              return Container(
                                                  color: AppColors.whiteA700,
                                                  constraints: BoxConstraints(
                                                      maxHeight:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.8),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 20),
                                                  child: Scrollbar(
                                                    radius:
                                                        const Radius.circular(
                                                            5),
                                                    child: ListView(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            "Select an option",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: AppColors
                                                                    .baseBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        ListView.separated(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            itemCount:
                                                                field.options
                                                                    .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const ScrollPhysics(),
                                                            separatorBuilder: (BuildContext
                                                                        context,
                                                                    int
                                                                        index) =>
                                                                Divider(
                                                                    height: 1,
                                                                    color: AppColors
                                                                        .grey200),
                                                            itemBuilder:
                                                                (ctx, index) {
                                                              final data =
                                                                  field.options[
                                                                      index];
                                                              return ListTile(
                                                                tileColor:
                                                                    AppColors
                                                                        .whiteA700,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                                onTap: () {
                                                                  setState(() {
                                                                    //  selectedBillerIndex = index;
                                                                    _controllers[field.varName]!
                                                                            .text =
                                                                        data.displayName;
                                                                    // selectedType = null;
                                                                  });
                                                                  navigateBack(
                                                                      context);
                                                                },
                                                                leading:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40),
                                                                  child: Image.asset(
                                                                      remittaImg,
                                                                      height:
                                                                          40,
                                                                      width: 40,
                                                                      fit: BoxFit
                                                                          .contain),
                                                                ),
                                                                title: Text(
                                                                  data.displayName,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      } else if (field.type == FieldType.date) {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        ).then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              // Format the date as DD/MM/YYYY
                                              _controllers[field.varName]
                                                      ?.text =
                                                  "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
                                            });
                                          }
                                        });
                                      }
                                    },
                                    controller: _controllers[field.varName],
                                    keyboardType: getKeyType(field.type),
                                    validator: (value) {
                                      //if (field.required) {
                                      if (value == null || value.isEmpty) {
                                        return '${field.displayName} is required';
                                      }
                                      return null;
                                      // }
                                      // return null;
                                    },
                                    style: const TextStyle(height: 1),
                                    cursorOpacityAnimates: true,
                                    cursorWidth: 1,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      labelText: field.displayName,
                                      hintText: field.displayName,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12),
                                      //labelStyle: const TextStyle(color: Colors.black54),

                                      hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.grey700),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.w,
                                              color: AppColors.formGrey),
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide(
                                            color: AppColors.appGold),
                                      ),
                                    ),
                                  ));
                            }),
                          ],
                        ),

                      const SizedBox(
                        height: 10,
                      ),
                      if (!AuthBackend.isLoggedIn() && selectedProduct != null)
                        Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              style: const TextStyle(height: 1),
                              cursorOpacityAnimates: true,
                              cursorWidth: 1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Payer Name',

                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey700),

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w, color: AppColors.formGrey),
                                    borderRadius: BorderRadius.circular(8.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide:
                                      BorderSide(color: AppColors.appGold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              style: const TextStyle(height: 1),
                              cursorOpacityAnimates: true,
                              cursorWidth: 1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Payer Number',

                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey700),

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w, color: AppColors.formGrey),
                                    borderRadius: BorderRadius.circular(8.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide:
                                      BorderSide(color: AppColors.appGold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              style: const TextStyle(height: 1),
                              cursorOpacityAnimates: true,
                              cursorWidth: 1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Email Address',

                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey700),

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w, color: AppColors.formGrey),
                                    borderRadius: BorderRadius.circular(8.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide:
                                      BorderSide(color: AppColors.appGold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                ),
                persistentFooterAlignment: AlignmentDirectional.bottomCenter,
                persistentFooterButtons: [
                  SizedBox(
                    width: displaySize.width * 0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.appGold,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))
                          //minimumSize: const Size.fromHeight(60)
                          ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        if (selectedProduct == null) {
                          sendErrorMessage(
                              "Error", "Payment details not selected", context);
                          return;
                        }
                        setState(() {
                          _request = initiatePayment();
                        });
                        await _request;
                        if (rrrDetails != null) {
                          showDialog(
                              barrierDismissible: true,
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: SimpleDialog(
                                      insetPadding: EdgeInsets.zero,
                                      contentPadding: EdgeInsets.zero,

                                      //   children: [],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteA700,
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          height: displaySize.height * .7,
                                          width: displaySize.width * .8,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 13.w,
                                                vertical: 20.h),
                                            child: Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        'Transaction Summary',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppColors
                                                                .black900),
                                                      ),
                                                      const Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 20.0),
                                                        child: InkWell(
                                                            onTap: () {
                                                              navigateBack(
                                                                  context);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color: AppColors
                                                                  .black900,
                                                            )),
                                                      ),
                                                    ]),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0,
                                                          vertical: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Transaction Summary',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            "Remita",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .baseBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      thickness: .5,
                                                      color: AppColors.grey400,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0,
                                                          vertical: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'RRR No',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  rrrDetails!
                                                                      .rrr,
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .baseBlack,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  //// padding: EdgeInsets.only(left:3),
                                                                  onTap: () {
                                                                    copyText(
                                                                        rrrDetails!
                                                                            .rrr);
                                                                    sendErrorMessage(
                                                                        "Copied",
                                                                        isSuccess:
                                                                            true,
                                                                        "Transaction Reference copied",
                                                                        context);
                                                                  },

                                                                  child: Icon(
                                                                      Icons
                                                                          .content_copy_rounded,
                                                                      color: AppColors
                                                                          .appGold,
                                                                      size: 18),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      thickness: .5,
                                                      color: AppColors.grey400,
                                                    ),
                                                  ],
                                                ),
                                                Column(children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 2.0,
                                                        vertical: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Customer Name',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .grey500,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        SizedBox(
                                                          width: displaySize
                                                                  .width *
                                                              .3,
                                                          child: Text(
                                                            _nameController
                                                                    .text ??
                                                                "USER",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .baseBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    thickness: .5,
                                                    color: AppColors.grey400,
                                                  ),
                                                ]),
                                                Column(children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 2.0,
                                                        vertical: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Biller',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .grey500,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: SizedBox(
                                                            height: 20,
                                                            width: displaySize
                                                                    .width *
                                                                .5,
                                                            child: Text(
                                                              selectedProduct!
                                                                  .productName,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .baseBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    thickness: .5,
                                                    color: AppColors.grey400,
                                                  ),
                                                ]),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0,
                                                          vertical: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Amount to Pay',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            "$ngnIcon ${UtilFunctions.formatAmount(rrrDetails!.amount)}",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .appGold,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      thickness: .5,
                                                      color: AppColors.grey400,
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width:
                                                      displaySize.width * 0.7,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 14),
                                                        backgroundColor:
                                                            AppColors.appGold,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12))),
                                                    onPressed: () async {
                                                      {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        PaymentDetails details = PaymentDetails(
                                                            customerId: "00",
                                                            customerEmail: ResponseData.loginResponse!.isLoggedIn == true
                                                                ? ResponseData
                                                                    .loginResponse!
                                                                    .user!
                                                                    .userName!
                                                                : _emailController
                                                                    .text,
                                                            amount: rrrDetails!
                                                                .amount,
                                                            customerMobile: ResponseData.loginResponse!.isLoggedIn == true
                                                                ? ResponseData
                                                                    .loginResponse!
                                                                    .user!
                                                                    .phoneNumber!
                                                                : _phoneController
                                                                    .text,
                                                            payerName: _nameController
                                                                .text,
                                                            surcharge: 0,
                                                            paymentGateway:
                                                                PaymentGateway
                                                                    .remita,
                                                            ref:
                                                                rrrDetails!.rrr,
                                                            serviceName:
                                                                selectedProduct!
                                                                    .productName,
                                                            serviceId:
                                                                selectedProduct!
                                                                    .productId,
                                                            paymentCode:
                                                                selectedProduct!
                                                                    .productId,
                                                            transactionType:
                                                                TransactionType.remita);
                                                        // await TransactionBackend().initiateRemitaPayment(
                                                        //     context,
                                                        //     billPaymentProductId:
                                                        //         details
                                                        //             .serviceId!,
                                                        //     amount:
                                                        //         details.amount,
                                                        //     name: details
                                                        //             .payerName ??
                                                        //         "",
                                                        //     email: details
                                                        //             .customerEmail ??
                                                        //         "",
                                                        //     phoneNumber: details
                                                        //             .customerMobile ??
                                                        //         "",
                                                        //     customerId: details
                                                        //         .customerId,
                                                        //     customFields: []);
                                                        // // await TransactionBackend()
                                                        // //     .preProcessPayment(
                                                        // //         context,
                                                        // //         details:
                                                        // //             details);
                                                        await Pay()
                                                            .withPaystack(
                                                                context,
                                                                isRemtaPay:
                                                                    true,
                                                                rrrDetails:
                                                                    rrrDetails!,
                                                                details:
                                                                    details);
                                                      }
                                                    },
                                                    child: Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .whiteA700),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                );
                              });
                        }
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteA700),
                      ),
                    ),
                  ),
                ]),
          ),
          FutureBuilder(
              future: _request,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                  case ConnectionState.waiting:
                    return const LoadingPageGif();
                  case ConnectionState.active:
                    debugPrint("active");
                    return const Text('active');
                  case ConnectionState.done:
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                }
              })
        ],
      ),
    );
  }

  TextInputType getKeyType(FieldType type) {
    switch (type) {
      case FieldType.number:
        return TextInputType.number;

      default:
        return TextInputType.text;
    }
  }
}
