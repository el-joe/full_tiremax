"use client";
import { useLang } from "../context/LanguageContext";

export default function Hero() {
  const { t } = useLang();
  const h = t.hero;

  return (
    <section className="relative min-h-screen bg-[#0E0E0E] overflow-hidden flex items-center">
      {/* Background */}
      <div
        className="absolute inset-0 bg-cover bg-center bg-no-repeat opacity-40"
        style={{ backgroundImage: "url('https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1440&q=80')" }}
      />
      <div className="absolute inset-0 bg-linear-to-l from-[#0E0E0E] via-[#0E0E0E]/70 to-transparent" />

      <div className="relative max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8 pt-24 pb-16 w-full">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Text */}
          <div className="text-right order-1">
            <h1 className="text-4xl sm:text-5xl lg:text-6xl xl:text-7xl font-black leading-tight mb-6">
              <span className="text-white block">{h.line1}</span>
              <span className="text-white block">{h.line2}</span>
              <span className="text-[#FDB604] block">{h.line3}</span>
            </h1>
            <p className="text-white/70 text-base lg:text-lg leading-relaxed mb-10 max-w-md mr-auto ml-0 lg:mr-0 lg:ml-auto">
              {h.description}
            </p>
            <div className="flex flex-wrap gap-4 justify-end">
              <button className="bg-[#FDB604] text-black font-black text-base px-8 py-4 rounded-full hover:bg-yellow-400 transition-all hover:scale-105 shadow-[0_10px_40px_rgba(253,182,4,0.4)]">
                {h.shopNow}
              </button>
              <button className="border-2 border-white/30 text-white font-bold text-base px-8 py-4 rounded-full hover:border-[#FDB604] hover:text-[#FDB604] transition-all flex items-center gap-3">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                {h.watchVideo}
              </button>
            </div>

            {/* Stats */}
            <div className="mt-14 grid grid-cols-3 gap-6 border-t border-white/10 pt-8">
              {[
                { value: "500+", label: h.stats.brands },
                { value: "10,000+", label: h.stats.customers },
                { value: "24/7", label: h.stats.support },
              ].map((stat) => (
                <div key={stat.label} className="text-right">
                  <div className="text-[#FDB604] font-black text-2xl lg:text-3xl">{stat.value}</div>
                  <div className="text-white/60 text-xs lg:text-sm mt-1">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>

          {/* Image */}
          <div className="hidden lg:flex justify-center items-center order-2">
            <div className="relative w-full max-w-lg">
              <div className="absolute inset-0 bg-[#FDB604]/20 rounded-full blur-3xl scale-75" />
              <img
                src="https://images.unsplash.com/photo-1600661653561-629509216228?w=600&q=80"
                alt="tire"
                className="relative w-full object-contain mix-blend-luminosity"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Search Bar */}
      <div className="absolute bottom-0 left-0 right-0 bg-white rounded-t-[50px] shadow-2xl">
        <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 items-end">
            {[
              { label: h.search.car, placeholder: h.search.carPlaceholder },
              { label: h.search.model, placeholder: h.search.modelPlaceholder },
              { label: h.search.year, placeholder: h.search.yearPlaceholder },
              { label: h.search.size, placeholder: h.search.sizePlaceholder },
            ].map((field) => (
              <div key={field.label} className="flex flex-col gap-2">
                <label className="text-sm font-black text-[#1A1C1C] text-right">{field.label}</label>
                <div className="relative">
                  <select className="w-full bg-[#F5F5F5] border border-[#E8E8E8] rounded-xl px-4 py-3 text-sm font-bold text-[#6B7280] text-right appearance-none focus:outline-none focus:border-[#FDB604] cursor-pointer">
                    <option>{field.placeholder}</option>
                  </select>
                  <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#6B7280] pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </div>
              </div>
            ))}
          </div>
          <div className="mt-4 flex justify-start">
            <button className="bg-[#FDB604] text-black font-black text-sm px-8 py-3 rounded-xl hover:bg-yellow-400 transition-all shadow-[0_8px_20px_rgba(253,182,4,0.3)] flex items-center gap-2">
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
              {h.search.button}
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
