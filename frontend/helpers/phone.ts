/** Mirrors backend App\Support\Phone (Iraqi numbers -> 9647XXXXXXXXX). */
export function normalizeIraqiPhone(phone: string): string {
  let digits = phone.replace(/\D+/g, "");
  if (digits.startsWith("00964")) digits = digits.slice(2);
  if (digits.startsWith("964")) return digits;
  if (digits.startsWith("0")) return "964" + digits.slice(1);
  if (digits.length === 10 && digits[0] === "7") return "964" + digits;
  return digits;
}

export const isValidIraqiPhone = (phone: string): boolean =>
  /^9647\d{9}$/.test(normalizeIraqiPhone(phone));
