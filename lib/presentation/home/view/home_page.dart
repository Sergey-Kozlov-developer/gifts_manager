import 'package:flutter/material.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text("HomePage"),
            const SizedBox(height: 42),
            TextButton(
              onPressed: () async {
                await SharedPreferenceData.getInstance().setToken(null);
                // если прошли регистрацию, переходим в HomePage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
