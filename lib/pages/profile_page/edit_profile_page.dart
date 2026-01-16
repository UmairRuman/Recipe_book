// lib/pages/profile_page/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  static const pageAddress = '/edit-profile';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final profile = controller.userProfile.value;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(child: Text('No profile found')),
      );
    }

    // Initialize text controllers with current values
    controller.displayNameController.text = profile.displayName ?? '';
    controller.ageController.text = profile.age?.toString() ?? '';
    controller.heightController.text = profile.height?.toString() ?? '';
    controller.weightController.text = profile.weight?.toString() ?? '';

    final selectedGender = (profile.gender ?? 'male').obs;
    final selectedActivityLevel = (profile.activityLevel ?? 'moderate').obs;
    final selectedGoal = (profile.goal ?? 'general-health').obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: const Color(0xFF6B73FF),
        foregroundColor: Colors.white,
        actions: [
          Obx(() => TextButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => _saveProfile(
                          controller,
                          selectedGender.value,
                          selectedActivityLevel.value,
                          selectedGoal.value,
                        ),
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: controller.isLoading.value
                        ? Colors.white54
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _buildSectionTitle('Personal Information', Icons.person),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(
                  controller: controller.displayNameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  hint: 'Enter your full name',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.ageController,
                  label: 'Age',
                  icon: Icons.cake,
                  hint: 'Enter your age',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Gender',
                  icon: Icons.wc,
                  value: selectedGender,
                  items: const ['male', 'female', 'other', 'prefer-not-to-say'],
                  displayText: (value) => value.capitalize!,
                ),
              ]),

              const SizedBox(height: 24),

              // Physical Stats Section
              _buildSectionTitle('Physical Stats', Icons.monitor_weight),
              const SizedBox(height: 16),
              _buildCard([
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: controller.heightController,
                        label: 'Height (cm)',
                        icon: Icons.height,
                        hint: '170',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: controller.weightController,
                        label: 'Weight (kg)',
                        icon: Icons.monitor_weight_outlined,
                        hint: '70',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 24),

              // Activity & Goals Section
              _buildSectionTitle('Activity & Goals', Icons.fitness_center),
              const SizedBox(height: 16),
              _buildCard([
                _buildDropdown(
                  label: 'Activity Level',
                  icon: Icons.directions_run,
                  value: selectedActivityLevel,
                  items: const [
                    'sedentary',
                    'light',
                    'moderate',
                    'active',
                    'very-active'
                  ],
                  displayText: (value) => value.split('-').map((e) => e.capitalize).join(' '),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Health Goal',
                  icon: Icons.track_changes,
                  value: selectedGoal,
                  items: const [
                    'lose-weight',
                    'maintain',
                    'gain-weight',
                    'muscle-gain',
                    'general-health'
                  ],
                  displayText: (value) => value.split('-').map((e) => e.capitalize).join(' '),
                ),
              ]),

              const SizedBox(height: 24),

              // BMI & Calorie Info (Read-only)
              if (profile.height != null && profile.weight != null) ...[
                _buildSectionTitle('Health Metrics', Icons.analytics),
                const SizedBox(height: 16),
                _buildCard([
                  _buildInfoRow('BMI', '${profile.bmi?.toStringAsFixed(1) ?? 'N/A'} (${profile.bmiCategory ?? ''})'),
                  const Divider(height: 24),
                  _buildInfoRow('Daily Calorie Needs', '${profile.dailyCalorieNeeds?.toStringAsFixed(0) ?? 'N/A'} kcal'),
                ]),
              ],

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6B73FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6B73FF), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B73FF), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required Rx<T> value,
    required List<T> items,
    required String Function(T) displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<T>(
              value: value.value,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6B73FF), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(displayText(item)),
                      ))
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) value.value = newValue;
              },
            )),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _saveProfile(
    ProfileController controller,
    String gender,
    String activityLevel,
    String goal,
  ) async {
    await controller.updatePersonalInfo(
      displayName: controller.displayNameController.text.isEmpty
          ? null
          : controller.displayNameController.text,
      age: controller.ageController.text.isEmpty
          ? null
          : int.tryParse(controller.ageController.text),
      gender: gender,
      height: controller.heightController.text.isEmpty
          ? null
          : double.tryParse(controller.heightController.text),
      weight: controller.weightController.text.isEmpty
          ? null
          : double.tryParse(controller.weightController.text),
      activityLevel: activityLevel,
      goal: goal,
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    Get.back();
  }
}