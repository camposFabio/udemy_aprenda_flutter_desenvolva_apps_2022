import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
  });

  final void Function(AuthFormData) onSubmit;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_formData.image == null && _formData.isSignUp) {
      return _showError('Imagem não selecionada!');
    }

    widget.onSubmit(_formData);
  }

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_formData.isSignUp)
                UserImagePicker(
                  onImagePick: _handleImagePick,
                ),
              if (_formData.isSignUp)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _formData.name,
                  onChanged: (name) => _formData.name = name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (name) {
                    name = name ?? '';
                    if (name.trim().length < 5) {
                      return 'Nome deve ter no mínimo 5 caracteres';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _formData.email,
                onChanged: (email) => _formData.email = email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                validator: (email) {
                  email = email ?? '';
                  if (!email.contains('@')) {
                    return 'E-mail informado não é válido!';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _formData.password,
                onChanged: (password) => _formData.password = password,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (password) {
                  password = password ?? '';
                  if (password.trim().length < 6) {
                    return 'Senha deve ter no mínimo 6 caracteres!';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formData.toggleAuthMode();
                  });
                },
                child: Text(_formData.isLogin
                    ? 'Criar uma nova conta?'
                    : 'Já possui conta?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
