"use client";
import { useState } from "react";
import { useLang } from "../context/LanguageContext";

export default function Navbar() {
  const [menuOpen, setMenuOpen] = useState(false);
  const { t, locale, toggleLocale } = useLang();

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-[#0E0E0E]/95 backdrop-blur-sm border-b border-white/10">
      <div className="max-w-[1318px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 lg:h-20">
          {/* Logo */}
          <div className="flex items-center gap-2">
            <div className="text-[#FDB604] font-black text-2xl tracking-tight">
              Tire<span className="text-white">Max</span>
            </div>
          </div>

          {/* Desktop Nav Links */}
          <div className="hidden lg:flex items-center gap-8 text-sm font-bold text-white">
            <a href="#" className="hover:text-[#FDB604] transition-colors">{t.nav.home}</a>
            <a href="#" className="hover:text-[#FDB604] transition-colors">{t.nav.tires}</a>
            <a href="#" className="hover:text-[#FDB604] transition-colors">{t.nav.services}</a>
            <a href="#" className="hover:text-[#FDB604] transition-colors">{t.nav.offers}</a>
            <a href="#" className="hover:text-[#FDB604] transition-colors">{t.nav.contact}</a>
          </div>

          {/* Search + Actions */}
          <div className="hidden lg:flex items-center gap-3">
            <div className="relative">
              <input
                type="text"
                placeholder={t.nav.search}
                className="bg-white/10 border border-white/20 text-white placeholder-white/50 rounded-full px-4 py-2 text-sm w-48 focus:outline-none focus:border-[#FDB604] transition-colors"
              />
              <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <button className="relative p-2 text-white hover:text-[#FDB604] transition-colors">
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
              </svg>
            </button>
            <button className="relative p-2 text-white hover:text-[#FDB604] transition-colors">
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              <span className="absolute -top-1 -left-1 bg-[#FDB604] text-black text-xs rounded-full w-4 h-4 flex items-center justify-center font-black">3</span>
            </button>

            {/* Language toggle */}
            <button
              onClick={toggleLocale}
              className="border border-white/20 text-white font-bold text-xs px-3 py-1.5 rounded-full hover:border-[#FDB604] hover:text-[#FDB604] transition-all"
            >
              {locale === "ar" ? "EN" : "ع"}
            </button>

            <button className="bg-[#FDB604] text-black font-black text-sm px-5 py-2.5 rounded-full hover:bg-yellow-400 transition-colors">
              {t.nav.login}
            </button>
          </div>

          {/* Mobile: lang toggle + hamburger */}
          <div className="lg:hidden flex items-center gap-2">
            <button
              onClick={toggleLocale}
              className="border border-white/20 text-white font-bold text-xs px-3 py-1.5 rounded-full hover:border-[#FDB604] hover:text-[#FDB604] transition-all"
            >
              {locale === "ar" ? "EN" : "ع"}
            </button>
            <button
              className="text-white p-2"
              onClick={() => setMenuOpen(!menuOpen)}
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                {menuOpen
                  ? <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  : <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                }
              </svg>
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {menuOpen && (
          <div className="lg:hidden pb-4 border-t border-white/10 mt-2 pt-4 flex flex-col gap-3 text-white font-bold text-sm">
            <a href="#" className="hover:text-[#FDB604]">{t.nav.home}</a>
            <a href="#" className="hover:text-[#FDB604]">{t.nav.tires}</a>
            <a href="#" className="hover:text-[#FDB604]">{t.nav.services}</a>
            <a href="#" className="hover:text-[#FDB604]">{t.nav.offers}</a>
            <a href="#" className="hover:text-[#FDB604]">{t.nav.contact}</a>
            <button className="bg-[#FDB604] text-black font-black text-sm px-5 py-2.5 rounded-full w-full mt-2">
              {t.nav.login}
            </button>
          </div>
        )}
      </div>
    </nav>
  );
}
