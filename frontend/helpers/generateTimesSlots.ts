export default function generateTimesSlots(startAt: string, endAt: string, intervalMinutes = 30) {
    const toMinutes = (time: string) => {
        const [hours, minutes] = time.split(":").map(Number)
        return hours * 60 + minutes
    }
    const toTimeString = (totalMinutes: number) => {
        const hours = Math.floor(totalMinutes / 60);
        const minutes = totalMinutes % 60;
        return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}`
    }
    const start = toMinutes(startAt)
    const end = toMinutes(endAt)
    const slots: string[] = []
    for (let current = start; current <= end; current += intervalMinutes) {
        slots.push(toTimeString(current))
    }
    return slots
}