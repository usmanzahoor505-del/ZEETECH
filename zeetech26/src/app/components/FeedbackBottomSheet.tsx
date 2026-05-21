import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { X, Star, Send } from "lucide-react";

interface FeedbackBottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function FeedbackBottomSheet({ isOpen, onClose }: FeedbackBottomSheetProps) {
  const [rating, setRating] = useState(0);
  const [hoveredRating, setHoveredRating] = useState(0);
  const [feedback, setFeedback] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    // Here you would typically send the feedback to your backend
    console.log("Feedback submitted:", { rating, feedback });

    // Reset form
    setRating(0);
    setFeedback("");
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50"
          />

          {/* Bottom Sheet */}
          <motion.div
            initial={{ opacity: 0, y: 100 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 100 }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="fixed inset-x-0 bottom-0 bg-white rounded-t-3xl shadow-2xl z-50"
          >
            {/* Header */}
            <div className="border-b border-gray-200 px-6 py-4 flex items-center justify-between rounded-t-3xl">
              <h2 className="text-2xl font-bold text-[#0A1628]">Share Your Feedback</h2>
              <button
                onClick={onClose}
                className="p-2 hover:bg-gray-100 rounded-full transition-colors"
              >
                <X size={24} className="text-gray-500" />
              </button>
            </div>

            {/* Content */}
            <form onSubmit={handleSubmit} className="px-6 py-6 space-y-6">
              {/* Star Rating */}
              <div>
                <label className="block text-gray-700 mb-3 font-medium text-center">
                  How was your experience?
                </label>
                <div className="flex items-center justify-center gap-2">
                  {[1, 2, 3, 4, 5].map((star) => (
                    <motion.button
                      key={star}
                      type="button"
                      whileHover={{ scale: 1.2 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setRating(star)}
                      onMouseEnter={() => setHoveredRating(star)}
                      onMouseLeave={() => setHoveredRating(0)}
                      className="focus:outline-none"
                    >
                      <Star
                        size={48}
                        className={`transition-all ${
                          star <= (hoveredRating || rating)
                            ? "text-yellow-400 fill-yellow-400"
                            : "text-gray-300"
                        }`}
                      />
                    </motion.button>
                  ))}
                </div>
                {rating > 0 && (
                  <motion.p
                    initial={{ opacity: 0, y: -10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="text-center text-gray-600 mt-2"
                  >
                    {rating === 1 && "Poor"}
                    {rating === 2 && "Fair"}
                    {rating === 3 && "Good"}
                    {rating === 4 && "Very Good"}
                    {rating === 5 && "Excellent!"}
                  </motion.p>
                )}
              </div>

              {/* Text Input */}
              <div>
                <label className="block text-gray-700 mb-2 font-medium">
                  Share your experience (Optional)
                </label>
                <textarea
                  value={feedback}
                  onChange={(e) => setFeedback(e.target.value)}
                  placeholder="Tell us what you think about our service..."
                  rows={4}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all resize-none"
                />
              </div>

              {/* Submit Button */}
              <motion.button
                type="submit"
                disabled={rating === 0}
                whileHover={{ scale: rating > 0 ? 1.02 : 1 }}
                whileTap={{ scale: rating > 0 ? 0.98 : 1 }}
                className={`w-full py-4 rounded-xl font-bold shadow-lg flex items-center justify-center gap-2 text-lg transition-all ${
                  rating > 0
                    ? "bg-gradient-to-r from-[#0057FF] to-[#00C2FF] text-white"
                    : "bg-gray-200 text-gray-400 cursor-not-allowed"
                }`}
              >
                <Send size={20} />
                Submit Feedback
              </motion.button>
            </form>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
