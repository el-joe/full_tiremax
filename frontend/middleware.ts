import createMiddleware from "next-intl/middleware";
import { routing } from "./i18n/routing";
import { NextRequest, NextResponse } from "next/server";

const PROTECTED_ROUTES = ["/profile", "/cart", "/checkout", "/favorites"];

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
  // If not authenticated and trying to access protected route
  if (!authenticated && protectedRoute) {
    return NextResponse.redirect(new URL("/?authDialog=on", request.url));
  }
  const i18nMiddleware = createMiddleware(routing);
  const response = i18nMiddleware(request);
  response.headers.set("x-pathname", request.nextUrl.pathname);
  response.headers.set("x-params", request.nextUrl.searchParams.toString());

  return response;
}
export const config = {
  // Match all pathnames except for
  // - … if they start with `/api`, `/trpc`, `/_next` or `/_vercel`
  // - … the ones containing a dot (e.g. `favicon.ico`)
  matcher: "/((?!api|trpc|_next|_vercel|.*\\..*).*)",
};
