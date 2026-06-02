import { motion } from "motion/react";
import { ArrowLeft, CheckCircle2, Phone } from "lucide-react";

interface ServiceDetailScreenProps {
  serviceId: string;
  onNavigate?: (screen: string) => void;
  onBook?: () => void;
}

const serviceData: Record<string, any> = {
  ac: {
    name: "Air Conditioner Services",
    emoji: "❄️",
    gradient: "from-blue-600 to-cyan-500",
    description:
      "Expert AC installation, repair, and maintenance services for all major brands. Our certified technicians ensure optimal cooling performance and energy efficiency.",
    subServices: [
      "AC Dismounting",
      "AC General Service",
      "AC Installation",
      "AC Mounting and Dismounting",
      "AC Mounting and Dismounting + AC General Service",
      "AC Repairing",
    ],
  },
  refrigerator: {
    name: "Refrigerator Services",
    emoji: "🧊",
    gradient: "from-cyan-600 to-blue-500",
    description:
      "Complete refrigerator repair and maintenance for all brands including Samsung, LG, Haier, PEL, and more. Fast, reliable service to keep your food fresh.",
    subServices: [
      "Cooling System Repair",
      "Gas Charging & Leak Fix",
      "Compressor Replacement",
      "Door Seal Replacement",
      "Thermostat Repair",
      "Ice Maker Repair",
    ],
  },
  solar: {
    name: "Solar Energy Solutions",
    emoji: "☀️",
    gradient: "from-yellow-500 to-orange-500",
    description:
      "Professional solar panel installation and maintenance services. Switch to clean energy and reduce your electricity bills with our expert solutions.",
    subServices: [
      "Solar Panel Installation",
      "Inverter Installation",
      "System Maintenance",
      "Battery Replacement",
      "Net Metering Setup",
      "Solar Water Heater Installation",
    ],
  },
  inverter: {
    name: "Inverter & UPS Services",
    emoji: "🔋",
    gradient: "from-green-600 to-emerald-500",
    description:
      "Complete inverter and UPS solutions for homes and businesses. Installation, repair, and battery replacement services for uninterrupted power supply.",
    subServices: [
      "Inverter Installation",
      "UPS Repair & Maintenance",
      "Battery Replacement",
      "Circuit & Wiring Check",
      "Load Calculation",
      "Automatic Transfer Switch Setup",
    ],
  },
  carpenter: {
    name: "Carpentry Services",
    emoji: "🪚",
    gradient: "from-amber-600 to-yellow-600",
    description:
      "Expert carpentry and woodwork services including furniture repair, custom woodwork, door/window installation, and interior finishing.",
    subServices: [
      "Carpenter Work",
      "Catcher Replacement",
      "Door Installation",
      "Door Repairing",
      "Drawer Lock installation",
      "Drawer Repairing",
      "Furniture Repairing",
      "Room Door Lock installation",
      "Wardrobe Repairing",
    ],
  },
  electrician: {
    name: "General Electrician Services",
    emoji: "⚡",
    gradient: "from-purple-600 to-blue-600",
    description:
      "Professional electrical services for residential and commercial properties. Licensed electricians for safe and reliable electrical work.",
    subServices: [
      "32-42 Inch LED TV or LCD Mounting",
      "43-65 Inch LED TV or LCD Mounting",
      "Automatic Washing Machine Repairing",
      "Ceiling Fan Installation",
      "Ceiling Fan Repairing",
      "Change Over Switch Installation",
      "Door Pillar Lights",
      "Electrical Wiring",
      "Exhaust Fan Installation",
      "Fan Dimmer Switch Installation",
      "Fancy Light Installation (With Wiring)",
      "Fancy Light Installation (Without Wiring)",
      "House Electric Work",
      "Kitchen Hood Installation",
      "Kitchen Hood Repairing",
      "LED TV Dismounting",
      "Light Plug (With Wiring)",
      "Light Plug (Without Wiring)",
      "Manual Washing machine repairing",
      "New House Wiring",
      "Power Plug Installation (With Wiring)",
      "Power Plug Installation (Without Wiring)",
      "Pressure Motor Installation",
      "Single Phase Breaker Replacement",
      "Single Phase Distribution Box Installation",
      "SMD Lights Installation (With Wiring)",
      "SMD Lights Installation (Without Wiring)",
      "Sub-Meter Installation",
      "Switchboard Button Replacement",
      "Tube light Installation",
      "Tube Light Repairing",
      "Tube Light Replacement",
      "UPS installation (Without Wiring)",
      "UPS Repairing",
      "UPS Wiring",
      "Water Pump Repairing",
      "Water Tank Automatic Switch Installation",
    ],
  },
  washing_machine: {
    name: "Automatic washing machine",
    emoji: "🫧",
    gradient: "from-sky-600 to-blue-500",
    description:
      "Complete automatic washing machine repair, installation, and maintenance services for all brands including Samsung, LG, Haier, Dawlance, and more.",
    subServices: [
      "Auto Washing Machine Repairing",
      "Auto Washing Machine Installation",
      "Drum Bearing Replacement",
      "Motor Replacement",
      "Water Inlet Valve Repair",
      "Drain Pump Repair",
      "PCB / Control Board Repair",
      "Door Lock & Seal Replacement",
      "General Service & Deep Cleaning",
      "Spin Cycle Problem Fix",
    ],
  },
};

export default function ServiceDetailScreen({
  serviceId,
  onNavigate,
  onBook,
}: ServiceDetailScreenProps) {
  const service = serviceData[serviceId] || serviceData.ac;

  return (
    <div className="h-full overflow-y-auto pb-20 bg-[#F5F7FA]">
      {/* Hero Image Section */}
      <div className={`relative h-64 bg-gradient-to-br ${service.gradient}`}>
        <button
          onClick={() => onNavigate?.("services")}
          className="absolute top-6 left-6 bg-white/20 backdrop-blur-sm text-white p-2 rounded-full hover:bg-white/30 transition-colors z-10"
        >
          <ArrowLeft size={24} />
        </button>

        <div className="absolute inset-0 flex items-center justify-center">
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ type: "spring", duration: 0.6 }}
            className="text-9xl"
          >
            {service.emoji}
          </motion.div>
        </div>

        <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent" />
      </div>

      {/* Content */}
      <div className="px-6 py-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <h1 className="text-3xl font-bold text-[#0A1628] mb-4">{service.name}</h1>
          <p className="text-gray-600 leading-relaxed mb-8">{service.description}</p>

          {/* Sub-Services */}
          <div className="mb-8">
            <h2 className="text-xl font-bold text-[#0A1628] mb-4">What We Offer</h2>
            <div className="space-y-3">
              {service.subServices.map((subService: string, index: number) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.1 + index * 0.05 }}
                  className="flex items-start gap-3 bg-white rounded-xl p-4 shadow-sm border border-gray-100"
                >
                  <CheckCircle2 size={24} className="text-[#22C55E] flex-shrink-0 mt-0.5" />
                  <span className="text-gray-700">{subService}</span>
                </motion.div>
              ))}
            </div>
          </div>

          {/* CTA Section */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6 }}
            className="bg-gradient-to-br from-[#0057FF] to-[#00C2FF] rounded-3xl p-6 text-white shadow-xl"
          >
            <h3 className="text-2xl font-bold mb-2">Ready to Book?</h3>
            <p className="text-white/90 mb-6">
              Get professional service at your doorstep. Our expert technicians are ready to help!
            </p>

            <div className="space-y-3">
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={onBook}
                className="w-full bg-white text-[#0057FF] py-4 rounded-xl font-bold shadow-lg"
              >
                Book This Service
              </motion.button>

              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className="w-full bg-[#25D366] text-white py-4 rounded-xl font-bold shadow-lg flex items-center justify-center gap-2"
              >
                <Phone size={20} />
                Call Now
              </motion.button>
            </div>
          </motion.div>
        </motion.div>
      </div>
    </div>
  );
}
