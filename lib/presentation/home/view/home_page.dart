import 'package:flutter/material.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/user_repository.dart';
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
            StreamBuilder<UserDto?>(
                stream: UserRepository.getInstance().observeItem(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text("HomePage");
                  }
                  return Text(snapshot.data.toString(),
                      textAlign: TextAlign.center);
                }),
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
