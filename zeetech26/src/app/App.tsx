import { useState, useEffect } from "react";
import { AnimatePresence } from "motion/react";
import SplashScreen from "./components/SplashScreen";
import ZeetechHomeScreen from "./components/ZeetechHomeScreen";
import ZeetechServicesScreen from "./components/ZeetechServicesScreen";
import ServiceDetailScreen from "./components/ServiceDetailScreen";
import BookingFormScreen from "./components/BookingFormScreen";
import ZeetechAboutScreen from "./components/ZeetechAboutScreen";
import ZeetechContactScreen from "./components/ZeetechContactScreen";
import ZeetechBottomNav from "./components/ZeetechBottomNav";
import FloatingWhatsAppButton from "./components/FloatingWhatsAppButton";
import FeedbackBottomSheet from "./components/FeedbackBottomSheet";

type AppState = "splash" | "main";

export default function App() {
  const [appState, setAppState] = useState<AppState>("splash");
  const [activeTab, setActiveTab] = useState("home");
  const [selectedService, setSelectedService] = useState<string | null>(null);
  const [showBookingForm, setShowBookingForm] = useState(false);
  const [showFeedback, setShowFeedback] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      if (appState === "splash") {
        setAppState("main");
      }
    }, 3000);
    return () => clearTimeout(timer);
  }, [appState]);

  const handleSplashComplete = () => {
    setAppState("main");
  };

  const handleNavigate = (screen: string, serviceId?: string) => {
    if (screen === "service-detail" && serviceId) {
      setSelectedService(serviceId);
    } else {
      setSelectedService(null);
    }
    setActiveTab(screen);
  };

  const handleBookService = () => {
    setShowBookingForm(true);
  };

  const renderContent = () => {
    if (selectedService) {
      return (
        <ServiceDetailScreen
          serviceId={selectedService}
          onNavigate={handleNavigate}
          onBook={handleBookService}
        />
      );
    }

    switch (activeTab) {
      case "home":
        return <ZeetechHomeScreen onNavigate={handleNavigate} />;
      case "services":
        return <ZeetechServicesScreen onNavigate={handleNavigate} />;
      case "about":
        return <ZeetechAboutScreen />;
      case "contact":
        return <ZeetechContactScreen />;
      default:
        return <ZeetechHomeScreen onNavigate={handleNavigate} />;
    }
  };

  return (
    <div className="size-full flex items-center justify-center bg-[#E5E9F0]">
      <div className="relative w-full max-w-md h-full bg-[#F5F7FA] shadow-2xl overflow-hidden">
        <AnimatePresence mode="wait">
          {appState === "splash" && (
            <SplashScreen key="splash" onComplete={handleSplashComplete} />
          )}
          {appState === "main" && (
            <div key="main" className="h-full">
              {renderContent()}
              <ZeetechBottomNav activeTab={activeTab} onTabChange={setActiveTab} />
              <FloatingWhatsAppButton />
            </div>
          )}
        </AnimatePresence>

        {/* Booking Form Modal */}
        <BookingFormScreen
          isOpen={showBookingForm}
          onClose={() => setShowBookingForm(false)}
          serviceName={selectedService ? `${selectedService} Service` : "Service"}
        />

        {/* Feedback Bottom Sheet */}
        <FeedbackBottomSheet
          isOpen={showFeedback}
          onClose={() => setShowFeedback(false)}
        />

        {/* Floating Feedback Button */}
        {!showFeedback && appState === "main" && (
          <button
            onClick={() => setShowFeedback(true)}
            className="fixed bottom-44 right-6 bg-gradient-to-r from-[#0057FF] to-[#00C2FF] text-white px-4 py-2 rounded-full shadow-lg text-sm font-semibold z-40"
          >
            ⭐ Feedback
          </button>
        )}
      </div>
    </div>
  );
}