import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { X, MessageCircle, User, Phone, Mail, MapPin, FileText } from "lucide-react";

interface BookingFormScreenProps {
  isOpen: boolean;
  onClose: () => void;
  serviceName?: string;
}

export default function BookingFormScreen({
  isOpen,
  onClose,
  serviceName = "Service",
}: BookingFormScreenProps) {
  const [formData, setFormData] = useState({
    service: serviceName,
    name: "",
    phone: "",
    email: "",
    address: "",
    message: "",
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    // Create WhatsApp message
    const message = `
🔧 *New Service Booking Request*

*Service:* ${formData.service}
*Name:* ${formData.name}
*Phone:* ${formData.phone}
*Email:* ${formData.email || "Not provided"}
*Address:* ${formData.address}
*Additional Details:* ${formData.message || "None"}

Thank you for choosing ZEETECH Technical Services!
    `.trim();

    const whatsappUrl = `https://wa.me/923001234567?text=${encodeURIComponent(message)}`;
    window.open(whatsappUrl, "_blank");
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

          {/* Modal */}
          <motion.div
            initial={{ opacity: 0, y: 100 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 100 }}
            className="fixed inset-x-0 bottom-0 bg-white rounded-t-3xl shadow-2xl z-50 max-h-[90vh] overflow-y-auto"
          >
            {/* Header */}
            <div className="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between rounded-t-3xl">
              <h2 className="text-2xl font-bold text-[#0A1628]">Book Service</h2>
              <button
                onClick={onClose}
                className="p-2 hover:bg-gray-100 rounded-full transition-colors"
              >
                <X size={24} className="text-gray-500" />
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="px-6 py-6 space-y-5">
              {/* Service Name */}
              <div>
                <label className="flex items-center gap-2 text-gray-700 mb-2 font-medium">
                  <FileText size={18} className="text-[#0057FF]" />
                  Service
                </label>
                <input
                  type="text"
                  value={formData.service}
                  onChange={(e) => setFormData({ ...formData, service: e.target.value })}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all"
                  readOnly
                />
              </div>

              {/* Full Name */}
              <div>
                <label className="flex items-center gap-2 text-gray-700 mb-2 font-medium">
                  <User size={18} className="text-[#0057FF]" />
                  Full Name *
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="Enter your full name"
                  required
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all"
                />
              </div>

              {/* Phone Number */}
              <div>
                <label className="flex items-center gap-2 text-gray-700 mb-2 font-medium">
                  <Phone size={18} className="text-[#0057FF]" />
                  Phone Number *
                </label>
                <input
                  type="tel"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="03XX-XXXXXXX"
                  required
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all"
                />
              </div>

              {/* Email (Optional) */}
              <div>
                <label className="flex items-center gap-2 text-gray-700 mb-2 font-medium">
                  <Mail size={18} className="text-gray-400" />
                  Email (Optional)
                </label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  placeholder="your@email.com"
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all"
                />
              </div>

              {/* Address */}
              <div>
                <label className="flex items-center gap-2 text-gray-700 mb-2 font-medium">
                  <MapPin size={18} className="text-[#0057FF]" />
                  Address/Location *
                </label>
                <input
                  type="text"
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  placeholder="Enter your address"
                  required
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all"
                />
              </div>

              {/* Additional Message */}
              <div>
                <label className="flex items-center gap-2 text-gray-700 mb-2 font-medium">
                  <MessageCircle size={18} className="text-gray-400" />
                  Additional Message (Optional)
                </label>
                <textarea
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  placeholder="Any specific details or requirements..."
                  rows={3}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#0057FF] focus:outline-none focus:ring-2 focus:ring-[#0057FF]/20 transition-all resize-none"
                />
              </div>

              {/* Submit Button */}
              <motion.button
                type="submit"
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className="w-full bg-[#25D366] text-white py-4 rounded-xl font-bold shadow-lg flex items-center justify-center gap-3 text-lg"
              >
                <MessageCircle size={24} />
                Send via WhatsApp
              </motion.button>
            </form>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
