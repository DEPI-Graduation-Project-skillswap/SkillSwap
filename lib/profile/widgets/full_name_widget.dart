import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';
import 'package:skill_swap/widgets/default_text_form_fieled.dart';

class FullNameWidget extends StatefulWidget {
  const FullNameWidget({super.key});

  @override
  State<FullNameWidget> createState() => _FullNameWidgetState();
}

class _FullNameWidgetState extends State<FullNameWidget> {
  late TextEditingController _controller;
  bool _hasChangedByUser = false;

  @override
  void initState() {
    super.initState();
    final initialName = context.read<ProfileSetupCubit>().state.fullName;
    _controller = TextEditingController(text: initialName);

    // Set up listener to update state when controller changes
    _controller.addListener(_updateStateFromController);

    print("FullNameWidget initState: Initial name='${initialName}'"); // Debug
  }

  // Extract method for updating state from controller
  void _updateStateFromController() {
    final cubit = context.read<ProfileSetupCubit>();
    final newText = _controller.text;
    if (newText != cubit.state.fullName) {
      cubit.setFullName(newText);
      if (_controller.text.isNotEmpty) {
        setState(() {
          _hasChangedByUser = true;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentName = context.read<ProfileSetupCubit>().state.fullName;
    if (_controller.text != currentName && !_hasChangedByUser) {
      _controller.text = currentName;
    }
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
        Row(
          children: [
            Text('Full Name', style: Theme.of(context).textTheme.titleSmall),
            const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
          buildWhen:
              (previous, current) => previous.fullName != current.fullName,
          builder: (context, state) {
            // Debug the full name value
            debugPrint(
              'FullNameWidget build - state.fullName: "${state.fullName}"',
            );

            // Force a text controller update if state changed from elsewhere
            if (_controller.text != state.fullName && !_hasChangedByUser) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _controller.text = state.fullName;
                }
              });
            }

            return DefaultTextFormFieled(
              hintText: 'Enter your full name',
              label: 'Full Name',
              isPassword: false,
              controller: _controller,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Full name is required';
                }
                return null;
              },
            );
          },
        ),
        // Show confirmation that the name is saved to state
        BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
          builder: (context, state) {
            if (state.fullName.trim().isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Name saved: ${state.fullName}',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
