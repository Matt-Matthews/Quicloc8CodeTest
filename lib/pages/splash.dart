import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/pages/nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(milliseconds: 3500),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const NavBar())));
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQueryData = MediaQuery.of(context);
    final _screenWidth = _mediaQueryData.size.width;
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'lib/assets/quickloc8.svg',
          width: _screenWidth * 0.6,
        ),
      ),
    );
  }
}
