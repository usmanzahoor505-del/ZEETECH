import { useState } from "react";
import { motion } from "motion/react";
import { ExternalLink, ArrowLeft } from "lucide-react";

interface PortfolioScreenProps {
  onNavigate?: (screen: string) => void;
}

const categories = ["All", "Web Design", "Mobile Apps", "Branding", "Marketing"];

const projects = [
  {
    id: 1,
    title: "E-Commerce Platform",
    category: "Web Design",
    image: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80",
    description: "Modern shopping experience",
  },
  {
    id: 2,
    title: "Fitness Tracking App",
    category: "Mobile Apps",
    image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80",
    description: "Health and wellness platform",
  },
  {
    id: 3,
    title: "Restaurant Branding",
    category: "Branding",
    image: "https://images.unsplash.com/photo-1555421689-d68471e189f2?w=800&q=80",
    description: "Complete brand identity",
  },
  {
    id: 4,
    title: "Social Media Campaign",
    category: "Marketing",
    image: "https://images.unsplash.com/photo-1432888622747-4eb9a8f2c293?w=800&q=80",
    description: "Viral marketing success",
  },
  {
    id: 5,
    title: "SaaS Dashboard",
    category: "Web Design",
    image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80",
    description: "Analytics platform",
  },
  {
    id: 6,
    title: "Banking App",
    category: "Mobile Apps",
    image: "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800&q=80",
    description: "Secure financial app",
  },
];

export default function PortfolioScreen({ onNavigate }: PortfolioScreenProps) {
  const [activeCategory, setActiveCategory] = useState("All");

  const filteredProjects =
    activeCategory === "All"
      ? projects
      : projects.filter((p) => p.category === activeCategory);

  return (
    <div className="h-full overflow-y-auto pb-20 bg-gradient-to-b from-gray-50 to-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-900 to-blue-700 text-white px-6 py-8">
        <button
          onClick={() => onNavigate?.("home")}
          className="flex items-center gap-2 text-white/80 hover:text-white mb-4 transition-colors"
        >
          <ArrowLeft size={20} />
          <span>Back</span>
        </button>
        <motion.h1
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-3xl font-bold mb-2"
        >
          Our Portfolio
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="text-blue-100"
        >
          Showcasing our best work
        </motion.p>
      </div>

      {/* Filter Tabs */}
      <div className="px-6 py-6 overflow-x-auto">
        <div className="flex gap-3">
          {categories.map((category) => (
            <motion.button
              key={category}
              whileTap={{ scale: 0.95 }}
              onClick={() => setActiveCategory(category)}
              className={`px-6 py-2 rounded-full font-medium whitespace-nowrap transition-all ${
                activeCategory === category
                  ? "bg-gradient-to-r from-blue-600 to-blue-500 text-white shadow-lg"
                  : "bg-white text-gray-700 border border-gray-200 hover:border-blue-300"
              }`}
            >
              {category}
            </motion.button>
          ))}
        </div>
      </div>

      {/* Projects Grid */}
      <div className="px-6 pb-8">
        <div className="grid grid-cols-1 gap-6">
          {filteredProjects.map((project, index) => (
            <motion.div
              key={project.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ y: -4 }}
              className="bg-white rounded-3xl overflow-hidden shadow-lg border border-gray-100"
            >
              <div className="relative h-48 bg-gradient-to-br from-blue-100 to-blue-50 overflow-hidden">
                <img
                  src={project.image}
                  alt={project.title}
                  className="w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-blue-900/50 to-transparent" />
                <div className="absolute bottom-4 left-4 right-4">
                  <span className="inline-block px-3 py-1 bg-white/90 backdrop-blur-sm text-blue-900 text-xs font-semibold rounded-full">
                    {project.category}
                  </span>
                </div>
              </div>
              <div className="p-6">
                <h3 className="text-xl font-bold text-gray-900 mb-2">{project.title}</h3>
                <p className="text-gray-600 mb-4">{project.description}</p>
                <button className="flex items-center gap-2 text-blue-600 font-semibold hover:gap-3 transition-all">
                  View Case Study <ExternalLink size={16} />
                </button>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
