import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

TextStyle poppins20W600(color) => GoogleFonts.poppins(
    fontSize: 20.sp, fontWeight: FontWeight.w600, color: color);

TextStyle poppins14W300({Color color = AppColors.primary}) =>
    GoogleFonts.poppins(
        fontSize: 14.sp, fontWeight: FontWeight.w300, color: color);

TextStyle poppins14W400() => GoogleFonts.poppins(
    fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.primary);

TextStyle poppins12W400() => GoogleFonts.poppins(
    fontSize: 12.sp, fontWeight: FontWeight.w400, color: AppColors.primary);

//500
TextStyle poppins18(fontWeight) => GoogleFonts.poppins(
    fontSize: 18.sp, fontWeight: fontWeight, color: AppColors.primary);

TextStyle poppins16W500white() => GoogleFonts.poppins(
    fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white);

TextStyle poppins16W500black() => GoogleFonts.poppins(
    fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.primary);

TextStyle poppinsW500Primary(size) => GoogleFonts.poppins(
    fontWeight: FontWeight.w500, fontSize: size, color: AppColors.primary);
TextStyle poppinsPrimary({size, weight}) => GoogleFonts.poppins(
    fontWeight: weight, fontSize: size, color: AppColors.primary);

