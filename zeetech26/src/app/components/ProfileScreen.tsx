import { motion } from "motion/react";
import {
  User,
  Bookmark,
  Bell,
  Settings,
  LogOut,
  ChevronRight,
  Shield,
  CreditCard,
  HelpCircle,
} from "lucide-react";

const savedProjects = [
  { name: "E-Commerce Redesign", type: "Web Design", progress: 75 },
  { name: "Mobile App UI", type: "App Development", progress: 45 },
  { name: "SEO Campaign", type: "Marketing", progress: 90 },
];

const menuItems = [
  { icon: Settings, label: "Account Settings", badge: null },
  { icon: Bell, label: "Notifications", badge: "3" },
  { icon: Shield, label: "Privacy & Security", badge: null },
  { icon: CreditCard, label: "Billing", badge: null },
  { icon: HelpCircle, label: "Help & Support", badge: null },
];

export default function ProfileScreen() {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-gradient-to-b from-blue-50 to-white">
      {/* Header with Profile */}
      <div className="bg-gradient-to-r from-blue-900 to-blue-700 text-white px-6 pt-8 pb-16">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="flex flex-col items-center"
        >
          <div className="w-24 h-24 bg-white/20 backdrop-blur-lg rounded-full flex items-center justify-center mb-4 border-4 border-white/30">
            <User size={48} className="text-white" strokeWidth={1.5} />
          </div>
          <h1 className="text-2xl font-bold mb-1">John Anderson</h1>
          <p className="text-blue-100">john.anderson@email.com</p>
        </motion.div>
      </div>

      <div className="px-6 -mt-8 space-y-6">
        {/* Stats Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-white rounded-3xl shadow-xl border border-blue-100 p-6"
        >
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-2xl font-bold text-blue-600">12</div>
              <div className="text-gray-600 text-sm">Projects</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-blue-600">8</div>
              <div className="text-gray-600 text-sm">Active</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-blue-600">4</div>
              <div className="text-gray-600 text-sm">Completed</div>
            </div>
          </div>
        </motion.div>

        {/* Saved Projects */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
              <Bookmark size={20} className="text-blue-600" />
              Saved Projects
            </h2>
          </div>

          <div className="space-y-3">
            {savedProjects.map((project, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.3 + index * 0.1 }}
                className="bg-white rounded-2xl p-5 shadow-lg border border-blue-100"
              >
                <div className="flex items-center justify-between mb-3">
                  <div>
                    <h3 className="font-bold text-gray-900">{project.name}</h3>
                    <p className="text-sm text-gray-600">{project.type}</p>
                  </div>
                  <span className="text-blue-600 font-semibold text-sm">{project.progress}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div
                    className="bg-gradient-to-r from-blue-600 to-blue-500 h-2 rounded-full transition-all"
                    style={{ width: `${project.progress}%` }}
                  />
                </div>
              </motion.div>
            ))}
          </div>
        </div>

        {/* Menu Items */}
        <div>
          <h2 className="text-xl font-bold text-gray-900 mb-4">Settings</h2>
          <div className="bg-white rounded-3xl shadow-lg border border-blue-100 overflow-hidden">
            {menuItems.map((item, index) => (
              <motion.button
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.6 + index * 0.05 }}
                whileHover={{ backgroundColor: "#eff6ff" }}
                className={`w-full flex items-center justify-between px-6 py-4 transition-colors ${
                  index !== menuItems.length - 1 ? "border-b border-gray-100" : ""
                }`}
              >
                <div className="flex items-center gap-4">
                  <item.icon size={20} className="text-blue-600" />
                  <span className="font-medium text-gray-900">{item.label}</span>
                </div>
                <div className="flex items-center gap-3">
                  {item.badge && (
                    <span className="bg-blue-600 text-white text-xs font-bold px-2 py-1 rounded-full">
                      {item.badge}
                    </span>
                  )}
                  <ChevronRight size={20} className="text-gray-400" />
                </div>
              </motion.button>
            ))}
          </div>
        </div>

        {/* Logout Button */}
        <motion.button
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.9 }}
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          className="w-full bg-gradient-to-r from-red-600 to-red-500 text-white py-4 rounded-2xl font-semibold flex items-center justify-center gap-3 shadow-lg"
        >
          <LogOut size={20} />
          Logout
        </motion.button>
      </div>
    </div>
  );
}
