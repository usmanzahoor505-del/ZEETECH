import { motion } from "motion/react";
import { Search, TrendingUp, MousePointerClick, Globe, Smartphone, Palette } from "lucide-react";

const services = [
  {
    icon: Search,
    title: "SEO Optimization",
    description: "Improve your search rankings and organic traffic",
    price: "Starting at $999/mo",
    gradient: "from-blue-600 to-blue-500",
  },
  {
    icon: TrendingUp,
    title: "Social Media Marketing",
    description: "Build your brand presence across all platforms",
    price: "Starting at $799/mo",
    gradient: "from-blue-700 to-blue-600",
  },
  {
    icon: MousePointerClick,
    title: "PPC Advertising",
    description: "Drive targeted traffic with paid campaigns",
    price: "Starting at $1,299/mo",
    gradient: "from-blue-800 to-blue-700",
  },
  {
    icon: Globe,
    title: "Website Development",
    description: "Custom websites that convert visitors to customers",
    price: "Starting at $2,999",
    gradient: "from-blue-900 to-blue-800",
  },
  {
    icon: Smartphone,
    title: "App Development",
    description: "iOS and Android apps for your business",
    price: "Starting at $9,999",
    gradient: "from-blue-950 to-blue-900",
  },
  {
    icon: Palette,
    title: "Branding & Design",
    description: "Create a memorable brand identity",
    price: "Starting at $1,499",
    gradient: "from-indigo-700 to-blue-700",
  },
];

export default function ServicesScreen() {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-gradient-to-b from-blue-50 to-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-900 to-blue-700 text-white px-6 py-8">
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
          className="text-blue-100"
        >
          Comprehensive digital solutions for your business
        </motion.p>
      </div>

      {/* Services Grid */}
      <div className="px-6 py-8">
        <div className="space-y-4">
          {services.map((service, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ scale: 1.02 }}
              className="bg-white rounded-3xl shadow-lg overflow-hidden border border-blue-100"
            >
              <div className={`h-2 bg-gradient-to-r ${service.gradient}`} />
              <div className="p-6">
                <div className="flex items-start gap-4">
                  <div className={`bg-gradient-to-br ${service.gradient} p-4 rounded-2xl`}>
                    <service.icon size={28} className="text-white" strokeWidth={1.5} />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-xl font-bold text-gray-900 mb-2">{service.title}</h3>
                    <p className="text-gray-600 mb-3">{service.description}</p>
                    <div className="flex items-center justify-between">
                      <span className="text-blue-600 font-semibold">{service.price}</span>
                      <button className="bg-gradient-to-r from-blue-600 to-blue-500 text-white px-6 py-2 rounded-full text-sm font-semibold shadow-md hover:shadow-lg transition-shadow">
                        Learn More
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* CTA Section */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.8 }}
          className="mt-8 bg-gradient-to-br from-blue-900 via-blue-700 to-blue-500 rounded-3xl p-8 text-white text-center shadow-2xl"
        >
          <h3 className="text-2xl font-bold mb-3">Need a Custom Solution?</h3>
          <p className="text-blue-100 mb-6">
            Let's discuss your unique requirements
          </p>
          <button className="bg-white text-blue-900 px-8 py-3 rounded-full font-semibold shadow-lg hover:shadow-xl transition-shadow">
            Contact Us
          </button>
        </motion.div>
      </div>
    </div>
  );
}
