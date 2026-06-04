import ProductCard from "./ProductCard";

const products = [
  {
    brand: "MICHELIN",
    name: "ميشلان بايلوت سبورت 4",
    size: "225/45 R17",
    feature: "ثبات عالي",
    rating: 5,
    reviewCount: 210,
    price: "١٢٥,٠٠٠ د.ع",
    oldPrice: "١٢٧,٠٠٠ د.ع",
    badge: { label: "الأكثر مبيعاً", variant: "bestseller" as const },
    image: "https://images.unsplash.com/photo-1621963590734-5c6fec74e7b2?w=400&q=80",
  },
  {
    brand: "MICHELIN",
    name: "ميشلان بايلوت سبورت 4",
    size: "225/45 R17",
    feature: "ثبات عالي",
    rating: 5,
    reviewCount: 210,
    price: "١٢٥,٠٠٠ د.ع",
    oldPrice: "١٢٧,٠٠٠ د.ع",
    badge: { label: "جديد", variant: "new" as const },
    image: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80",
  },
  {
    brand: "BRIDGESTONE",
    name: "بريدجستون تورينزا T005",
    size: "205/55 R16",
    feature: "راحة عالية",
    rating: 5,
    reviewCount: 185,
    price: "١٦٠,٠٠٠ د.ع",
    badge: { label: "أفضل خيار", variant: "best-choice" as const },
    image: "https://images.unsplash.com/photo-1609592806596-b22b4a2af5e6?w=400&q=80",
  },
  {
    brand: "BRIDGESTONE",
    name: "بريدجستون بوتنزا S001",
    size: "245/40 R18",
    feature: "راحة عالية",
    rating: 5,
    reviewCount: 95,
    price: "١٦٠,٠٠٠ د.ع",
    image: "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=400&q=80",
  },
];

interface FeaturedProductsProps {
  title: string;
  subtitle?: string;
}

export default function FeaturedProducts({ title, subtitle }: FeaturedProductsProps) {
  return (
    <section className="bg-white py-16 lg:py-24">
      <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-10">
          <a href="#" className="text-[#FDB604] font-bold text-sm hover:underline flex items-center gap-1">
            عرض الكل
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
            </svg>
          </a>
          <div className="text-right">
            <h2 className="text-[#1A1C1C] font-black text-2xl lg:text-3xl">{title}</h2>
            {subtitle && <p className="text-[#6B7280] text-sm mt-1">{subtitle}</p>}
          </div>
        </div>

        {/* Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {products.map((product, i) => (
            <ProductCard key={i} {...product} />
          ))}
        </div>
      </div>
    </section>
  );
}
