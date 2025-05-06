import 'dart:io';
import 'package:flutter/material.dart';
import 'package:service_booking/domain/entities/service_entity.dart';

class ServiceContainer extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback onTap;
  final VoidCallback? onBookPressed;

  const ServiceContainer({
    super.key,
    required this.service,
    required this.onTap,
    this.onBookPressed,
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
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left-aligned image (smaller)
              _buildImageSection(context),
              const SizedBox(width: 10),

              // Right content section (more compact)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and category
                      _buildTitleSection(context),
                      const SizedBox(height: 6),

                      // Price and rating
                      _buildPriceRatingSection(context),
                      const SizedBox(height: 8),

                      // Metadata
                      _buildMetaSection(context),
                      const SizedBox(height: 8),

                      // Book button
                      if (onBookPressed != null) _buildBookButton(context),
                    ],
                  ),
                ),
              ),
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
        width: 100, // Smaller width
        height: 100, // Square aspect ratio
        color: Colors.grey[50],
        child: Stack(
          children: [
            if (service.imageUrl != null)
              Image.file(
                File(service.imageUrl!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

            if (service.imageUrl == null)
              Center(
                child: Icon(
                  Icons.photo_camera_back,
                  size: 32, // Smaller icon
                  color: Colors.grey[300],
                ),
              ),

            // Rating badge (smaller)
            // Positioned(
            //   top: 6,
            //   right: 6,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            //     decoration: BoxDecoration(
            //       color: Colors.black.withOpacity(0.7),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const Icon(Icons.star, size: 12, color: Colors.amber),
            //         const SizedBox(width: 2),
            //         Text(
            //           service.rating.toStringAsFixed(1),
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontSize: 10, // Smaller font
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Unavailable overlay (smaller)
            if (!service.availability)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(color: Colors.red[600]),
                    child: const Text(
                      'UNAVAILABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9, // Smaller font
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            service.name,
            style: const TextStyle(
              fontSize: 14, // Smaller font
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            service.category,
            style: TextStyle(
              fontSize: 10, // Smaller font
              fontWeight: FontWeight.w500,
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
        // Price (smaller)
        Text(
          '\$${service.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16, // Smaller font
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/service',
          style: TextStyle(
            fontSize: 12, // Smaller font
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        // Rating (smaller)
        Row(
          children: [
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 2),
            Text(
              service.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12, // Smaller font
                fontWeight: FontWeight.w600,
              ),
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
          size: 14, // Smaller icon
          text: '${service.duration} mins',
          fontSize: 11, // Smaller font
        ),
        const SizedBox(width: 12),
        _buildMetaItem(
          icon: Icons.calendar_today,
          size: 14, // Smaller icon
          text: service.availability ? 'Available' : 'Unavailable',
          fontSize: 11, // Smaller font
          color: service.availability ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String text,
    double size = 16,
    double fontSize = 13,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: size, color: color ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color ?? Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return SizedBox(
      height: 32, // Smaller button
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        onPressed: service.availability ? onBookPressed : null,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_online, size: 14), // Smaller icon
            SizedBox(width: 4),
            Text(
              'Book Now',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12, // Smaller font
              ),
            ),
          ],
        ),
      ),
    );
  }
}
