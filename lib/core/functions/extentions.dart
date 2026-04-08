import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Sized on num {
  Widget get hs => SizedBox(height: h);
  Widget get ws => SizedBox(width: w);
}
