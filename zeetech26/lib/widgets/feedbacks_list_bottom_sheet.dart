import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/booking_model.dart';
import '../services/booking_repository.dart';

class FeedbacksListBottomSheet extends StatelessWidget {
  const FeedbacksListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Feedbacks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'What our clients say about us',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Scrollable list
          Expanded(
            child: ValueListenableBuilder<List<BookingModel>>(
              valueListenable: BookingRepository().bookingsNotifier,
              builder: (context, bookings, child) {
                final ratedBookings = bookings
                    .where((b) => b.rating != null && b.rating! > 0)
                    .toList();

                if (ratedBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text(
                          'No feedbacks yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Feedback from satisfied clients will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: ratedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = ratedBookings[index];
                    
                    // Mask email for client privacy if name is an email
                    String displayName = booking.customerName;
                    if (displayName.contains('@')) {
                      final parts = displayName.split('@');
                      if (parts[0].length > 3) {
                        displayName = '${parts[0].substring(0, 3)}***@${parts[1]}';
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      booking.serviceName,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  final starValue = starIndex + 1;
                                  final isFilled = starValue <= (booking.rating ?? 0);
                                  return Icon(
                                    Icons.star_rounded,
                                    color: isFilled ? Colors.amber : Colors.grey.shade300,
                                    size: 16,
                                  );
                                }),
                              ),
                            ],
                          ),
                          if (booking.feedbackComment != null && booking.feedbackComment!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              '"${booking.feedbackComment}"',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textDark,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
