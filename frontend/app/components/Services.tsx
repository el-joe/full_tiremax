const services = [
  {
    title: "تركيب الإطارات",
    description: "تركيب احترافي بأيدي خبراء معتمدين",
    image: "https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?w=400&q=80",
    icon: "🔧",
  },
  {
    title: "ضبط الزوايا",
    description: "ضبط دقيق لزوايا العجلات لأفضل أداء",
    image: "https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=400&q=80",
    icon: "⚙️",
  },
  {
    title: "خدمات الفرامل",
    description: "فحص وصيانة نظام الفرامل بالكامل",
    image: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80",
    icon: "🛑",
  },
  {
    title: "فحص الإطارات",
    description: "فحص شامل لحالة الإطارات والضغط",
    image: "https://images.unsplash.com/photo-1609592806596-b22b4a2af5e6?w=400&q=80",
    icon: "🔍",
  },
];

export default function Services() {
  return (
    <section className="bg-[#0E0E0E] py-16 lg:py-24">
      <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Images Grid */}
          <div className="grid grid-cols-2 gap-4">
            {services.map((s, i) => (
              <div key={i} className="relative rounded-2xl overflow-hidden aspect-square group cursor-pointer">
                <img
                  src={s.image}
                  alt={s.title}
                  className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                />
                <div className="absolute inset-0 bg-black/40 group-hover:bg-black/20 transition-colors" />
                <div className="absolute bottom-3 right-3 text-right">
                  <div className="text-white font-black text-sm">{s.title}</div>
                </div>
              </div>
            ))}
          </div>

          {/* Text */}
          <div className="text-right">
            <div className="inline-block bg-[#FDB604]/10 border border-[#FDB604]/30 text-[#FDB604] text-xs font-black px-4 py-2 rounded-full mb-6">
              خدماتنا المتكاملة
            </div>
            <h2 className="text-white font-black text-3xl lg:text-4xl leading-snug mb-6">
              حلول متكاملة<br />
              <span className="text-[#FDB604]">لسيارتك</span>
            </h2>
            <p className="text-white/60 leading-relaxed mb-8">
              نقدم مجموعة شاملة من الخدمات الاحترافية لسيارتك، من تركيب الإطارات إلى ضبط الزوايا والفرامل. فريقنا المتخصص جاهز لخدمتك على مدار الساعة.
            </p>
            <div className="flex flex-wrap gap-4 justify-end">
              <button className="bg-[#FDB604] text-black font-black text-sm px-8 py-3.5 rounded-xl hover:bg-yellow-400 transition-all shadow-[0_10px_30px_rgba(253,182,4,0.3)]">
                احجز موعد الآن
              </button>
              <button className="border border-white/20 text-white font-bold text-sm px-8 py-3.5 rounded-xl hover:border-[#FDB604] hover:text-[#FDB604] transition-all">
                تعرف أكثر
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
