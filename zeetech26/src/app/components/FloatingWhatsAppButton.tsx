import { motion } from "motion/react";
import { MessageCircle } from "lucide-react";

export default function FloatingWhatsAppButton() {
  const handleWhatsApp = () => {
    const message = "Hello ZEETECH! I need technical service assistance.";
    window.open(`https://wa.me/923001234567?text=${encodeURIComponent(message)}`, "_blank");
  };

  return (
    <motion.button
      onClick={handleWhatsApp}
      initial={{ scale: 0 }}
      animate={{ scale: 1 }}
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.9 }}
      className="fixed bottom-24 right-6 bg-[#25D366] text-white p-4 rounded-full shadow-2xl z-50 hover:shadow-[0_0_30px_rgba(37,211,102,0.4)] transition-shadow"
    >
      <motion.div
        animate={{
          rotate: [0, -10, 10, -10, 0],
        }}
        transition={{
          duration: 0.5,
          repeat: Infinity,
          repeatDelay: 3,
        }}
      >
        <MessageCircle size={32} fill="white" strokeWidth={0} />
      </motion.div>

      {/* Pulse effect */}
      <motion.div
        className="absolute inset-0 bg-[#25D366] rounded-full -z-10"
        animate={{
          scale: [1, 1.5, 1],
          opacity: [0.5, 0, 0.5],
        }}
        transition={{
          duration: 2,
          repeat: Infinity,
        }}
      />
    </motion.button>
  );
}
