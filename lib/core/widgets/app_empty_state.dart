import 'package:flutter/material.dart';
import 'package:nenas_kita/core/theme/app_colors.dart';
import 'package:nenas_kita/core/theme/app_spacing.dart';
import 'package:nenas_kita/core/theme/app_text_styles.dart';
import 'package:nenas_kita/core/widgets/app_button.dart';

/// Empty state display with optional CTA and fade-in animation
class AppEmptyState extends StatefulWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox,
    this.actionLabel,
    this.onAction,
    this.animate = true,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool animate;

  @override
  State<AppEmptyState> createState() => _AppEmptyStateState();
}

class _AppEmptyStateState extends State<AppEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppSpacing.animationNormal,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Responsive icon size based on screen width
  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 48;
    if (width < 480) return 64;
    return 72;
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = _getIconSize(context);

    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: AppSpacing.paddingL,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon with scale
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: iconSize + 32,
                    height: iconSize + 32,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: iconSize,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
                AppSpacing.vGapL,
                Text(
                  widget.title,
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.center,
                ),
                if (widget.message != null) ...[
                  AppSpacing.vGapS,
                  Text(
                    widget.message!,
                    style: AppTextStyles.bodyMediumDim,
                    textAlign: TextAlign.center,
                  ),
                ],
                if (widget.actionLabel != null && widget.onAction != null) ...[
                  AppSpacing.vGapXL,
                  AppButton(
                    onPressed: widget.onAction,
                    label: widget.actionLabel!,
                    isFullWidth: false,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty farms list
class NoFarmsEmpty extends StatelessWidget {
  const NoFarmsEmpty({
    super.key,
    this.onCreateFarm,
    this.isOwner = false,
  });

  final VoidCallback? onCreateFarm;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.agriculture,
      title: isOwner ? 'No Business Yet' : 'No Businesses Found',
      message: isOwner
          ? 'Create your business profile to start selling'
          : 'No businesses match your search criteria',
      actionLabel: isOwner ? 'Create Business' : null,
      onAction: isOwner ? onCreateFarm : null,
    );
  }
}

/// Empty products list
class NoProductsEmpty extends StatelessWidget {
  const NoProductsEmpty({
    super.key,
    this.onAddProduct,
    this.isOwner = false,
  });

  final VoidCallback? onAddProduct;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.inventory_2,
      title: isOwner ? 'No Products Yet' : 'No Products Found',
      message: isOwner
          ? 'Add your first product to start selling'
          : 'This business has no products available',
      actionLabel: isOwner ? 'Add Product' : null,
      onAction: isOwner ? onAddProduct : null,
    );
  }
}

/// Empty harvest plans list
class NoPlansEmpty extends StatelessWidget {
  const NoPlansEmpty({
    super.key,
    this.onAddPlan,
  });

  final VoidCallback? onAddPlan;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.calendar_month,
      title: 'No Harvest Plans',
      message: 'Create a harvest plan to track your crops',
      actionLabel: 'Add Plan',
      onAction: onAddPlan,
    );
  }
}

/// Empty buyer requests list
class NoRequestsEmpty extends StatelessWidget {
  const NoRequestsEmpty({
    super.key,
    this.onCreateRequest,
    this.isBuyer = true,
  });

  final VoidCallback? onCreateRequest;
  final bool isBuyer;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.shopping_bag,
      title: isBuyer ? 'No Requests Yet' : 'No Open Requests',
      message: isBuyer
          ? 'Post a request to find pineapple suppliers'
          : 'No buyer requests in your area right now',
      actionLabel: isBuyer ? 'New Request' : null,
      onAction: isBuyer ? onCreateRequest : null,
    );
  }
}

/// Empty search results
class NoSearchResults extends StatelessWidget {
  const NoSearchResults({
    super.key,
    this.query,
    this.onClearSearch,
  });

  final String? query;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: query != null
          ? 'No results for "$query". Try a different search term.'
          : 'No results match your search criteria',
      actionLabel: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// Empty announcements
class NoAnnouncementsEmpty extends StatelessWidget {
  const NoAnnouncementsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.campaign,
      title: 'No Announcements',
      message: 'There are no announcements at this time',
    );
  }
}

/// Empty notifications
class NoNotificationsEmpty extends StatelessWidget {
  const NoNotificationsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message: 'You\'re all caught up!',
    );
  }
}
