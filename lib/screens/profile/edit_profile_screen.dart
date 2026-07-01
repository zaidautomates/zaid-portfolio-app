import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _taglineController;
  late final TextEditingController _aboutController;
  late final TextEditingController _educationController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _githubController;
  late final TextEditingController _websiteController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<PortfolioProvider>().user;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _roleController = TextEditingController(text: user?.role ?? '');
    _taglineController = TextEditingController(text: user?.tagline ?? '');
    _aboutController = TextEditingController(text: user?.about ?? '');
    _educationController = TextEditingController(text: user?.education ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _linkedinController = TextEditingController(text: user?.linkedin ?? '');
    _githubController = TextEditingController(text: user?.github ?? '');
    _websiteController = TextEditingController(text: user?.website ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _taglineController.dispose();
    _aboutController.dispose();
    _educationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      
      final portfolioProvider = context.read<PortfolioProvider>();

      // Update profile info on backend
      final profileSuccess = await portfolioProvider.updateProfile(
        name: _nameController.text.trim(),
        role: _roleController.text.trim(),
        tagline: _taglineController.text.trim(),
        about: _aboutController.text.trim(),
        education: _educationController.text.trim(),
      );

      // Update contact & social links on backend
      final contactSuccess = await portfolioProvider.updateContact(
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        github: _githubController.text.trim(),
        website: _websiteController.text.trim(),
      );

      setState(() => _isSaving = false);

      if (profileSuccess && contactSuccess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully on server!'),
            backgroundColor: AppColors.purple,
          ),
        );
        Navigator.of(context).pop();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(portfolioProvider.errorMessage ?? 'Failed to save changes.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Edit Profile Details',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Basic Details', style: TextStyle(color: context.primaryText, fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(height: 24, color: Colors.white24),
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _roleController,
                            label: 'Professional Role',
                            icon: Icons.work_outline,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Role is required' : null,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _taglineController,
                            label: 'Tagline / Banner Quote',
                            icon: Icons.chat_bubble_outline,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Tagline is required' : null,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _aboutController,
                            label: 'Biography / About',
                            icon: Icons.info_outline,
                            maxLines: 4,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Bio is required' : null,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _educationController,
                            label: 'Education',
                            icon: Icons.school_outlined,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Education is required' : null,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 24),
                          Text('Contact & Location', style: TextStyle(color: context.primaryText, fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(height: 24, color: Colors.white24),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Email is required' : null,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Phone number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _locationController,
                            label: 'Location (City, State)',
                            icon: Icons.location_on_outlined,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 24),
                          Text('Social Media Links', style: TextStyle(color: context.primaryText, fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(height: 24, color: Colors.white24),
                          _buildTextField(
                            controller: _linkedinController,
                            label: 'LinkedIn profile link',
                            icon: Icons.link_rounded,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _githubController,
                            label: 'GitHub profile link',
                            icon: Icons.code_rounded,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _websiteController,
                            label: 'Personal Website URL',
                            icon: Icons.language_rounded,
                            enabled: !_isSaving,
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: context.cardBorder),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: context.primaryText),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: _isSaving ? null : _save,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text('Save Changes'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          key: ValueKey('lbl_$label'),
          style: TextStyle(
            color: context.softText,
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          style: TextStyle(color: context.primaryText),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.cyan),
            filled: true,
            fillColor: context.isDarkPortfolio
                ? Colors.white.withOpacity(0.04)
                : Colors.black.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.cyan, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
