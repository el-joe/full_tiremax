export default function generateYearsSlots(from?: number, to?: number) {
  if (!from || !to) return [];
  const yearsSlots = [];
  for (let start = from; start <= to; ++start) {
    yearsSlots.push(start);
  }
  return yearsSlots;
}
