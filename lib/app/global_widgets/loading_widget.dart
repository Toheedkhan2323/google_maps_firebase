import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingWidget({super.key, this.size = 50.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDoubleBounce(color: color ?? AppColors.primary, size: size),
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const LoadingWidget(color: AppColors.white),
    );
  }
}
