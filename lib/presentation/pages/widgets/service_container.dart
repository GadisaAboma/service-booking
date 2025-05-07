import 'dart:io';
import 'package:flutter/material.dart';
import 'package:service_booking/domain/entities/service_entity.dart';

class ServiceContainer extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback onTap;
  final VoidCallback? onBookPressed;
  final VoidCallback? onDelete;

  const ServiceContainer({
    super.key,
    required this.service,
    required this.onTap,
    this.onBookPressed,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  _buildImageSection(context),
                  const SizedBox(width: 10),

                  // Content Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Category
                          _buildTitleSection(context),
                          const SizedBox(height: 6),

                          // Price and Rating
                          _buildPriceRatingSection(context),
                          const SizedBox(height: 8),

                          // Duration and Availability
                          _buildMetaSection(context),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Delete Button (if provided)
              if (onDelete != null) _buildDeleteButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.grey[50],
        child: Stack(
          children: [
            // Service Image or Placeholder
            if (service.imageUrl != null)
              Image.file(
                File(service.imageUrl!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            else
              Center(
                child: Icon(
                  Icons.photo_camera_back,
                  size: 32,
                  color: Colors.grey[300],
                ),
              ),

            // Unavailable Overlay
            if (!service.availability)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'UNAVAILABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            service.category,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRatingSection(BuildContext context) {
    return Row(
      children: [
        // Price
        Text(
          '\$${service.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/service',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const Spacer(),
        // Rating
        Row(
          children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 2),
            Text(
              service.rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaSection(BuildContext context) {
    return Row(
      children: [
        _buildMetaItem(
          icon: Icons.access_time,
          text: '${service.duration} mins',
          color: Colors.grey[700],
        ),
        const SizedBox(width: 12),
        _buildMetaItem(
          icon: Icons.calendar_today,
          text: service.availability ? 'Available' : 'Unavailable',
          color: service.availability ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: color ?? Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () => _showDeleteConfirmationDialog(context),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.delete_outline,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Delete Service',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to delete this service? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
