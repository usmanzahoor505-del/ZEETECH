import { motion } from "motion/react";
import { Wind, Refrigerator, Sun, Battery, Hammer, Zap, WashingMachine } from "lucide-react";

interface ServicesScreenProps {
  onNavigate?: (screen: string, serviceId?: string) => void;
}

const services = [
  {
    id: "ac",
    icon: Wind,
    emoji: "❄️",
    name: "Air Conditioner",
    description: "Installation, repair & maintenance",
    gradient: "from-blue-600 to-cyan-500",
  },
  {
    id: "refrigerator",
    icon: Refrigerator,
    emoji: "🧊",
    name: "Refrigerator",
    description: "All brands service & repair",
    gradient: "from-cyan-600 to-blue-500",
  },
  {
    id: "solar",
    icon: Sun,
    emoji: "☀️",
    name: "Solar Energy",
    description: "Solar panel installation & repair",
    gradient: "from-yellow-500 to-orange-500",
  },
  {
    id: "inverter",
    icon: Battery,
    emoji: "🔋",
    name: "Inverter Services",
    description: "UPS & inverter solutions",
    gradient: "from-green-600 to-emerald-500",
  },
  {
    id: "carpenter",
    icon: Hammer,
    emoji: "🪚",
    name: "Carpenter",
    description: "Furniture & woodwork services",
    gradient: "from-amber-600 to-yellow-600",
  },
  {
    id: "electrician",
    icon: Zap,
    emoji: "⚡",
    name: "General Electrician",
    description: "Wiring, fixtures & electrical work",
    gradient: "from-purple-600 to-blue-600",
  },
  {
    id: "washing_machine",
    icon: WashingMachine,
    emoji: "🫧",
    name: "Automatic washing machine",
    description: "Auto washer repair & service",
    gradient: "from-sky-600 to-blue-500",
  },
];

export default function ZeetechServicesScreen({ onNavigate }: ServicesScreenProps) {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-[#F5F7FA]">
      {/* Header */}
      <div className="bg-gradient-to-br from-[#0A1628] to-[#0D1B2A] text-white px-6 py-8">
        <motion.h1
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-3xl font-bold mb-2"
        >
          Our Services
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="text-white/80"
        >
          Professional repair & maintenance solutions
        </motion.p>
      </div>

      {/* Services Grid */}
      <div className="px-6 py-8">
        <div className="grid grid-cols-2 gap-4">
          {services.map((service, index) => (
            <motion.div
              key={service.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ scale: 1.05, y: -4 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => onNavigate?.("service-detail", service.id)}
              className="bg-white rounded-3xl shadow-lg overflow-hidden border border-gray-100 cursor-pointer"
            >
              {/* Gradient Header */}
              <div className={`h-32 bg-gradient-to-br ${service.gradient} flex items-center justify-center relative`}>
                <div className="text-6xl">{service.emoji}</div>
                <div className="absolute inset-0 bg-black/10" />
              </div>

              {/* Content */}
              <div className="p-4">
                <h3 className="text-lg font-bold text-[#0A1628] mb-2 leading-tight">
                  {service.name}
                </h3>
                <p className="text-gray-600 text-sm mb-4 leading-snug">
                  {service.description}
                </p>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  className="w-full bg-gradient-to-r from-[#0057FF] to-[#00C2FF] text-white py-2.5 rounded-xl text-sm font-semibold shadow-md"
                >
                  Book Now
                </motion.button>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Emergency Contact Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8 }}
          className="mt-8 bg-gradient-to-br from-[#0A1628] to-[#0D1B2A] rounded-3xl p-6 text-white shadow-2xl"
        >
          <div className="flex items-center gap-4 mb-4">
            <div className="bg-[#00C2FF] p-4 rounded-full">
              <Zap size={28} className="text-white" strokeWidth={2.5} />
            </div>
            <div>
              <h3 className="text-xl font-bold mb-1">Emergency Service?</h3>
              <p className="text-white/80 text-sm">We're available 24/7 for urgent repairs</p>
            </div>
          </div>
          <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => onNavigate?.("contact")}
            className="w-full bg-gradient-to-r from-[#0057FF] to-[#00C2FF] text-white py-3 rounded-xl font-semibold shadow-lg"
          >
            Call Now: 0300-1234567
          </motion.button>
        </motion.div>
      </div>
    </div>
  );
}
