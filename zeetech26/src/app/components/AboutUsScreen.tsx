import { motion } from "motion/react";
import { Target, Eye, TrendingUp, Users, Award, Zap, ArrowLeft } from "lucide-react";

interface AboutUsScreenProps {
  onNavigate?: (screen: string) => void;
}

const timeline = [
  { year: "2018", event: "Company Founded", description: "Started with a vision" },
  { year: "2020", event: "100+ Clients", description: "Rapid growth" },
  { year: "2022", event: "Award Winner", description: "Industry recognition" },
  { year: "2024", event: "Global Expansion", description: "Serving worldwide" },
];

const team = [
  { name: "Alex Johnson", role: "CEO & Founder", avatar: "AJ" },
  { name: "Sarah Williams", role: "CTO", avatar: "SW" },
  { name: "Michael Brown", role: "Creative Director", avatar: "MB" },
  { name: "Emily Davis", role: "Marketing Lead", avatar: "ED" },
];

const values = [
  { icon: Target, title: "Mission Driven", desc: "Client success first" },
  { icon: Zap, title: "Innovation", desc: "Cutting-edge solutions" },
  { icon: Award, title: "Excellence", desc: "Premium quality" },
];

export default function AboutUsScreen({ onNavigate }: AboutUsScreenProps) {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-gradient-to-b from-blue-50 to-white">
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
          About Us
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="text-blue-100"
        >
          Building digital excellence since 2018
        </motion.p>
      </div>

      <div className="px-6 py-8 space-y-8">
        {/* Mission & Vision */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="space-y-4"
        >
          <div className="bg-white rounded-3xl p-6 shadow-lg border border-blue-100">
            <div className="flex items-start gap-4 mb-4">
              <div className="bg-gradient-to-br from-blue-600 to-blue-500 p-3 rounded-2xl">
                <Target size={24} className="text-white" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900 mb-2">Our Mission</h2>
                <p className="text-gray-600">
                  To empower businesses with innovative digital solutions that drive growth and success in the modern world.
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-3xl p-6 shadow-lg border border-blue-100">
            <div className="flex items-start gap-4 mb-4">
              <div className="bg-gradient-to-br from-blue-700 to-blue-600 p-3 rounded-2xl">
                <Eye size={24} className="text-white" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-gray-900 mb-2">Our Vision</h2>
                <p className="text-gray-600">
                  To be the leading technology partner for businesses worldwide, transforming ideas into digital reality.
                </p>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Timeline */}
        <div>
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Our Journey</h2>
          <div className="relative">
            <div className="absolute left-6 top-0 bottom-0 w-0.5 bg-gradient-to-b from-blue-600 to-blue-300" />
            <div className="space-y-6">
              {timeline.map((item, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: index * 0.1 }}
                  className="relative pl-16"
                >
                  <div className="absolute left-0 w-12 h-12 bg-gradient-to-br from-blue-600 to-blue-500 rounded-full flex items-center justify-center text-white font-bold shadow-lg">
                    <span className="text-xs">{item.year}</span>
                  </div>
                  <div className="bg-white rounded-2xl p-4 shadow-md border border-blue-100">
                    <h3 className="font-bold text-gray-900 mb-1">{item.event}</h3>
                    <p className="text-gray-600 text-sm">{item.description}</p>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        </div>

        {/* Values */}
        <div>
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Our Values</h2>
          <div className="grid grid-cols-1 gap-4">
            {values.map((value, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.5 + index * 0.1 }}
                className="bg-gradient-to-br from-blue-600 to-blue-500 rounded-2xl p-6 text-white shadow-xl"
              >
                <value.icon size={32} className="mb-3" strokeWidth={1.5} />
                <h3 className="font-bold text-lg mb-1">{value.title}</h3>
                <p className="text-blue-100">{value.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Team */}
        <div>
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Meet Our Team</h2>
          <div className="grid grid-cols-2 gap-4">
            {team.map((member, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.8 + index * 0.1 }}
                className="bg-white rounded-2xl p-4 text-center shadow-lg border border-blue-100"
              >
                <div className="w-16 h-16 bg-gradient-to-br from-blue-600 to-blue-500 rounded-full flex items-center justify-center text-white font-bold text-xl mx-auto mb-3">
                  {member.avatar}
                </div>
                <h3 className="font-bold text-gray-900 text-sm">{member.name}</h3>
                <p className="text-gray-600 text-xs">{member.role}</p>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Stats */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 1.2 }}
          className="bg-gradient-to-br from-blue-900 via-blue-700 to-blue-500 rounded-3xl p-8 text-white shadow-2xl"
        >
          <h2 className="text-2xl font-bold mb-6 text-center">Growth Analytics</h2>
          <div className="grid grid-cols-2 gap-6">
            <div className="text-center">
              <TrendingUp size={32} className="mx-auto mb-2" />
              <div className="text-3xl font-bold mb-1">350%</div>
              <div className="text-blue-100 text-sm">Revenue Growth</div>
            </div>
            <div className="text-center">
              <Users size={32} className="mx-auto mb-2" />
              <div className="text-3xl font-bold mb-1">250+</div>
              <div className="text-blue-100 text-sm">Happy Clients</div>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
