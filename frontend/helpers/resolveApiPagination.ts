import { paramsServer } from "./paramsServer";

const PREFIX = process.env.NEXT_PUBLIC_PAGINATION_PREFIX ?? "paginate"
export async function resolveApiPagination(): Promise<Record<string, string>> {
    let searchParams: URLSearchParams;

    if (typeof window === "undefined") {
        const headerParams = await paramsServer()
        searchParams = new URLSearchParams(headerParams);
    } else {
        searchParams = new URLSearchParams(window.location.search);
    }

    const pagination: Record<string, string> = {};

    for (const [key, value] of searchParams.entries()) {
        if (key.startsWith(`${PREFIX}_`)) {
            pagination[key.replace(`${PREFIX}_`, "")] = value;
        }
    }

    return pagination;
}