export default function formatTimeRange(opensAt: string, closesAt: string, locale = "ar") {
    if (!opensAt || !closesAt) return
    const formatTime = (time: string) => {
        const [hours, minutes] = time.split(":").map(Number);

        const date = new Date();
        date.setHours(hours, minutes);

        return new Intl.DateTimeFormat(`${locale}-US`, {
            hour: "numeric",
            minute: "2-digit",
            hour12: true,
        }).format(date);
    };

    return `${formatTime(opensAt)} - ${formatTime(closesAt)}`;
}