import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';
import 'package:skill_swap/widgets/default_text_form_fieled.dart';

class BioWidget extends StatefulWidget {
  const BioWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BioWidgetState createState() => _BioWidgetState();
}

class _BioWidgetState extends State<BioWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      context.read<ProfileSetupCubit>().setBio(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bio', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        DefaultTextFormFieled(
          hintText: 'Brief description about yourself',
          label: 'Bio',
          isPassword: false,
          controller: _controller,
        ),
      ],
    );
  }
}
