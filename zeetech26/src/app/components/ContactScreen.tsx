import { motion } from "motion/react";
import { Phone, Mail, MapPin, MessageCircle, Send } from "lucide-react";

export default function ContactScreen() {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-gradient-to-b from-blue-50 to-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-900 to-blue-700 text-white px-6 py-8">
        <motion.h1
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-3xl font-bold mb-2"
        >
          Contact Us
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="text-blue-100"
        >
          Let's start your digital journey
        </motion.p>
      </div>

      <div className="px-6 py-8 space-y-6">
        {/* Contact Cards */}
        <div className="grid grid-cols-1 gap-4">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.1 }}
            className="bg-white rounded-2xl p-6 shadow-lg border border-blue-100 flex items-center gap-4"
          >
            <div className="bg-gradient-to-br from-blue-600 to-blue-500 p-4 rounded-2xl">
              <Phone size={24} className="text-white" />
            </div>
            <div>
              <h3 className="font-bold text-gray-900">Phone</h3>
              <p className="text-blue-600">+1 (555) 123-4567</p>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2 }}
            className="bg-white rounded-2xl p-6 shadow-lg border border-blue-100 flex items-center gap-4"
          >
            <div className="bg-gradient-to-br from-blue-700 to-blue-600 p-4 rounded-2xl">
              <Mail size={24} className="text-white" />
            </div>
            <div>
              <h3 className="font-bold text-gray-900">Email</h3>
              <p className="text-blue-600">hello@zeetech.com</p>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.3 }}
            className="bg-white rounded-2xl p-6 shadow-lg border border-blue-100 flex items-center gap-4"
          >
            <div className="bg-gradient-to-br from-blue-800 to-blue-700 p-4 rounded-2xl">
              <MapPin size={24} className="text-white" />
            </div>
            <div>
              <h3 className="font-bold text-gray-900">Address</h3>
              <p className="text-gray-600">123 Tech Street, Silicon Valley, CA 94025</p>
            </div>
          </motion.div>
        </div>

        {/* Map Placeholder */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="bg-gradient-to-br from-blue-100 to-blue-50 rounded-3xl h-48 flex items-center justify-center border border-blue-200 shadow-lg overflow-hidden"
        >
          <div className="text-center">
            <MapPin size={48} className="text-blue-600 mx-auto mb-2" />
            <p className="text-gray-700 font-medium">Interactive Map</p>
          </div>
        </motion.div>

        {/* Contact Form */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-white rounded-3xl p-6 shadow-xl border border-blue-100"
        >
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Send us a Message</h2>
          <form className="space-y-4">
            <div>
              <label className="block text-gray-700 mb-2">Name</label>
              <input
                type="text"
                placeholder="Your name"
                className="w-full px-4 py-3 rounded-xl bg-blue-50 border border-blue-100 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20 transition-all"
              />
            </div>
            <div>
              <label className="block text-gray-700 mb-2">Email</label>
              <input
                type="email"
                placeholder="your@email.com"
                className="w-full px-4 py-3 rounded-xl bg-blue-50 border border-blue-100 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20 transition-all"
              />
            </div>
            <div>
              <label className="block text-gray-700 mb-2">Message</label>
              <textarea
                placeholder="Tell us about your project..."
                rows={4}
                className="w-full px-4 py-3 rounded-xl bg-blue-50 border border-blue-100 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500/20 transition-all resize-none"
              />
            </div>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              type="submit"
              className="w-full bg-gradient-to-r from-blue-600 to-blue-500 text-white py-4 rounded-xl font-semibold flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-shadow"
            >
              Send Message <Send size={20} />
            </motion.button>
          </form>
        </motion.div>

        {/* WhatsApp Quick Chat */}
        <motion.button
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.7 }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          className="w-full bg-gradient-to-r from-green-600 to-green-500 text-white py-4 rounded-2xl font-semibold flex items-center justify-center gap-3 shadow-lg"
        >
          <MessageCircle size={24} />
          Quick Chat on WhatsApp
        </motion.button>
      </div>
    </div>
  );
}
