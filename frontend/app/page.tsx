import Navbar from "./components/Navbar";
import Hero from "./components/Hero";
import FeaturedProducts from "./components/FeaturedProducts";
import Services from "./components/Services";
import BookingCTA from "./components/BookingCTA";
import WhyUs from "./components/WhyUs";
import Testimonials from "./components/Testimonials";
import Footer from "./components/Footer";

export default function Home() {
  return (
    <main>
      <Navbar />
      <Hero />
      {/* Spacer for the search bar that overlaps the bottom of the hero */}
      <div className="h-48 sm:h-56 bg-white" />
      <FeaturedProducts title="إطارات مختارة لك" subtitle="أفضل الإطارات بناءً على سيارتك" />
      <Services />
      <BookingCTA />
      <FeaturedProducts title="عروض مختارة لك" subtitle="أقل الأسعار وأفضل العروض" />
      <WhyUs />
      <Testimonials />
      <Footer />
    </main>
  );
}
