import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumaz_kitchen/utils/routes.dart';
import 'package:tumaz_kitchen/views/login.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 218, 163, 127),
  ).copyWith(
    secondary: Colors.orangeAccent,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(
    const TumasKitchen(),
  );
}

class TumasKitchen extends StatelessWidget {
  const TumasKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tumas Kitchen',
      theme: theme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      getPages: Routes.routes,
    );
  }
}
