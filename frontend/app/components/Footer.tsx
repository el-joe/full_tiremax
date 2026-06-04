export default function Footer() {
  return (
    <footer className="bg-[#0E0E0E] border-t border-white/10">
      {/* Contact Bar */}
      <div className="bg-[#161616] py-12">
        <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-10">
            <h2 className="text-white font-black text-3xl lg:text-4xl mb-3">تواصل معنا</h2>
            <div className="w-16 h-1 bg-[#FDB604] mx-auto rounded-full" />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              {
                icon: (
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                ),
                label: "الهاتف",
                value: "6622",
              },
              {
                icon: (
                  <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347zM11.99 2C6.476 2 2 6.477 2 11.99c0 1.962.535 3.795 1.468 5.364L2 22l4.773-1.452A9.956 9.956 0 0011.99 22C17.504 22 22 17.523 22 12.01 22 6.476 17.504 2 11.99 2z" />
                  </svg>
                ),
                label: "واتساب",
                value: "+964 770 000 6622",
              },
              {
                icon: (
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                ),
                label: "البريد",
                value: "support@tiremax.iq",
              },
              {
                icon: (
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                ),
                label: "الموقع",
                value: "الموصل، شارع الكورنيش",
              },
            ].map((item) => (
              <div key={item.label} className="bg-white/5 rounded-2xl p-5 text-right hover:bg-white/10 transition-colors cursor-pointer">
                <div className="text-[#FDB604] mb-3 flex justify-end">{item.icon}</div>
                <div className="text-white/50 text-xs mb-1">{item.label}</div>
                <div className="text-white font-bold text-sm">{item.value}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Main Footer */}
      <div className="py-12">
        <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10">
            {/* Brand */}
            <div className="text-right lg:col-span-1">
              <div className="text-[#FDB604] font-black text-3xl mb-4">
                Tire<span className="text-white">Max</span>
              </div>
              <p className="text-white/50 text-sm leading-relaxed mb-6">
                المتجر الأول للإطارات في العراق. نوفر أفضل الماركات العالمية بأسعار تنافسية وخدمة احترافية.
              </p>
              <div className="flex gap-3 justify-end">
                {["facebook", "instagram", "twitter", "tiktok"].map((social) => (
                  <a key={social} href="#" className="w-9 h-9 rounded-full bg-white/10 flex items-center justify-center text-white/60 hover:bg-[#FDB604] hover:text-black transition-all">
                    <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                      <circle cx="12" cy="12" r="5" />
                    </svg>
                  </a>
                ))}
              </div>
            </div>

            {/* Links */}
            {[
              {
                title: "روابط سريعة",
                links: ["الرئيسية", "الإطارات", "العروض", "المدونة", "عن الشركة"],
              },
              {
                title: "خدماتنا",
                links: ["تركيب الإطارات", "ضبط الزوايا", "خدمات الفرامل", "فحص المركبة", "التوصيل"],
              },
              {
                title: "ماركاتنا",
                links: ["Michelin", "Bridgestone", "Continental", "Goodyear", "Pirelli"],
              },
            ].map((section) => (
              <div key={section.title} className="text-right">
                <h4 className="text-white font-black text-sm mb-5">{section.title}</h4>
                <ul className="space-y-3">
                  {section.links.map((link) => (
                    <li key={link}>
                      <a href="#" className="text-white/50 text-sm hover:text-[#FDB604] transition-colors">{link}</a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>

          {/* Bottom */}
          <div className="mt-12 pt-6 border-t border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4">
            <p className="text-white/30 text-xs">جميع الحقوق محفوظة © ٢٠٢٦ TireMax</p>
            <div className="flex gap-6">
              <a href="#" className="text-white/30 text-xs hover:text-white/60 transition-colors">سياسة الخصوصية</a>
              <a href="#" className="text-white/30 text-xs hover:text-white/60 transition-colors">الشروط والأحكام</a>
            </div>
          </div>
        </div>
      </div>

      {/* WhatsApp Float */}
      <a
        href="#"
        className="fixed bottom-6 left-6 bg-[#25D366] text-white w-14 h-14 rounded-full flex items-center justify-center shadow-[0_8px_30px_rgba(37,211,102,0.4)] hover:scale-110 transition-transform z-50"
      >
        <svg className="w-7 h-7" fill="currentColor" viewBox="0 0 24 24">
          <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347zM11.99 2C6.476 2 2 6.477 2 11.99c0 1.962.535 3.795 1.468 5.364L2 22l4.773-1.452A9.956 9.956 0 0011.99 22C17.504 22 22 17.523 22 12.01 22 6.476 17.504 2 11.99 2z" />
        </svg>
      </a>
    </footer>
  );
}
