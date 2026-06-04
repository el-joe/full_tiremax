export default function BookingCTA() {
  return (
    <section className="bg-[#FDB604] py-16 lg:py-20 relative overflow-hidden">
      {/* Background decoration */}
      <div className="absolute left-0 top-0 bottom-0 w-1/2 opacity-10">
        <div className="w-full h-full bg-black/20 rounded-r-full scale-150 translate-x-[-30%]" />
      </div>

      <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8 relative">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Left: booking form preview */}
          <div className="bg-white rounded-3xl p-6 shadow-2xl">
            <h3 className="text-[#1A1C1C] font-black text-lg mb-6 text-right">خدمات السريعة</h3>
            <div className="space-y-3">
              {["تغيير إطارات", "ضبط الزوايا", "فحص الفرامل", "تعبئة نيتروجين"].map((service) => (
                <div key={service} className="flex items-center justify-between bg-[#F5F5F5] rounded-xl px-4 py-3">
                  <div className="w-5 h-5 rounded-full border-2 border-[#FDB604]" />
                  <span className="text-[#1A1C1C] font-bold text-sm">{service}</span>
                </div>
              ))}
            </div>
            <button className="w-full mt-6 bg-[#FDB604] text-black font-black py-3.5 rounded-xl hover:bg-yellow-400 transition-all text-sm flex items-center justify-center gap-2">
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              احجز موعد الصيانة
            </button>
            <div className="mt-4 bg-[#FDB604]/10 rounded-xl px-4 py-2.5 text-center">
              <span className="text-[#1A1C1C] font-black text-2xl">٥٠٠+ </span>
              <span className="text-[#6B7280] text-sm font-bold">حجز هذا الشهر</span>
            </div>
          </div>

          {/* Right: text */}
          <div className="text-right">
            <h2 className="text-black font-black text-3xl lg:text-5xl leading-tight mb-6">
              احجز صيانة<br />
              سيارتك الآن
            </h2>
            <div className="space-y-4 mb-8">
              {[
                { icon: "📅", text: "مواعيد مرنة تناسب جدولك" },
                { icon: "🏪", text: "أكثر من ١٠ فروع في بغداد" },
                { icon: "⭐", text: "فنيون معتمدون وذوو خبرة" },
              ].map((item) => (
                <div key={item.text} className="flex items-center gap-3 justify-end">
                  <span className="text-[#1A1C1C] font-bold text-sm">{item.text}</span>
                  <span className="text-xl">{item.icon}</span>
                </div>
              ))}
            </div>
            <button className="bg-black text-white font-black text-sm px-8 py-4 rounded-xl hover:bg-[#1A1C1C] transition-all flex items-center gap-2 mr-auto">
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z" />
                <path d="M11.99 2C6.476 2 2 6.477 2 11.99c0 1.962.535 3.795 1.468 5.364L2 22l4.773-1.452A9.956 9.956 0 0011.99 22C17.504 22 22 17.523 22 12.01 22 6.476 17.504 2 11.99 2z" />
              </svg>
              اضغط هنا للتواصل عبر الواتس
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
