import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LoginPageWidget(),
    );
  }
}

class _LoginPageWidget extends StatelessWidget {
  const _LoginPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 64),
        Center(
            child: Text(
          "Вход",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        )),
        Spacer(flex: 88),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: TextField(
            decoration: InputDecoration(hintText: 'Почта'),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: TextField(
            decoration: InputDecoration(hintText: 'Пароль'),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => debugPrint("Нажали кнопку войти"),
              child: Text('Войти'),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Еще нет аккаунта?"),
            TextButton(
              onPressed: () => debugPrint("Нажали кнопку создать"),
              child: Text('Создать'),
            ),

          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => debugPrint("Нажали кнопку Не помню пароль"),
          child: Text('Не помню пароль'),
        ),
        Spacer(flex: 284),
      ],
    );
  }
}
