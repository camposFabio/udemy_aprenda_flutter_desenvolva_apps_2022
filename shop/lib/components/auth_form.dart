import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions.dart/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { signUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  AuthMode _authMode = AuthMode.login;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signUp;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Ocorreu um erro!'),
              content: Text(msg),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(
          email: _authData['email']!,
          password: _authData['password']!,
        );
      } else {
        await auth.signup(
          email: _authData['email']!,
          password: _authData['password']!,
        );
        // Registrar
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inexperado');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          height: _isLogin() ? 310 : 400,
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: (email) {
                    email = email ?? '';

                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  validator: (password) {
                    password = password ?? '';

                    if (password.isEmpty || password.length < 5) {
                      return 'Informe uma senha válida!';
                    }
                    return null;
                  },
                ),
                if (_isSignup())
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: _isLogin()
                        ? null
                        : (password) {
                            password = password ?? '';

                            if (password != _passwordController.text) {
                              return 'Senhas informadas não conferem';
                            }
                            return null;
                          },
                  ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.background,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8)),
                        child: Text(_authMode == AuthMode.login
                            ? 'ENTRAR'
                            : 'REGISTRAR'),
                      ),
                const Spacer(),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?')),
              ],
            ),
          )),
    );
  }
}
