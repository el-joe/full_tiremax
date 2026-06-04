"use client";
import { useState } from "react";

type BadgeVariant = "bestseller" | "best-choice" | "new" | "offer";

interface ProductCardProps {
  brand: string;
  name: string;
  size: string;
  feature: string;
  rating: number;
  reviewCount: number;
  price: string;
  oldPrice?: string;
  badge?: { label: string; variant: BadgeVariant };
  image?: string;
}

const badgeStyles: Record<BadgeVariant, string> = {
  bestseller: "bg-[#FDB604] text-black",
  "best-choice": "bg-[#2E7D32] text-white",
  new: "bg-[#1976D2] text-white",
  offer: "bg-red-500 text-white",
};

export default function ProductCard({
  brand, name, size, feature, rating, reviewCount, price, oldPrice, badge, image,
}: ProductCardProps) {
  const [favorited, setFavorited] = useState(false);

  return (
    <div className="bg-[#F9F9F9] rounded-[32px] p-6 flex flex-col gap-6 shadow-[0_20px_25px_-5px_rgba(26,28,28,0.05),0_8px_10px_-6px_rgba(26,28,28,0.05)] hover:shadow-xl transition-shadow w-full">
      {/* Image */}
      <div className="relative">
        <div className="bg-[#EEEEEE] rounded-2xl overflow-hidden aspect-square w-full flex items-center justify-center">
          {image ? (
            <img src={image} alt={name} className="w-full h-full object-cover mix-blend-multiply" />
          ) : (
            <div className="w-full h-full bg-gradient-to-br from-[#E0E0E0] to-[#CCCCCC] flex items-center justify-center">
              <svg className="w-24 h-24 text-[#AAAAAA]" viewBox="0 0 24 24" fill="currentColor">
                <circle cx="12" cy="12" r="10" />
                <circle cx="12" cy="12" r="4" fill="#D0D0D0" />
                <circle cx="12" cy="12" r="2" fill="#C0C0C0" />
              </svg>
            </div>
          )}
        </div>

        {/* Badge */}
        {badge && (
          <div className={`absolute top-3 right-3 px-3 py-1 rounded-xl text-[10px] font-black ${badgeStyles[badge.variant]}`}>
            {badge.label}
          </div>
        )}

        {/* Favorite */}
        <button
          onClick={() => setFavorited(!favorited)}
          className="absolute top-3 left-3 p-1"
        >
          <svg
            className={`w-6 h-6 transition-colors ${favorited ? "text-[#FDB604] fill-[#FDB604]" : "text-[#FDB604]"}`}
            fill={favorited ? "currentColor" : "none"}
            stroke="currentColor"
            strokeWidth={2}
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
          </svg>
        </button>
      </div>

      {/* Info */}
      <div className="flex flex-col gap-1 text-right">
        {/* Brand */}
        <div className="flex justify-end">
          <span className="bg-[#E8E8E8] text-[#6B7280] text-[10px] font-bold tracking-widest uppercase px-3 py-1 rounded-xl">
            {brand}
          </span>
        </div>

        {/* Name */}
        <h3 className="text-[#1A1C1C] font-bold text-lg leading-7">{name}</h3>

        {/* Tags */}
        <div className="flex gap-2 justify-end flex-wrap pt-1">
          <span className="bg-[#E8E8E8] text-[#333] text-[10px] font-bold px-2 py-1 rounded-lg">{size}</span>
          <span className="bg-[#E8E8E8] text-[#333] text-[10px] font-bold px-2 py-1 rounded-lg">{feature}</span>
        </div>

        {/* Rating */}
        <div className="flex items-center justify-end gap-2 pt-1">
          <span className="text-[#6B7280] text-xs">({reviewCount})</span>
          <div className="flex gap-0.5">
            {[...Array(5)].map((_, i) => (
              <svg key={i} className={`w-3 h-3 ${i < rating ? "text-[#FDB604]" : "text-[#D1D5DB]"}`} viewBox="0 0 20 20" fill="currentColor">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
            ))}
          </div>
        </div>

        {/* Price + Add to cart */}
        <div className="flex items-center justify-between pt-4">
          <button className="bg-[#FDB604] text-white w-11 h-11 rounded-xl flex items-center justify-center hover:bg-yellow-400 transition-all shadow-[0_10px_15px_-3px_rgba(255,184,0,0.3)] hover:scale-105">
            <svg className="w-5 h-5" fill="none" stroke="currentColor" strokeWidth={2.5} viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
          </button>
          <div className="text-right">
            <div className="text-[#18181B] font-black text-2xl leading-none">{price}</div>
            {oldPrice && (
              <div className="text-[#6B7280] text-xs font-bold line-through mt-1">{oldPrice}</div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
