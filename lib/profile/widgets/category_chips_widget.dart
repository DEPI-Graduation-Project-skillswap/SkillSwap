import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/app_theme.dart';
import 'package:skill_swap/profile/cubits/profile_setup_cubit.dart';

class CategoryChipsWidget extends StatelessWidget {
  const CategoryChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Categories',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.skillCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        backgroundColor: Apptheme.darkGray,
                        labelStyle: const TextStyle(color: Apptheme.primaryColor),
                        side: BorderSide(color: Apptheme.primaryColor.withOpacity(0.3)),
                        label: Text(category.name),
                        onPressed: () {
                          context.read<ProfileSetupCubit>().filterByCategory(category.name);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Showing ${category.name} skills'),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Clear Filter',
                                onPressed: () {
                                  context.read<ProfileSetupCubit>().filterByCategory('');
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}