const features = [
  {
    title: "سرعة التوصيل",
    description: "توصيل سريع لباب بيتك في غضون ٢٤ ساعة",
    image: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=400&q=80",
  },
  {
    title: "ضمان دولي",
    description: "ضمان أصلي من الشركة المصنّعة على جميع المنتجات",
    image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80",
  },
  {
    title: "ضمان جانبي",
    description: "نضمن جودة الخدمة وراحتك التامة",
    image: "https://images.unsplash.com/photo-1530099486328-e021101a494a?w=400&q=80",
  },
];

export default function WhyUs() {
  return (
    <section className="bg-[#0E0E0E] py-16 lg:py-24">
      <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-white font-black text-3xl lg:text-4xl">
            لماذا تختار <span className="text-[#FDB604]">TireMax</span>
          </h2>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
          {features.map((f) => (
            <div key={f.title} className="relative rounded-3xl overflow-hidden group cursor-pointer aspect-[4/5]">
              <img
                src={f.image}
                alt={f.title}
                className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
              <div className="absolute bottom-0 left-0 right-0 p-6 text-right">
                <h3 className="text-white font-black text-xl mb-2">{f.title}</h3>
                <p className="text-white/70 text-sm leading-relaxed">{f.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
