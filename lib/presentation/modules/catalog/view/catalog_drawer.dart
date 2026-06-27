import 'package:api_demo/presentation/modules/categories/controller/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/AppTheme.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../data/datasources/local/setting_box.dart';
import '../../../../data/datasources/local/hiveToken.dart';
import '../../../../core/routes/app_pages.dart';

class CatalogDrawer extends GetView<CategoriesController> {
  const CatalogDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      child: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Column(
              children: [_buildHeader(), _buildSkeletonBody(), _buildFooter()],
            );
          }
          if (controller.errorMessage.value.isNotEmpty) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.loadCategories(),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            );
          }
          return Column(
            children: [_buildHeader(), _buildBody(), _buildFooter()],
          );
        }),
      ),
    );
  }

  // Drawer Header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.productCategory,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: AppTheme.neutralColor,
            ),
          ),
        ],
      ),
    );
  }

  // Skeleton loading body
  Widget _buildSkeletonBody() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: 8,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              leading: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              title: Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Drawer Body (Category list)
  Widget _buildBody() {
    return Expanded(
      child: Obx(() {
        final categories = controller.categories;
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // All Category option
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              leading: Icon(
                Icons.grid_view_rounded,
                size: 20,
                color: controller.selectedCategoryId.value == 0
                    ? AppTheme.primaryColor
                    : AppTheme.neutralColor,
              ),
              title: Text(
                AppStrings.allProducts,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13,
                  fontWeight: controller.selectedCategoryId.value == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: controller.selectedCategoryId.value == 0
                      ? AppTheme.primaryColor
                      : AppTheme.onSurface,
                ),
              ),
              selected: controller.selectedCategoryId.value == 0,
              selectedTileColor: AppTheme.primaryColor.withOpacity(0.08),
              onTap: () {
                controller.setSelectedCategoryId(0);
                Get.back();
              },
            ),
            const Divider(height: 1),
            ...categories.map((category) {
              final isSelected =
                  controller.selectedCategoryId.value == category.id;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                leading: Icon(
                  Icons.label_outline_rounded,
                  size: 20,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.neutralColor,
                ),
                title: Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.onSurface,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: AppTheme.primaryColor.withOpacity(0.08),
                onTap: () {
                  controller.setSelectedCategoryId(category.id);
                  Get.back();
                },
              );
            }),
          ],
        );
      }),
    );
  }

  // Drawer Footer (Logout option)
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: const Icon(
          Icons.logout_rounded,
          color: AppTheme.errorColor,
          size: 20,
        ),
        title: const Text(
          AppStrings.logout,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 13,
            color: AppTheme.errorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          SettingBox.loginStatus = false;
          Get.find<HiveToken>().saveToken('');
          Get.offAllNamed(Routes.login);
        },
      ),
    );
  }
}
