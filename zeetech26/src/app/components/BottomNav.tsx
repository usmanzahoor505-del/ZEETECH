import { motion } from "motion/react";
import { Home, Briefcase, BarChart3, MessageCircle, User } from "lucide-react";

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

const navItems = [
  { id: "home", icon: Home, label: "Home" },
  { id: "services", icon: Briefcase, label: "Services" },
  { id: "dashboard", icon: BarChart3, label: "Analytics" },
  { id: "contact", icon: MessageCircle, label: "Contact" },
  { id: "profile", icon: User, label: "Profile" },
];

export default function BottomNav({ activeTab, onTabChange }: BottomNavProps) {
  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-2xl z-50">
      <div className="max-w-md mx-auto px-4 py-2">
        <div className="flex items-center justify-around">
          {navItems.map((item) => {
            const isActive = activeTab === item.id;
            return (
              <motion.button
                key={item.id}
                onClick={() => onTabChange(item.id)}
                whileTap={{ scale: 0.9 }}
                className="flex flex-col items-center gap-1 py-2 px-4 relative"
              >
                {isActive && (
                  <motion.div
                    layoutId="activeTab"
                    className="absolute inset-0 bg-blue-50 rounded-2xl"
                    transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                  />
                )}
                <item.icon
                  size={24}
                  className={`relative z-10 transition-colors ${
                    isActive ? "text-blue-600" : "text-gray-400"
                  }`}
                  strokeWidth={isActive ? 2.5 : 2}
                />
                <span
                  className={`text-xs font-medium relative z-10 transition-colors ${
                    isActive ? "text-blue-600" : "text-gray-400"
                  }`}
                >
                  {item.label}
                </span>
              </motion.button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
