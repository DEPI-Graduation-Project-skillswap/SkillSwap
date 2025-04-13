import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';
import 'package:skill_swap/profile/views/profile_page.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart'; // Import custom styled button

class SaveButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SaveButtonWidget({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
      listener: (context, state) {
        if (!state.isLoading && state.errorMessage.isEmpty && _justSaved) {
          _justSaved = false;

          Navigator.pushReplacementNamed(
            context,
            ProfilePage.routeName,
            arguments: state,
          );
        } else if (state.errorMessage.isNotEmpty && _justSaved) {
          _justSaved = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Save Failed: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return DefaultElevetedBotton(
          icon: state.isLoading ? null : Icons.save,
          text: state.isLoading ? 'Saving...' : 'Save Profile',
          onPressed: state.isLoading
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    _justSaved = true;
                    context.read<ProfileSetupCubit>().saveProfile();
                  }
                },
          child: state.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : null,
        );
      },
    );
  }
}

bool _justSaved = false;
