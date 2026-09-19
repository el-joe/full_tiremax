export type PublicSettings = {
  site_name: string | null;
  site_tagline: string | null;
  site_email: string | null;
  site_phone: string | null;
  whatsapp_number: string | null;
  address: string | null;
  whatsapp_default_message: string | null;
  whatsapp_url: string | null;
  whatsapp_url_fallback: string | null;
  whatsapp_button_enabled: boolean;
  social: Record<string, string | null>;
};

export async function getPublicSettings(
  locale: string,
): Promise<PublicSettings | null> {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_BASE_API_URL}/settings/public`,
      {
        headers: { "x-locale": locale, Accept: "application/json" },
        next: { revalidate: 60 },
      },
    );
    if (!res.ok) return null;
    const json = await res.json();
    return json.data ?? null;
  } catch {
    return null;
  }
}
