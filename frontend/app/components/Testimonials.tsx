const reviews = [
  {
    name: "محمد حسين",
    rating: 5,
    text: "خدمة ممتازة وسريعة، الإطارات وصلت في نفس اليوم. سعر مناسب وجودة عالية. سأتعامل معهم دائماً.",
    avatar: "م",
    date: "منذ أسبوع",
  },
  {
    name: "أحمد محمد",
    rating: 5,
    text: "تجربة شراء رائعة، الموظفون محترفون ومتعاونون. الإطارات أصلية بالكامل ومع ضمان المصنع.",
    avatar: "أ",
    date: "منذ أسبوعين",
  },
  {
    name: "كريم سعيد",
    rating: 5,
    text: "أفضل متجر إطارات في بغداد! أسعار تنافسية وخدمة احترافية. الفريق متخصص ويعرف كيف يساعدك.",
    avatar: "ك",
    date: "منذ شهر",
  },
];

export default function Testimonials() {
  return (
    <section className="bg-white py-16 lg:py-24">
      <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-[#1A1C1C] font-black text-3xl lg:text-4xl mb-3">آراء عملائنا</h2>
          <div className="flex items-center justify-center gap-1">
            {[...Array(5)].map((_, i) => (
              <svg key={i} className="w-5 h-5 text-[#FDB604]" viewBox="0 0 20 20" fill="currentColor">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
            ))}
            <span className="text-[#6B7280] text-sm font-bold mr-2">٤.٩ من ٥</span>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {reviews.map((review) => (
            <div key={review.name} className="bg-[#F9F9F9] rounded-3xl p-6 text-right">
              <div className="flex items-center gap-1 justify-end mb-4">
                {[...Array(review.rating)].map((_, i) => (
                  <svg key={i} className="w-4 h-4 text-[#FDB604]" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                ))}
              </div>
              <p className="text-[#374151] text-sm leading-relaxed mb-6">&ldquo;{review.text}&rdquo;</p>
              <div className="flex items-center justify-end gap-3 border-t border-[#E8E8E8] pt-4">
                <div>
                  <div className="text-[#1A1C1C] font-black text-sm">{review.name}</div>
                  <div className="text-[#9CA3AF] text-xs">{review.date}</div>
                </div>
                <div className="w-10 h-10 rounded-full bg-[#FDB604] flex items-center justify-center text-black font-black text-sm">
                  {review.avatar}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
