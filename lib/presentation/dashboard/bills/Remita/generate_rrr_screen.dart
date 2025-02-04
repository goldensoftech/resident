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

  Future<void>? _request;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
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

    final List<Map<String, dynamic>> customFields =
        selectedProduct!.fields.map((field) {
      return {
        "variable_name":
            field.varName, // Assuming fieldId corresponds to the variable name
        "value": _controllers[field.varName]?.text ?? '',
      };
    }).toList();
    // print("AMount value is ${customer.amount}");
    rrrDetails = await TransactionBackend().initiateRemitaPayment(context,
        billPaymentProductId: selectedProduct!.productId,
        amount: double.parse(_amountController.text),
        customerId: "11111",
        email: ResponseData.loginResponse!.isLoggedIn == true
            ? ResponseData.loginResponse!.user!.userName!
            : _emailController.text,
        phoneNumber: ResponseData.loginResponse!.isLoggedIn == true
            ? ResponseData.loginResponse!.user!.phoneNumber!
            : _phoneController.text,
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
                                                        _controllers.clear();
                                                        for (var field
                                                            in data.fields) {
                                                          _controllers[field
                                                                  .varName] =
                                                              TextEditingController();
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
                                                    FieldType.singleselect)
                                            ? true
                                            : false,
                                    onTap: () {
                                      if (field.type == FieldType.multiselect ||
                                          field.type ==
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
                                                            itemCount: field
                                                                .options.length,
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
                                          width: displaySize.width * .9,
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
                                                            "Remita Payment",
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
                                                                SizedBox(
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
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: SizedBox(
                                                            height: 20,
                                                            width: displaySize
                                                                    .width *
                                                                .5,
                                                            child: Text(
                                                              _nameController
                                                                      .text ??
                                                                  "USER",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
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
                                                        SizedBox(
                                                          height: 20,
                                                          width: displaySize
                                                                  .width *
                                                              .5,
                                                          child: Text(
                                                            selectedProduct!
                                                                .productName,
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
                                                        await Pay().withRemita(
                                                            context,
                                                            rrrData:
                                                                rrrDetails!,
                                                            details: details);
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
