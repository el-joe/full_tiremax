"use server"
import { headers } from "next/headers";

export const apiFilterServer = async () => {
    const headerParams = (await headers()).get("x-params") ?? "";
    return headerParams
}