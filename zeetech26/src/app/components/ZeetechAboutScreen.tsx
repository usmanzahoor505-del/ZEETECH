import { motion } from "motion/react";
import { Shield, Award, Heart, Briefcase, Lightbulb, CheckCircle2 } from "lucide-react";

const stats = [
  { value: "2500+", label: "Happy Clients", icon: "👥" },
  { value: "98%", label: "Satisfaction Rate", icon: "⭐" },
  { value: "24/7", label: "Support Available", icon: "🕐" },
  { value: "50+", label: "Expert Technicians", icon: "👨‍🔧" },
];

const timeline = [
  { year: "2015", event: "Founded in Islamabad", desc: "Started with a small team" },
  { year: "2018", event: "Expanded Services", desc: "Added solar & HVAC" },
  { year: "2021", event: "1000+ Clients", desc: "Milestone achievement" },
  { year: "2024", event: "Leading Service Provider", desc: "Recognized across Pakistan" },
];

const values = [
  { icon: Shield, title: "Reliability", desc: "Always on time, every time" },
  { icon: Award, title: "Quality", desc: "Premium parts & workmanship" },
  { icon: Heart, title: "Customer Satisfaction", desc: "Your happiness is our goal" },
  { icon: Briefcase, title: "Professionalism", desc: "Trained & certified experts" },
  { icon: Lightbulb, title: "Innovation", desc: "Latest tools & techniques" },
  { icon: CheckCircle2, title: "Integrity", desc: "Honest & transparent pricing" },
];

export default function ZeetechAboutScreen() {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-[#F5F7FA]">
      {/* Header */}
      <div className="bg-gradient-to-br from-[#0A1628] to-[#0D1B2A] text-white px-6 py-8">
        <motion.h1
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-3xl font-bold mb-2"
        >
          About ZEETECH
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="text-white/80"
        >
          Powering comfort, repairing trust since 2015
        </motion.p>
      </div>

      <div className="px-6 py-8 space-y-8">
        {/* Company Intro */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100"
        >
          <p className="text-gray-700 leading-relaxed">
            ZEETECH Technical Services is Islamabad's premier home and commercial repair company.
            With over 8 years of experience, we provide professional AC, refrigerator, solar,
            electrical, and carpentry services. Our certified technicians ensure quality
            workmanship and customer satisfaction in every job.
          </p>
        </motion.div>

        {/* Animated Stats */}
        <div className="grid grid-cols-2 gap-4">
          {stats.map((stat, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.2 + index * 0.1, type: "spring" }}
              className="bg-gradient-to-br from-[#0057FF] to-[#00C2FF] rounded-2xl p-6 text-white text-center shadow-xl"
            >
              <div className="text-4xl mb-2">{stat.icon}</div>
              <div className="text-3xl font-bold mb-1">{stat.value}</div>
              <div className="text-sm text-white/90">{stat.label}</div>
            </motion.div>
          ))}
        </div>

        {/* History Timeline */}
        <div>
          <h2 className="text-2xl font-bold text-[#0A1628] mb-6">Our Journey</h2>
          <div className="relative">
            <div className="absolute left-6 top-0 bottom-0 w-0.5 bg-gradient-to-b from-[#0057FF] to-[#00C2FF]" />
            <div className="space-y-6">
              {timeline.map((item, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.5 + index * 0.1 }}
                  className="relative pl-16"
                >
                  <div className="absolute left-0 w-12 h-12 bg-gradient-to-br from-[#0057FF] to-[#00C2FF] rounded-full flex items-center justify-center text-white font-bold shadow-lg">
                    <span className="text-xs">{item.year}</span>
                  </div>
                  <div className="bg-white rounded-xl p-4 shadow-md border border-gray-100">
                    <h3 className="font-bold text-[#0A1628] mb-1">{item.event}</h3>
                    <p className="text-gray-600 text-sm">{item.desc}</p>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        </div>

        {/* Core Values */}
        <div>
          <h2 className="text-2xl font-bold text-[#0A1628] mb-6">Our Core Values</h2>
          <div className="grid grid-cols-2 gap-4">
            {values.map((value, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.8 + index * 0.05 }}
                whileHover={{ scale: 1.05 }}
                className="bg-white rounded-2xl p-5 shadow-md border border-gray-100 text-center"
              >
                <div className="bg-gradient-to-br from-[#0057FF] to-[#00C2FF] w-12 h-12 rounded-xl flex items-center justify-center mx-auto mb-3">
                  <value.icon size={24} className="text-white" strokeWidth={2} />
                </div>
                <h3 className="font-bold text-[#0A1628] text-sm mb-1">
                  {value.title}
                </h3>
                <p className="text-gray-600 text-xs">{value.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Mission & Vision */}
        <div className="space-y-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.2 }}
            className="bg-gradient-to-br from-[#0057FF] to-[#00C2FF] rounded-2xl p-6 text-white shadow-xl"
          >
            <h3 className="text-xl font-bold mb-3">Our Mission</h3>
            <p className="text-white/95 leading-relaxed">
              To provide reliable, professional, and affordable technical services that enhance
              the comfort and safety of homes and businesses across Islamabad.
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.3 }}
            className="bg-gradient-to-br from-[#0A1628] to-[#0D1B2A] rounded-2xl p-6 text-white shadow-xl"
          >
            <h3 className="text-xl font-bold mb-3">Our Vision</h3>
            <p className="text-white/95 leading-relaxed">
              To be Pakistan's most trusted technical services company, recognized for excellence,
              innovation, and unwavering commitment to customer satisfaction.
            </p>
          </motion.div>
        </div>
      </div>
    </div>
  );
}
