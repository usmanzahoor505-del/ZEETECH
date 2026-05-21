import { motion } from "motion/react";
import { Phone, Mail, MapPin, MessageCircle, Facebook, Instagram } from "lucide-react";
import { TbBrandTiktok } from "react-icons/tb";

export default function ZeetechContactScreen() {
  const handlePhoneCall = () => {
    window.location.href = "tel:+923001234567";
  };

  const handleWhatsApp = () => {
    window.open("https://wa.me/923001234567?text=Hello%20ZEETECH!", "_blank");
  };

  const handleEmail = () => {
    window.location.href = "mailto:info@zeetech.pk";
  };

  return (
    <div className="h-full overflow-y-auto pb-20 bg-[#F5F7FA]">
      {/* Header */}
      <div className="bg-gradient-to-br from-[#0A1628] to-[#0D1B2A] text-white px-6 py-8">
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
          className="text-white/80"
        >
          We're here to help 24/7
        </motion.p>
      </div>

      <div className="px-6 py-8 space-y-6">
        {/* Contact Cards */}
        <div className="space-y-4">
          {/* Phone Card */}
          <motion.button
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.1 }}
            onClick={handlePhoneCall}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="w-full bg-white rounded-2xl p-6 shadow-lg border border-gray-100 flex items-center gap-4 text-left"
          >
            <div className="bg-gradient-to-br from-[#0057FF] to-[#00C2FF] p-4 rounded-2xl">
              <Phone size={28} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-[#0A1628] mb-1">Phone</h3>
              <p className="text-[#0057FF] font-semibold">+92 300 1234567</p>
              <p className="text-gray-500 text-sm">Tap to call</p>
            </div>
          </motion.button>

          {/* WhatsApp Card */}
          <motion.button
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2 }}
            onClick={handleWhatsApp}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="w-full bg-white rounded-2xl p-6 shadow-lg border border-gray-100 flex items-center gap-4 text-left"
          >
            <div className="bg-[#25D366] p-4 rounded-2xl">
              <MessageCircle size={28} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-[#0A1628] mb-1">WhatsApp</h3>
              <p className="text-[#25D366] font-semibold">Chat with us</p>
              <p className="text-gray-500 text-sm">Quick response guaranteed</p>
            </div>
          </motion.button>

          {/* Email Card */}
          <motion.button
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.3 }}
            onClick={handleEmail}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="w-full bg-white rounded-2xl p-6 shadow-lg border border-gray-100 flex items-center gap-4 text-left"
          >
            <div className="bg-gradient-to-br from-purple-600 to-pink-600 p-4 rounded-2xl">
              <Mail size={28} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-[#0A1628] mb-1">Email</h3>
              <p className="text-purple-600 font-semibold">info@zeetech.pk</p>
              <p className="text-gray-500 text-sm">Tap to compose email</p>
            </div>
          </motion.button>

          {/* Address Card */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.4 }}
            className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 flex items-start gap-4"
          >
            <div className="bg-gradient-to-br from-red-600 to-orange-600 p-4 rounded-2xl">
              <MapPin size={28} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-[#0A1628] mb-1">Address</h3>
              <p className="text-gray-700">
                Plaza 123, F-7 Markaz<br />
                Islamabad, Pakistan
              </p>
            </div>
          </motion.div>
        </div>

        {/* Embedded Map Placeholder */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-gradient-to-br from-blue-100 to-cyan-100 rounded-3xl h-64 flex items-center justify-center border border-blue-200 shadow-lg overflow-hidden relative"
        >
          <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAxMCAwIEwgMCAwIDAgMTAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwNTdGRiIgc3Ryb2tlLW9wYWNpdHk9IjAuMSIgc3Ryb2tlLXdpZHRoPSIxIi8+PC9wYXR0ZXJuPjwvZGVmcz48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ1cmwoI2dyaWQpIi8+PC9zdmc+')] opacity-50" />
          <div className="text-center z-10">
            <MapPin size={64} className="text-[#0057FF] mx-auto mb-3" strokeWidth={1.5} />
            <p className="text-[#0A1628] font-semibold text-lg">Find Us on Map</p>
            <p className="text-gray-600 text-sm">F-7 Markaz, Islamabad</p>
          </div>
        </motion.div>

        {/* Social Media */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100"
        >
          <h3 className="font-bold text-[#0A1628] mb-4 text-center">Follow Us</h3>
          <div className="flex items-center justify-center gap-4">
            <motion.a
              href="https://facebook.com/zeetech"
              target="_blank"
              rel="noopener noreferrer"
              whileHover={{ scale: 1.1, y: -2 }}
              whileTap={{ scale: 0.95 }}
              className="bg-[#1877F2] p-4 rounded-full shadow-lg"
            >
              <Facebook size={28} className="text-white" fill="white" />
            </motion.a>

            <motion.a
              href="https://instagram.com/zeetech"
              target="_blank"
              rel="noopener noreferrer"
              whileHover={{ scale: 1.1, y: -2 }}
              whileTap={{ scale: 0.95 }}
              className="bg-gradient-to-br from-purple-600 via-pink-600 to-orange-500 p-4 rounded-full shadow-lg"
            >
              <Instagram size={28} className="text-white" />
            </motion.a>

            <motion.a
              href="https://tiktok.com/@zeetech"
              target="_blank"
              rel="noopener noreferrer"
              whileHover={{ scale: 1.1, y: -2 }}
              whileTap={{ scale: 0.95 }}
              className="bg-black p-4 rounded-full shadow-lg"
            >
              <TbBrandTiktok size={28} className="text-white" />
            </motion.a>

            <motion.a
              href="https://wa.me/923001234567"
              target="_blank"
              rel="noopener noreferrer"
              whileHover={{ scale: 1.1, y: -2 }}
              whileTap={{ scale: 0.95 }}
              className="bg-[#25D366] p-4 rounded-full shadow-lg"
            >
              <MessageCircle size={28} className="text-white" />
            </motion.a>
          </div>
        </motion.div>

        {/* Operating Hours */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7 }}
          className="bg-gradient-to-br from-[#0057FF] to-[#00C2FF] rounded-2xl p-6 text-white shadow-xl"
        >
          <h3 className="text-xl font-bold mb-4 text-center">Operating Hours</h3>
          <div className="space-y-2 text-center">
            <p className="text-white/95">Monday - Saturday: 8:00 AM - 10:00 PM</p>
            <p className="text-white/95">Sunday: 9:00 AM - 8:00 PM</p>
            <div className="mt-4 pt-4 border-t border-white/20">
              <p className="font-bold text-lg">🚨 Emergency Service: 24/7</p>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
