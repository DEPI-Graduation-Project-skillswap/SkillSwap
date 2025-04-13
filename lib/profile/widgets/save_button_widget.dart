import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/widgets/default_eleveted_botton.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';

class SaveButtonWidget extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  
  const SaveButtonWidget({
    super.key,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        return DefaultElevetedBotton(
          onPressed: () {
            // First validate form if we have a form key
            bool formIsValid = true;
            if (formKey != null) {
              formIsValid = formKey!.currentState?.validate() ?? false;
            }
            
            // Get the latest state to validate
            final currentState = context.read<ProfileSetupCubit>().state;
            debugPrint('Validating - fullName: "${currentState.fullName}"');
            
            // List to track validation errors
            final List<String> validationErrors = [];
            
            // Check if full name is empty (use both form and state validation)
            if (!formIsValid || currentState.fullName.trim().isEmpty) {
              validationErrors.add('Please enter your full name');
              debugPrint('Full name validation failed');
            }
            
            // Check if skills are selected
            if (currentState.selectedOfferedSkills.isEmpty || currentState.selectedDesiredSkills.isEmpty) {
              validationErrors.add('Please select at least one skill to offer or learn');
            }
            
            // If there are validation errors, show them in a snackbar
            if (validationErrors.isNotEmpty) {
              ScaffoldMessenger.of(context).clearSnackBars(); // Clear any existing snackbars
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please correct the following:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ...validationErrors.map((error) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(error)),
                          ],
                        ),
                      )),
                    ],
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 4),
                ),
              );
              return;
            }
            
            // If validation passes, show success message and navigate
            ScaffoldMessenger.of(context).clearSnackBars(); // Clear any existing snackbars
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            
            Future.delayed(const Duration(milliseconds: 800), () {
              Navigator.pushNamed(context, '/home');
            });
          },
          text: 'Save & Continue',
        );
      },
    );
  }
}