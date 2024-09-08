import 'package:resident/app_export.dart';

mixin FormInputFields<T extends StatefulWidget> on State<T> {
  bool isHiddenForPassword = true;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  final regExp = RegExp(
      r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
      "'" // <-- ' is added to the expression
      ']');
  double strength = 0;
  late String password;

  TextFormField email(TextEditingController controller, bool showIcon) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      controller: controller,
      style: const TextStyle(
        height: 1,
      ),
      cursorOpacityAnimates: true,
      cursorWidth: 1,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
          hintText: 'Email Address',
          hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey200),
          //labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: AppColors.formGrey),
              borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.appGold),
          ),
          suffixIcon: showIcon
              ? Icon(
                  Icons.email_outlined,
                  color: AppColors.iconGrey,
                  size: 24,
                )
              : SizedBox.shrink()),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if ((value == null || value.isEmpty)) {
          return 'Please fill in the field';
        } else if (!(RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
            .hasMatch(value))) {
          return 'Please enter a valid email';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField textInput(
      TextEditingController controller,
      String label,
      dynamic maxLength,
      String hint,
      int maxLines,
      TextInputType textInputType,
      bool requiredField,
      {VoidCallback? onChanged,
      bool readOnly = false}) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (requiredField) {
            return '${label} is required';
          }
        }
        return null;
      },
      controller: controller,
      // maxLength: maxLength,
      maxLines: maxLines,
      onChanged: (value) {
        setState(() {
          onChanged;
        });
      },
      readOnly: readOnly,
      cursorOpacityAnimates: true,
      cursorWidth: 1,
      cursorColor: Colors.black,
      style: TextStyle(height: 1, fontSize: 14.sp),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.grey200),
          // label: Text(label),
          // labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: AppColors.formGrey),
              borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.appGold),
          )),
      keyboardType: textInputType,
    );
  }

  TextFormField textSocial(
      TextEditingController controller,
      String labelImage,
      dynamic maxLength,
      String hint,
      int maxLines,
      TextInputType textInputType,
      bool requiredField) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (requiredField) {
            return 'It is required';
          }
        }
        return null;
      },
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: (value) {
        setState(() {});
      },
      style: TextStyle(height: 1, fontSize: 14.sp),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
          // label: Text(label),
          // labelStyle: const TextStyle(color: Colors.black54),

          hintText: hint,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.w, color: AppColors.formGrey),
              borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.appGold),
          ),
          prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  ),
                  width: 50.w,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(labelImage),
                      )),
                ),
              ))),
      keyboardType: textInputType,
    );
  }

  TextFormField searchField(
      TextEditingController controller,
      String label,
      dynamic maxLength,
      String hint,
      int maxLines,
      TextInputType textInputType,
      bool requiredField) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (requiredField) {
            return 'It is required';
          }
        }
        return null;
      },
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: const TextStyle(height: 1),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          label: Text(label),
          labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(27.r)),
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27.r),
            borderSide: BorderSide(width: 2.w, color: AppColors.appGold),
          )),
      keyboardType: textInputType,
    );
  }
}
