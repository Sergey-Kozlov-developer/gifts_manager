import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gifts_manager/extension/theme_extension.dart';
import 'package:gifts_manager/presentation/registration/bloc/registration_bloc.dart';
import 'package:gifts_manager/presentation/theme/build_context.dart';
import 'package:gifts_manager/resources/app_colors.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: const Scaffold(
        body: _RegistrationPageWidget(),
      ),
    );
  }
}

class _RegistrationPageWidget extends StatefulWidget {
  const _RegistrationPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_RegistrationPageWidget> createState() =>
      _RegistrationPageWidgetState();
}

class _RegistrationPageWidgetState extends State<_RegistrationPageWidget> {
  // переменные. после ввода пояты и нажатия ОК, переход к след полю ввода(пароль)
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;
  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    SchedulerBinding.instance
        .addPersistentFrameCallback((_) => _addFocusLostHandlers());
  }

  void _addFocusLostHandlers() {
    // _emailFocusNode оповещаем bloc, что поменяли фокус
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationEmailFocusLost());
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationPasswordFocusLost());
      }
    });
    _passwordConfirmationFocusNode.addListener(() {
      if (_passwordConfirmationFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationPasswordConfirmationFocusLost());
      }
    });
    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(const RegistrationNameFocusLost());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Создать аккаунт', style: context.theme.h2),
                  ),
                  const SizedBox(height: 24),
                  _EmailTextField(
                    emailFocusNode: _emailFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                  ),
                  _PasswordTextField(
                    passwordFocusNode: _passwordFocusNode,
                    passwordConfirmationFocusNode: _passwordConfirmationFocusNode,
                  ),
                  _PasswordConfirmationTextField(
                    passwordConfirmationFocusNode: _passwordConfirmationFocusNode,
                    nameFocusNode: _nameFocusNode,
                  ),
                  _NameTextField(
                    nameFocusNode: _nameFocusNode,
                  ),
                  const SizedBox(height: 16),
                  const _AvatarWidget(),
                ],
              ),
            ),
            const _RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // подписка на ошибку ввода почты с помощью BlocSelector
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.emailError;
          return TextField(
            // изменение фокуса поля ввода
            focusNode: _emailFocusNode,
            // логика ввода email
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationEmailChange(text)),
            // нажимаем на ОК после ввода email переходим на поле Пароль
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Почта',
              // вывод текста ошибки если неверно введена почта
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    Key? key,
    required FocusNode passwordFocusNode,
    required FocusNode passwordConfirmationFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        _passwordConfirmationFocusNode = passwordConfirmationFocusNode,
        super(key: key);

  final FocusNode _passwordFocusNode;
  final FocusNode _passwordConfirmationFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // подписка на ошибку ввода почты с помощью BlocSelector
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordError;
          return TextField(
            // изменение фокуса поля ввода
            focusNode: _passwordFocusNode,
            // логика ввода email
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationPasswordChange(text)),
            // нажимаем на ОК после ввода email переходим на поле Пароль
            onSubmitted: (_) => _passwordConfirmationFocusNode.requestFocus(),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Пароль',
              // вывод текста ошибки если неверно введена почта
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  const _PasswordConfirmationTextField({
    Key? key,
    required FocusNode passwordConfirmationFocusNode,
    required FocusNode nameFocusNode,
  })  :
        _passwordConfirmationFocusNode = passwordConfirmationFocusNode,
        _nameFocusNode = nameFocusNode,
        super(key: key);

  final FocusNode _passwordConfirmationFocusNode;
  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // подписка на ошибку ввода почты с помощью BlocSelector
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordConfirmationError;
          return TextField(
            // изменение фокуса поля ввода
            focusNode: _passwordConfirmationFocusNode,
            // логика ввода email
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationPasswordConfirmationChange(text)),
            // нажимаем на ОК после ввода email переходим на поле Пароль
            onSubmitted: (_) => _nameFocusNode.requestFocus(),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Пароль второй раз',
              // вывод текста ошибки если неверно введена почта
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    Key? key,
    required FocusNode nameFocusNode,
  })  :
        _nameFocusNode = nameFocusNode,
        super(key: key);

  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // подписка на ошибку ввода почты с помощью BlocSelector
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.nameError;
          return TextField(
            // изменение фокуса поля ввода
            focusNode: _nameFocusNode,
            // логика ввода email
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationNameChange(text)),
            // нажимаем на ОК после ввода email переходим на поле Пароль
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Имя и фамилия',
              // вывод текста ошибки если неверно введена почта
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(
        left: 8,
        top: 6,
        bottom: 6,
        right: 4,
      ),
      decoration: BoxDecoration(
        color: context.dynamicPlainColor(
          context: context,
          lightThemeColor: AppColors.lightLightBlue100,
          darkThemeColor: AppColors.darkWhite20,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          BlocBuilder<RegistrationBloc, RegistrationState>(
            buildWhen: (_, current) => current is RegistrationFieldsInfo,
            builder: (context, state) {
              final fieldsInfo = state as RegistrationFieldsInfo;
              return SvgPicture.network(
                fieldsInfo.avatarLink,
                height: 48,
                width: 48,
              );
            },
          ),
          const SizedBox(width: 8),
          Text('Ваш аватар', style: context.theme.h3),
          const SizedBox(width: 8),
          const Spacer(),
          TextButton(
            onPressed: () => context
                .read<RegistrationBloc>()
                .add(const RegistrationChangeAvatar()),
            child: const Text('Изменить'),
          ),
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        // 1) в BlocSelector проверяем на валидность, если все верно
        // то при нажатии на кнопку Войти переходим на дом. экран
        // 2) пока не веедена почта с паролем, то кнопка неактивна
        child: BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) => state is RegistrationInProgress,
          builder: (context, inProgress) {
            return ElevatedButton(
              // 1) передаем в bloc инфу о нажатии на кнопку
              // 2) read передает инфу в блок без подписки на изменение
              onPressed: inProgress
                  ? null
                  : () => context
                      .read<RegistrationBloc>()
                      .add(const RegistrationCreateAccount()),
              child: Text('Создать'),
            );
          },
        ),
      ),
    );
  }
}
