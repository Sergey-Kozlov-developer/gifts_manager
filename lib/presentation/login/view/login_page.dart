import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/presentation/home/view/home_page.dart';
import 'package:gifts_manager/presentation/login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const Scaffold(
        body: _LoginPageWidget(),
      ),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  const _LoginPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  // переменные. после ввода пояты и нажатия ОК, переход к след полю ввода(пароль)
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BlocListener<LoginBloc, LoginState> появление инфы что мы авторизованы
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.authenticated) {
          // если прошли авториз, переходим в HomePage
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 64),
          Center(
              child: Text(
            "Вход",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          )),
          Spacer(flex: 88),
          // ввод email
          _EmailField(
            emailFocusNode: _emailFocusNode,
            passwordFocusNode: _passwordFocusNode,
          ),
          const SizedBox(height: 8),
          // ввод password
          _PasswordField(passwordFocusNode: _passwordFocusNode),
          const SizedBox(height: 40),
          // кнопка войти
          _LoginButton(),
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
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: SizedBox(
        width: double.infinity,
        // 1) в BlocSelector проверяем на валидность, если все верно
        // то при нажатии на кнопку Войти переходим на дом. экран
        // 2) пока не веедена почта с паролем, то кнопка неактивна
        child: BlocSelector<LoginBloc, LoginState, bool>(
          selector: (state) {
            return state.emailValid && state.passwordValid;
          },
          builder: (context, fieldsValid) {
            return ElevatedButton(
              // 1) передаем в bloc инфу о нажатии на кнопку
              // 2) read передает инфу в блок без подписки на изменение
              onPressed: fieldsValid
                  ? () => context
                      .read<LoginBloc>()
                      .add(const LoginLoginButtonClicked())
                  : null,
              child: Text('Войти'),
            );
          },
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    Key? key,
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
  })  : _emailFocusNode = emailFocusNode,
        _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: TextField(
        // изменение фокуса поля ввода
        focusNode: _emailFocusNode,
        // логика ввода email
        onChanged: (text) =>
            context.read<LoginBloc>().add(LoginEmailChanged(text)),
        // нажимаем на ОК после ввода email переходим на поле Пароль
        onSubmitted: (_) => _passwordFocusNode.requestFocus(),

        decoration: InputDecoration(hintText: 'Почта'),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
    required FocusNode passwordFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: TextField(
        // изменение фокуса поля ввода
        focusNode: _passwordFocusNode,
        // логика ввода пароля
        onChanged: (text) =>
            context.read<LoginBloc>().add(LoginPasswordChanged(text)),
        onSubmitted: (_) =>
            context.read<LoginBloc>().add(const LoginLoginButtonClicked()),
        decoration: InputDecoration(hintText: 'Пароль'),
      ),
    );
  }
}
