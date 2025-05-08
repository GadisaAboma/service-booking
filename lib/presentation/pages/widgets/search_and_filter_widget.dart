import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:service_booking/presentation/controllers/service_controller.dart';
import 'package:service_booking/presentation/pages/widgets/filter_dialog_theme.dart';

class SearchAndFilterBar extends StatelessWidget {
  final ServiceController controller;
  final List<String> categories;

  const SearchAndFilterBar({
    super.key,
    required this.controller,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar with Debounce
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: 'Search services...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller.searchController,
                builder: (context, value, _) {
                  return value.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.searchDebouncer.value = '';
                        },
                      )
                      : const SizedBox();
                },
              ),
            ),
            onChanged: (value) {
              controller.searchDebouncer.value = value;
            },
          ),
        ),

        // Filter Chips
        SizedBox(
          height: 60,
          child: Obx(() {
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryFilter(context),
                const SizedBox(width: 8),
                _buildPriceFilter(context),
                const SizedBox(width: 8),
                _buildRatingFilter(context),
                if (controller.hasFilters) ...[
                  const SizedBox(width: 8),
                  _buildClearAllButton(),
                ],
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return FilterChip(
      label: const Text('Categories'),
      selected: controller.selectedCategories.isNotEmpty,
      onSelected: (_) => _showCategoryDialog(context),
      backgroundColor: Colors.white,
      selectedColor: FilterDialogTheme.selectedColor.withValues(alpha: 0.2),
      checkmarkColor: FilterDialogTheme.selectedColor,
      labelStyle: TextStyle(
        color:
            controller.selectedCategories.isNotEmpty
                ? FilterDialogTheme.selectedColor
                : Colors.grey[700],
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color:
              controller.selectedCategories.isNotEmpty
                  ? FilterDialogTheme.selectedColor
                  : Colors.grey[300]!,
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(dialogTheme: FilterDialogTheme.dialogTheme(context)),
          child: AlertDialog(
            title: Text(
              'Select Categories',
              style: FilterDialogTheme.titleStyle,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    categories.map((category) {
                      return Obx(() {
                        final isSelected = controller.selectedCategories
                            .contains(category);
                        return ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color:
                                isSelected
                                    ? FilterDialogTheme.selectedColor
                                    : Colors.grey,
                          ),
                          title: Text(
                            category,
                            style: FilterDialogTheme.optionStyle,
                          ),
                          onTap: () {
                            if (isSelected) {
                              controller.selectedCategories.remove(category);
                            } else {
                              controller.selectedCategories.add(category);
                            }
                            controller.applyFilters();
                          },
                        );
                      });
                    }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceFilter(BuildContext context) {
    return FilterChip(
      label: Obx(() {
        return Text(
          controller.minPrice.value != null || controller.maxPrice.value != null
              ? 'Price: \$${controller.minPrice.value?.toStringAsFixed(0) ?? ''}'
                  ' - \$${controller.maxPrice.value?.toStringAsFixed(0) ?? ''}'
              : 'Price',
        );
      }),
      selected:
          controller.minPrice.value != null ||
          controller.maxPrice.value != null,
      onSelected: (_) => _showPriceDialog(context),
      backgroundColor: Colors.white,
      selectedColor: FilterDialogTheme.selectedColor.withValues(alpha: 0.2),
      checkmarkColor: FilterDialogTheme.selectedColor,
      labelStyle: TextStyle(
        color:
            controller.minPrice.value != null ||
                    controller.maxPrice.value != null
                ? FilterDialogTheme.selectedColor
                : Colors.grey[700],
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color:
              controller.minPrice.value != null ||
                      controller.maxPrice.value != null
                  ? FilterDialogTheme.selectedColor
                  : Colors.grey[300]!,
        ),
      ),
    );
  }

  void _showPriceDialog(BuildContext context) {
    final minController = TextEditingController(
      text: controller.minPrice.value?.toStringAsFixed(0) ?? '',
    );
    final maxController = TextEditingController(
      text: controller.maxPrice.value?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(dialogTheme: FilterDialogTheme.dialogTheme(context)),
          child: AlertDialog(
            title: Text(
              'Price Range(ETB)',
              style: FilterDialogTheme.titleStyle,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: minController,
                  decoration: const InputDecoration(
                    labelText: 'Minimum Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: maxController,
                  decoration: const InputDecoration(
                    labelText: 'Maximum Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.minPrice.value = double.tryParse(
                    minController.text,
                  );
                  controller.maxPrice.value = double.tryParse(
                    maxController.text,
                  );
                  controller.applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingFilter(BuildContext context) {
    return FilterChip(
      label: Obx(() {
        return Text(
          controller.minRating.value != null
              ? 'Rating: ${controller.minRating.value?.toStringAsFixed(1)}+'
              : 'Rating',
        );
      }),
      selected: controller.minRating.value != null,
      onSelected: (_) => _showRatingDialog(context),
      backgroundColor: Colors.white,
      selectedColor: FilterDialogTheme.selectedColor.withValues(alpha: 0.2),
      checkmarkColor: FilterDialogTheme.selectedColor,
      labelStyle: TextStyle(
        color:
            controller.minRating.value != null
                ? FilterDialogTheme.selectedColor
                : Colors.grey[700],
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color:
              controller.minRating.value != null
                  ? FilterDialogTheme.selectedColor
                  : Colors.grey[300]!,
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(dialogTheme: FilterDialogTheme.dialogTheme(context)),
          child: AlertDialog(
            title: Text('Minimum Rating', style: FilterDialogTheme.titleStyle),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    return Slider(
                      value: controller.minRating.value ?? 0,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: (controller.minRating.value ?? 0).toStringAsFixed(
                        1,
                      ),
                      activeColor: FilterDialogTheme.selectedColor,
                      inactiveColor: Colors.grey[200],
                      onChanged: (value) {
                        controller.minRating.value = value;
                      },
                    );
                  }),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${(controller.minRating.value ?? 0).toStringAsFixed(1)}+',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClearAllButton() {
    return ActionChip(
      label: const Text('Clear all'),
      onPressed: () {
        controller.clearAllFilters();
      },
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey[700]),
      shape: StadiumBorder(side: BorderSide(color: Colors.grey[300]!)),
    );
  }
}
