import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../models/booking_model.dart';
import '../services/booking_repository.dart';

class FeedbacksListBottomSheet extends StatelessWidget {
  const FeedbacksListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
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

          // Scrollable area
          Expanded(
            child: ValueListenableBuilder<List<BookingModel>>(
              valueListenable: BookingRepository().bookingsNotifier,
              builder: (context, bookings, child) {
                final ratedBookings = bookings
                    .where((b) => b.rating != null && b.rating! > 0)
                    .toList();

                // ── Empty state ───────────────────────────────────────
                if (ratedBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined,
                            size: 64, color: Colors.grey.shade300),
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

                // ── Compute averages ──────────────────────────────────
                final double avgRating = ratedBookings
                        .map((b) => b.rating!.toDouble())
                        .reduce((a, b) => a + b) /
                    ratedBookings.length;

                final starCounts = List.generate(5, (i) {
                  final star = 5 - i;
                  return ratedBookings
                      .where((b) => b.rating == star)
                      .length;
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Average Rating Banner ─────────────────────────
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1565C0).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ── Big numeric score + stars + count ──
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(5, (i) {
                                  final filled = (i + 1) <= avgRating;
                                  final halfFilled =
                                      !filled && (i < avgRating);
                                  return Icon(
                                    halfFilled
                                        ? Icons.star_half_rounded
                                        : Icons.star_rounded,
                                    size: 18,
                                    color: (filled || halfFilled)
                                        ? Colors.amber
                                        : Colors.white.withOpacity(0.35),
                                  );
                                }),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${ratedBookings.length} review${ratedBookings.length == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          // ── Per-star progress bars ──
                          Expanded(
                            child: Column(
                              children: List.generate(5, (i) {
                                final star = 5 - i;
                                final count = starCounts[i];
                                final fraction = ratedBookings.isEmpty
                                    ? 0.0
                                    : count / ratedBookings.length;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$star',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star_rounded,
                                          size: 12, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: fraction,
                                            minHeight: 7,
                                            backgroundColor:
                                                Colors.white.withOpacity(0.2),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.amber),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 18,
                                        child: Text(
                                          '$count',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Individual feedback cards ─────────────────────
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: ratedBookings.length,
                        itemBuilder: (context, index) {
                          final booking = ratedBookings[index];

                          // Mask email for privacy
                          String displayName = booking.customerName;
                          if (displayName.contains('@')) {
                            final parts = displayName.split('@');
                            if (parts[0].length > 3) {
                              displayName =
                                  '${parts[0].substring(0, 3)}***@${parts[1]}';
                            }
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.grey.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      children:
                                          List.generate(5, (starIndex) {
                                        final starValue = starIndex + 1;
                                        final isFilled = starValue <=
                                            (booking.rating ?? 0);
                                        return Icon(
                                          Icons.star_rounded,
                                          color: isFilled
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                if (booking.feedbackComment != null &&
                                    booking.feedbackComment!.isNotEmpty) ...[
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
