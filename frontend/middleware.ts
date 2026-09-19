import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";
const GUEST_COOKIE = "tiremax_guest";
import { NextRequest, NextResponse } from "next/server";

const PROTECTED_ROUTES = [
  "/profile",
  "/favorites",
  "/notifications",
];

function isAuthenticated(request: NextRequest): boolean {
  const token = request.cookies.get("tiremax_token");
  return !!token?.value;
}

function isProtectedRoute(pathname: string): boolean {
  // Remove locale prefix to check the base path
  const pathWithoutLocale = pathname.replace(/^\/[a-z]{2}(?=\/|$)/, "") || "/";

  // Check if it's a public route
  return PROTECTED_ROUTES.some(
    (route) =>
      pathWithoutLocale === route || pathWithoutLocale.startsWith(`${route}/`),
  );
}

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const authenticated = isAuthenticated(request);
  const protectedRoute = isProtectedRoute(pathname);
  // Email links (/profile/orders/{ref}?phone=, /profile/bookings[/ref]) -> guest tracking page
  if (!authenticated && protectedRoute) {
    const m = pathname.match(
      /^\/([a-z]{2})\/profile\/(orders|bookings|reservation)(?:\/([A-Za-z0-9-]+))?\/?$/,
    );
    if (m && (m[3] || m[2] === "bookings" || m[2] === "reservation")) {
      // (guests only; logged-in users keep the real /profile/* routes)
      const url = new URL(`/${m[1]}/track-order`, request.url);
      const type = m[2] === "orders" ? "order" : "booking";
      url.searchParams.set("type", type);
      if (m[3]) url.searchParams.set("reference", m[3]);
      const phone = request.nextUrl.searchParams.get("phone");
      if (phone) url.searchParams.set("phone", phone);
      return NextResponse.redirect(url);
    }
  }
  // If not authenticated and trying to access protected route
  if (!authenticated && protectedRoute) {
    return NextResponse.redirect(new URL("/?authDialog=on", request.url));
  }
  const i18nMiddleware = createMiddleware(routing);
  const response = i18nMiddleware(request);
  response.headers.set("x-pathname", request.nextUrl.pathname);
  if (!request.cookies.get(GUEST_COOKIE)?.value) {
    response.cookies.set(GUEST_COOKIE, crypto.randomUUID(), {
      maxAge: 60 * 60 * 24 * 365,
      sameSite: "lax",
      path: "/",
    });
  }
  response.headers.set("x-params", request.nextUrl.searchParams.toString());

  return response;
}
export const config = {
  // Match all pathnames except for
  // - … if they start with `/api`, `/trpc`, `/_next` or `/_vercel`
  // - … the ones containing a dot (e.g. `favicon.ico`)
  matcher: "/((?!api|trpc|_next|_vercel|.*\\..*).*)",
};
