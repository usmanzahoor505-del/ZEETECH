import { motion } from "motion/react";
import {
  TrendingUp,
  Globe,
  Search,
  Smartphone,
  Palette,
  BarChart3,
  Users,
  Star,
  ChevronRight,
  FolderOpen,
  Info,
} from "lucide-react";

interface HomeScreenProps {
  onNavigate?: (screen: string) => void;
}

const services = [
  { icon: Search, title: "SEO", color: "bg-blue-500" },
  { icon: TrendingUp, title: "Social Media", color: "bg-blue-600" },
  { icon: BarChart3, title: "PPC Ads", color: "bg-blue-700" },
  { icon: Globe, title: "Web Dev", color: "bg-blue-800" },
];

const stats = [
  { value: "500+", label: "Projects" },
  { value: "250+", label: "Clients" },
  { value: "98%", label: "Satisfaction" },
  { value: "15+", label: "Awards" },
];

const testimonials = [
  {
    name: "Sarah Johnson",
    company: "Tech Startup Inc",
    text: "Zee Technology transformed our digital presence completely!",
    rating: 5,
  },
  {
    name: "Michael Chen",
    company: "E-commerce Plus",
    text: "Outstanding results! Our revenue increased by 150%.",
    rating: 5,
  },
];

export default function HomeScreen({ onNavigate }: HomeScreenProps) {
  return (
    <div className="h-full overflow-y-auto pb-20">
      {/* Hero Section */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="relative h-64 bg-gradient-to-br from-blue-900 via-blue-700 to-blue-500 text-white px-6 pt-12 pb-8 overflow-hidden"
      >
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAxMCAwIEwgMCAwIDAgMTAiIGZpbGw9Im5vbmUiIHN0cm9rZT0id2hpdGUiIHN0cm9rZS1vcGFjaXR5PSIwLjA1IiBzdHJva2Utd2lkdGg9IjEiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZ3JpZCkiLz48L3N2Zz4=')] opacity-30" />

        <div className="relative z-10">
          <motion.h1
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.1 }}
            className="text-3xl font-bold mb-2"
          >
            Welcome to Zee Technology
          </motion.h1>
          <motion.p
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.2 }}
            className="text-blue-100 mb-6"
          >
            Transform your business with cutting-edge digital solutions
          </motion.p>
          <motion.button
            onClick={() => onNavigate?.("contact")}
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.3 }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className="bg-white text-blue-900 px-6 py-3 rounded-full font-semibold shadow-lg"
          >
            Get Started
          </motion.button>
        </div>
      </motion.div>

      {/* Services Grid */}
      <div className="px-6 py-8">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold text-gray-900">Our Services</h2>
          <button className="text-blue-600 text-sm font-medium flex items-center gap-1">
            View All <ChevronRight size={16} />
          </button>
        </div>

        <div className="grid grid-cols-2 gap-4 mb-8">
          {services.map((service, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ y: -4 }}
              className={`${service.color} rounded-2xl p-6 text-white shadow-lg backdrop-blur-sm bg-opacity-90`}
            >
              <service.icon size={32} className="mb-3" strokeWidth={1.5} />
              <h3 className="font-semibold">{service.title}</h3>
            </motion.div>
          ))}
        </div>

        {/* Quick Links */}
        <div className="grid grid-cols-2 gap-4 mb-8">
          <motion.button
            onClick={() => onNavigate?.("portfolio")}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.5 }}
            whileHover={{ scale: 1.05 }}
            className="bg-gradient-to-br from-blue-600 to-blue-500 text-white rounded-2xl p-6 flex flex-col items-center gap-3 shadow-lg"
          >
            <FolderOpen size={32} strokeWidth={1.5} />
            <span className="font-semibold">Portfolio</span>
          </motion.button>
          <motion.button
            onClick={() => onNavigate?.("about")}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.5 }}
            whileHover={{ scale: 1.05 }}
            className="bg-gradient-to-br from-blue-700 to-blue-600 text-white rounded-2xl p-6 flex flex-col items-center gap-3 shadow-lg"
          >
            <Info size={32} strokeWidth={1.5} />
            <span className="font-semibold">About Us</span>
          </motion.button>
        </div>

        {/* Stats */}
        <div className="bg-white rounded-3xl shadow-xl p-6 mb-8 border border-blue-100">
          <h2 className="text-xl font-bold text-gray-900 mb-6 text-center">Our Impact</h2>
          <div className="grid grid-cols-4 gap-4">
            {stats.map((stat, index) => (
              <motion.div
                key={index}
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.5 + index * 0.1, type: "spring" }}
                className="text-center"
              >
                <div className="text-2xl font-bold text-blue-600 mb-1">{stat.value}</div>
                <div className="text-xs text-gray-600">{stat.label}</div>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Testimonials */}
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Client Reviews</h2>
        <div className="space-y-4">
          {testimonials.map((testimonial, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.8 + index * 0.2 }}
              className="bg-gradient-to-br from-blue-50 to-white rounded-2xl p-6 shadow-md border border-blue-100"
            >
              <div className="flex gap-1 mb-3">
                {[...Array(testimonial.rating)].map((_, i) => (
                  <Star key={i} size={16} className="fill-yellow-400 text-yellow-400" />
                ))}
              </div>
              <p className="text-gray-700 mb-4 italic">{testimonial.text}</p>
              <div>
                <div className="font-semibold text-gray-900">{testimonial.name}</div>
                <div className="text-sm text-gray-500">{testimonial.company}</div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
