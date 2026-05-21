import { motion } from "motion/react";
import {
  TrendingUp,
  DollarSign,
  Users,
  MousePointerClick,
  BarChart3,
  ArrowUp,
  ArrowDown,
} from "lucide-react";
import { LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

const stats = [
  {
    icon: DollarSign,
    label: "Revenue",
    value: "$124.5K",
    change: "+12.5%",
    trend: "up",
    gradient: "from-blue-600 to-blue-500",
  },
  {
    icon: Users,
    label: "Leads",
    value: "1,234",
    change: "+8.2%",
    trend: "up",
    gradient: "from-blue-700 to-blue-600",
  },
  {
    icon: MousePointerClick,
    label: "Clicks",
    value: "45.2K",
    change: "-2.4%",
    trend: "down",
    gradient: "from-blue-800 to-blue-700",
  },
  {
    icon: TrendingUp,
    label: "Conversion",
    value: "3.4%",
    change: "+0.8%",
    trend: "up",
    gradient: "from-blue-900 to-blue-800",
  },
];

const lineData = [
  { name: "Jan", value: 4000 },
  { name: "Feb", value: 3000 },
  { name: "Mar", value: 5000 },
  { name: "Apr", value: 4500 },
  { name: "May", value: 6000 },
  { name: "Jun", value: 5500 },
];

const barData = [
  { name: "SEO", value: 4000 },
  { name: "Social", value: 3000 },
  { name: "PPC", value: 2000 },
  { name: "Email", value: 2780 },
  { name: "Content", value: 1890 },
];

const campaigns = [
  { name: "Summer Sale 2026", status: "Active", performance: 85, budget: "$2,500" },
  { name: "Brand Awareness", status: "Active", performance: 92, budget: "$1,800" },
  { name: "Product Launch", status: "Paused", performance: 68, budget: "$3,200" },
];

export default function DashboardScreen() {
  return (
    <div className="h-full overflow-y-auto pb-20 bg-gradient-to-b from-blue-50 to-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-900 to-blue-700 text-white px-6 py-8">
        <motion.h1
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-3xl font-bold mb-2"
        >
          Dashboard
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="text-blue-100"
        >
          Analytics overview for May 2026
        </motion.p>
      </div>

      <div className="px-6 py-8 space-y-6">
        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4">
          {stats.map((stat, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: index * 0.1 }}
              className="bg-white rounded-2xl p-5 shadow-lg border border-blue-100"
            >
              <div className={`bg-gradient-to-br ${stat.gradient} w-10 h-10 rounded-xl flex items-center justify-center mb-3`}>
                <stat.icon size={20} className="text-white" strokeWidth={2} />
              </div>
              <div className="text-2xl font-bold text-gray-900 mb-1">{stat.value}</div>
              <div className="text-gray-600 text-sm mb-2">{stat.label}</div>
              <div className={`flex items-center gap-1 text-sm font-semibold ${
                stat.trend === "up" ? "text-green-600" : "text-red-600"
              }`}>
                {stat.trend === "up" ? <ArrowUp size={14} /> : <ArrowDown size={14} />}
                {stat.change}
              </div>
            </motion.div>
          ))}
        </div>

        {/* Revenue Chart */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-white rounded-3xl p-6 shadow-xl border border-blue-100"
        >
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-bold text-gray-900">Revenue Trend</h2>
            <BarChart3 size={24} className="text-blue-600" />
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <LineChart data={lineData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
              <XAxis dataKey="name" stroke="#6b7280" style={{ fontSize: '12px' }} />
              <YAxis stroke="#6b7280" style={{ fontSize: '12px' }} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: '12px',
                }}
              />
              <Line type="monotone" dataKey="value" stroke="#3b82f6" strokeWidth={3} dot={{ fill: '#3b82f6' }} />
            </LineChart>
          </ResponsiveContainer>
        </motion.div>

        {/* Channel Performance */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="bg-white rounded-3xl p-6 shadow-xl border border-blue-100"
        >
          <h2 className="text-xl font-bold text-gray-900 mb-6">Channel Performance</h2>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={barData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
              <XAxis dataKey="name" stroke="#6b7280" style={{ fontSize: '12px' }} />
              <YAxis stroke="#6b7280" style={{ fontSize: '12px' }} />
              <Tooltip
                contentStyle={{
                  backgroundColor: '#fff',
                  border: '1px solid #e5e7eb',
                  borderRadius: '12px',
                }}
              />
              <Bar dataKey="value" fill="#3b82f6" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </motion.div>

        {/* Active Campaigns */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7 }}
        >
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Active Campaigns</h2>
          <div className="space-y-4">
            {campaigns.map((campaign, index) => (
              <div
                key={index}
                className="bg-white rounded-2xl p-5 shadow-lg border border-blue-100"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <h3 className="font-bold text-gray-900">{campaign.name}</h3>
                    <p className="text-sm text-gray-600">{campaign.budget}</p>
                  </div>
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-semibold ${
                      campaign.status === "Active"
                        ? "bg-green-100 text-green-700"
                        : "bg-yellow-100 text-yellow-700"
                    }`}
                  >
                    {campaign.status}
                  </span>
                </div>
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-gray-600">Performance</span>
                    <span className="font-semibold text-blue-600">{campaign.performance}%</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div
                      className="bg-gradient-to-r from-blue-600 to-blue-500 h-2 rounded-full transition-all"
                      style={{ width: `${campaign.performance}%` }}
                    />
                  </div>
                </div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>
    </div>
  );
}
