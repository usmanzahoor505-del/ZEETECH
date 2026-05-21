import { useState, useEffect } from "react";
import { motion } from "motion/react";
import {
  ChevronRight,
  Users,
  ThumbsUp,
  Clock,
  Wrench,
  Shield,
  Award,
  Heart,
} from "lucide-react";

interface HomeScreenProps {
  onNavigate?: (screen: string) => void;
}

const carouselImages = [
  { title: "AC Services", color: "from-blue-600 to-cyan-500" },
  { title: "Refrigerator Repair", color: "from-cyan-600 to-blue-500" },
  { title: "Solar Energy", color: "from-yellow-500 to-orange-500" },
  { title: "Electrical Work", color: "from-purple-600 to-blue-600" },
  { title: "Carpentry", color: "from-amber-600 to-yellow-600" },
];

const stats = [
  { value: "2500+", label: "Clients" },
  { value: "98%", label: "Satisfaction" },
  { value: "24/7", label: "Support" },
  { value: "50+", label: "Technicians" },
];

const features = [
  {
    icon: Shield,
    title: "Reliability",
    description: "Professional service you can trust",
    color: "from-[#0057FF] to-[#00C2FF]",
  },
  {
    icon: Award,
    title: "Quality Workmanship",
    description: "Expert technicians, quality parts",
    color: "from-[#00C2FF] to-[#0057FF]",
  },
  {
    icon: Heart,
    title: "Customer Satisfaction",
    description: "Your comfort is our priority",
    color: "from-[#22C55E] to-[#00C2FF]",
  },
];

export default function ZeetechHomeScreen({ onNavigate }: HomeScreenProps) {
  const [currentSlide, setCurrentSlide] = useState(0);
  const [timeLeft, setTimeLeft] = useState({
    days: 2,
    hours: 15,
    minutes: 30,
    seconds: 45,
  });

  // Auto-slide carousel
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % carouselImages.length);
    }, 3000);
    return () => clearInterval(timer);
  }, []);

  // Countdown timer
  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev.seconds > 0) {
          return { ...prev, seconds: prev.seconds - 1 };
        } else if (prev.minutes > 0) {
          return { ...prev, minutes: prev.minutes - 1, seconds: 59 };
        } else if (prev.hours > 0) {
          return { ...prev, hours: prev.hours - 1, minutes: 59, seconds: 59 };
        } else if (prev.days > 0) {
          return { ...prev, days: prev.days - 1, hours: 23, minutes: 59, seconds: 59 };
        }
        return prev;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="h-full overflow-y-auto pb-20 bg-[#F5F7FA]">
      {/* Sticky Offer Banner */}
      <motion.div
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        className="sticky top-0 z-40 bg-gradient-to-r from-orange-500 via-red-500 to-orange-600 text-white px-4 py-3 shadow-lg"
      >
        <div className="flex items-center justify-between text-sm">
          <div className="flex items-center gap-2">
            <span className="font-bold text-base">🔥 30% OFF</span>
            <span className="hidden sm:inline">· Limited Time Offer</span>
          </div>
          <div className="flex items-center gap-1 font-mono text-xs">
            <div className="bg-white/20 px-2 py-1 rounded">{String(timeLeft.days).padStart(2, "0")}d</div>
            <div className="bg-white/20 px-2 py-1 rounded">{String(timeLeft.hours).padStart(2, "0")}h</div>
            <div className="bg-white/20 px-2 py-1 rounded">{String(timeLeft.minutes).padStart(2, "0")}m</div>
            <div className="bg-white/20 px-2 py-1 rounded">{String(timeLeft.seconds).padStart(2, "0")}s</div>
          </div>
        </div>
      </motion.div>

      {/* Auto-Sliding Carousel */}
      <div className="relative h-56 overflow-hidden">
        {carouselImages.map((slide, index) => (
          <motion.div
            key={index}
            className={`absolute inset-0 bg-gradient-to-br ${slide.color} flex items-center justify-center`}
            initial={{ opacity: 0, x: 100 }}
            animate={{
              opacity: currentSlide === index ? 1 : 0,
              x: currentSlide === index ? 0 : -100,
            }}
            transition={{ duration: 0.5 }}
          >
            <h2 className="text-3xl font-bold text-white px-8 text-center">
              {slide.title}
            </h2>
          </motion.div>
        ))}

        {/* Carousel Indicators */}
        <div className="absolute bottom-4 left-0 right-0 flex justify-center gap-2">
          {carouselImages.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentSlide(index)}
              className={`h-2 rounded-full transition-all ${
                currentSlide === index ? "w-8 bg-white" : "w-2 bg-white/50"
              }`}
            />
          ))}
        </div>
      </div>

      {/* Hero Section */}
      <div className="px-6 py-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-8"
        >
          <h1 className="text-3xl font-bold text-[#0A1628] mb-4 leading-tight">
            ZEETECH Technical Services
          </h1>
          <p className="text-gray-600 mb-6">
            Professional home & commercial repair services in Islamabad
          </p>

          <div className="flex gap-3 justify-center">
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => onNavigate?.("services")}
              className="bg-gradient-to-r from-[#0057FF] to-[#00C2FF] text-white px-6 py-3 rounded-xl font-semibold shadow-lg flex items-center gap-2"
            >
              Explore Services <ChevronRight size={20} />
            </motion.button>
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => onNavigate?.("contact")}
              className="bg-[#0A1628] text-white px-6 py-3 rounded-xl font-semibold shadow-lg"
            >
              Contact Us
            </motion.button>
          </div>
        </motion.div>

        {/* Stats Row */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-white rounded-2xl shadow-lg p-6 mb-8 border border-gray-100"
        >
          <div className="grid grid-cols-4 gap-4">
            {stats.map((stat, index) => (
              <motion.div
                key={index}
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.4 + index * 0.1, type: "spring" }}
                className="text-center"
              >
                <div className="text-2xl font-bold text-[#0057FF] mb-1">
                  {stat.value}
                </div>
                <div className="text-xs text-gray-600 leading-tight">
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </div>
        </motion.div>

        {/* Feature Cards */}
        <div className="space-y-4">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.6 + index * 0.15 }}
              whileHover={{ scale: 1.02 }}
              className="bg-white rounded-2xl p-6 shadow-md border border-gray-100"
            >
              <div className="flex items-start gap-4">
                <div className={`bg-gradient-to-br ${feature.color} p-4 rounded-xl`}>
                  <feature.icon size={28} className="text-white" strokeWidth={2} />
                </div>
                <div className="flex-1">
                  <h3 className="text-lg font-bold text-[#0A1628] mb-2">
                    {feature.title}
                  </h3>
                  <p className="text-gray-600 text-sm">{feature.description}</p>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
