import 'package:flutter/material.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_input_name_form.dart';

class OnboardingInputNameContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const OnboardingInputNameContent({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  State<OnboardingInputNameContent> createState() =>
      _OnboardingInputNameContentState();
}

class _OnboardingInputNameContentState
    extends State<OnboardingInputNameContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onNameChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Siapa nama Anda?',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Form(
            key: widget.formKey,
            child: Column(
              children: [CustomInputNameForm(controller: _controller)],
            ),
          ),
        ],
      ),
    );
  }
}
