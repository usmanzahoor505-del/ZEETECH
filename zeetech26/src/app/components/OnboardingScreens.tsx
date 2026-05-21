import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { TrendingUp, Globe, Search, Smartphone, ChevronRight } from "lucide-react";

const onboardingData = [
  {
    icon: TrendingUp,
    title: "Digital Marketing Services",
    description: "Grow your business with data-driven marketing strategies and campaigns",
    gradient: "from-blue-600 to-blue-400",
  },
  {
    icon: Globe,
    title: "Website Development",
    description: "Custom websites built with modern technologies for exceptional user experiences",
    gradient: "from-blue-700 to-blue-500",
  },
  {
    icon: Search,
    title: "SEO & Analytics",
    description: "Optimize your online presence and track your success with advanced analytics",
    gradient: "from-blue-800 to-blue-600",
  },
  {
    icon: Smartphone,
    title: "Mobile App Development",
    description: "Native and cross-platform mobile apps that engage your customers",
    gradient: "from-blue-900 to-blue-700",
  },
];

export default function OnboardingScreens({ onComplete }: { onComplete: () => void }) {
  const [currentSlide, setCurrentSlide] = useState(0);

  const nextSlide = () => {
    if (currentSlide < onboardingData.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      onComplete();
    }
  };

  const skipOnboarding = () => {
    onComplete();
  };

  return (
    <div className="fixed inset-0 bg-gradient-to-br from-blue-50 to-white overflow-hidden">
      <div className="h-full flex flex-col">
        <div className="flex justify-end p-6">
          <button
            onClick={skipOnboarding}
            className="text-blue-600 font-medium px-4 py-2 rounded-lg hover:bg-blue-50 transition-colors"
          >
            Skip
          </button>
        </div>

        <div className="flex-1 flex flex-col items-center justify-center px-8 pb-8">
          <AnimatePresence mode="wait">
            <motion.div
              key={currentSlide}
              initial={{ opacity: 0, x: 50 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -50 }}
              transition={{ duration: 0.3 }}
              className="flex flex-col items-center text-center max-w-md"
            >
              <motion.div
                className={`w-32 h-32 bg-gradient-to-br ${onboardingData[currentSlide].gradient} rounded-3xl flex items-center justify-center mb-8 shadow-xl`}
                whileHover={{ scale: 1.05 }}
              >
                {(() => {
                  const Icon = onboardingData[currentSlide].icon;
                  return <Icon size={64} className="text-white" strokeWidth={1.5} />;
                })()}
              </motion.div>

              <h2 className="text-3xl font-bold text-gray-900 mb-4">
                {onboardingData[currentSlide].title}
              </h2>
              <p className="text-gray-600 text-lg leading-relaxed">
                {onboardingData[currentSlide].description}
              </p>
            </motion.div>
          </AnimatePresence>
        </div>

        <div className="px-8 pb-12">
          <div className="flex justify-center gap-2 mb-8">
            {onboardingData.map((_, index) => (
              <motion.div
                key={index}
                className={`h-2 rounded-full transition-all ${
                  index === currentSlide ? "w-8 bg-blue-600" : "w-2 bg-gray-300"
                }`}
                animate={{ scale: index === currentSlide ? 1 : 0.8 }}
              />
            ))}
          </div>

          <button
            onClick={nextSlide}
            className="w-full bg-gradient-to-r from-blue-600 to-blue-500 text-white py-4 rounded-2xl font-semibold flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-shadow"
          >
            {currentSlide < onboardingData.length - 1 ? "Next" : "Get Started"}
            <ChevronRight size={20} />
          </button>
        </div>
      </div>
    </div>
  );
}
