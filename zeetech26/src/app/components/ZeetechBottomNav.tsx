import { motion } from "motion/react";
import { Home, Wrench, Info, Phone } from "lucide-react";

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

const navItems = [
  { id: "home", icon: Home, label: "Home", emoji: "🏠" },
  { id: "services", icon: Wrench, label: "Services", emoji: "🔧" },
  { id: "about", icon: Info, label: "About", emoji: "ℹ️" },
  { id: "contact", icon: Phone, label: "Contact", emoji: "📞" },
];

export default function ZeetechBottomNav({ activeTab, onTabChange }: BottomNavProps) {
  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-2xl z-40">
      <div className="max-w-md mx-auto px-2 py-1">
        <div className="flex items-center justify-around">
          {navItems.map((item) => {
            const isActive = activeTab === item.id;
            return (
              <motion.button
                key={item.id}
                onClick={() => onTabChange(item.id)}
                whileTap={{ scale: 0.9 }}
                className="flex flex-col items-center gap-1 py-2 px-4 relative min-w-[70px]"
              >
                {isActive && (
                  <motion.div
                    layoutId="activeTab"
                    className="absolute inset-0 bg-gradient-to-r from-[#0057FF]/10 to-[#00C2FF]/10 rounded-2xl"
                    transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                  />
                )}
                <item.icon
                  size={24}
                  className={`relative z-10 transition-colors ${
                    isActive ? "text-[#0057FF]" : "text-gray-400"
                  }`}
                  strokeWidth={isActive ? 2.5 : 2}
                />
                <span
                  className={`text-xs font-medium relative z-10 transition-colors ${
                    isActive ? "text-[#0057FF]" : "text-gray-400"
                  }`}
                >
                  {item.label}
                </span>
                {isActive && (
                  <motion.div
                    layoutId="activeIndicator"
                    className="absolute -top-0.5 left-1/2 -translate-x-1/2 w-12 h-1 bg-gradient-to-r from-[#0057FF] to-[#00C2FF] rounded-full"
                    transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                  />
                )}
              </motion.button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
