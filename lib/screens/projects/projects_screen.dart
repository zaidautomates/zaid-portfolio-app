import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/app_backdrop.dart';
import '../../widgets/common/glass_card.dart';

import '../../widgets/common/app_error_view.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/projects/project_card.dart';
import '../../widgets/common/app_page_header.dart';
import '../../widgets/common/skeleton_loader.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final isLoading = portfolioProvider.status == PortfolioStatus.loading;



    if (portfolioProvider.status == PortfolioStatus.error) {
      return Scaffold(
        body: Stack(
          children: [
            const AppBackdrop(),
            AppErrorView(
              errorMessage: portfolioProvider.errorMessage ?? 'Failed to load projects.',
              onRetry: () => portfolioProvider.fetchPortfolioData(),
            ),
          ],
        ),
      );
    }

    // Generate categories dynamically from the loaded project list
    final projectCategories = portfolioProvider.projects.map((p) => p.category).toSet().toList();
    final categories = ['All', ...projectCategories];

    // Apply combined filters
    final query = _searchQuery.trim().toLowerCase();
    final filteredProjects = portfolioProvider.projects.where((project) {
      final matchesCategory = _selectedCategory == 'All' || project.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.category.toLowerCase().contains(query) ||
          project.technologies.any((tech) => tech.toLowerCase().contains(query));
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => portfolioProvider.fetchPortfolioData(),
              color: AppColors.purple,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppPageHeader(
                      title: 'Projects',
                      subtitle: 'API-powered software portfolio works',
                      profileImageUrl: portfolioProvider.user?.profileImage ?? '',
                    ),
                    const SizedBox(height: 22),

                    // Search Bar
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      radius: 20,
                      child: TextField(
                        enabled: !isLoading,
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: TextStyle(color: context.primaryText),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: AppColors.cyan),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppColors.purple),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          hintText: 'Search title, tech, description...',
                          hintStyle: TextStyle(color: context.mutedText),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    if (isLoading) ...[
                      const SizedBox(height: 20),
                      const SkeletonProjectCard(),
                      const SizedBox(height: 14),
                      const SkeletonProjectCard(),
                      const SizedBox(height: 14),
                      const SkeletonProjectCard(),
                    ] else ...[
                      // Category Filtering Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: categories.map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  cat,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : context.primaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCategory = cat;
                                    });
                                  }
                                },
                                selectedColor: AppColors.purple,
                                backgroundColor: context.isDarkPortfolio
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.black.withOpacity(0.03),
                                side: BorderSide(
                                  color: isSelected ? Colors.transparent : context.cardBorder,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Project Listing or Empty State
                      if (filteredProjects.isEmpty)
                        const AppEmptyState(
                          icon: Icons.search_off_outlined,
                          title: 'No Projects Found',
                          message: 'Try adjusting your search query or category filter.',
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProjects.length,
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: ProjectCard(project: project),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
