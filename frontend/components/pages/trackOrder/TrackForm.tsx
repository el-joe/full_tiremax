"use client";
import Input from "@/components/ui/Input";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { IOrder, IReservation } from "@/types";
import axiosInstance from "@/utils/axiosInstance";
import { Badge, Box, Button, HStack, Text, VStack } from "@chakra-ui/react";
import { AxiosError } from "axios";
import { useSearchParams } from "next/navigation";
import { useTranslations } from "next-intl";
import { useEffect, useRef, useState } from "react";

type TResult =
  | { kind: "order"; data: IOrder }
  | { kind: "booking"; data: IReservation };

export default function TrackForm() {
  const t = useTranslations("trackOrder");
  const params = useSearchParams();
  const [reference, setReference] = useState(params.get("reference") ?? "");
  const [phone, setPhone] = useState(params.get("phone") ?? "");
  const type = params.get("type"); // "order" | "booking" | null
  const [result, setResult] = useState<TResult | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const search = async (ref: string, ph: string) => {
    setError(null);
    setResult(null);
    if (!ref.trim() || !ph.trim()) {
      setError(t("required"));
      return;
    }
    setLoading(true);
    const kinds: ("order" | "booking")[] =
      type === "booking" ? ["booking", "order"] : ["order", "booking"];
    try {
      for (const kind of kinds) {
        try {
          const { data } = await axiosInstance.get(
            `${kind === "order" ? "orders" : "bookings"}/${encodeURIComponent(ref.trim())}`,
            { params: { phone: ph.trim() } },
          );
          setResult({ kind, data: data.data } as TResult);
          return;
        } catch (e) {
          if ((e as AxiosError).response?.status !== 404) throw e;
        }
      }
      setError(t("notFound"));
    } catch {
      setError(t("error"));
    } finally {
      setLoading(false);
    }
  };

  // auto-lookup when opened from an email link (?reference=&phone=)
  const auto = useRef(false);
  useEffect(() => {
    if (auto.current) return;
    auto.current = true;
    const r = params.get("reference");
    const p = params.get("phone");
    if (r && p) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      search(r, p);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <VStack align={"stretch"} maxW={"520px"} gap={"16px"}>
      <Text color={"gray-2"}>{t("description")}</Text>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          search(reference, phone);
        }}
      >
        <VStack align={"stretch"} gap={"16px"}>
          <Input
            label={t("reference")}
            value={reference}
            onChange={(e) => setReference(e.target.value)}
            h="auto"
            p="16px"
          />
          <Input
            label={t("phone")}
            type="tel"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            h="auto"
            p="16px"
          />
          <Button type="submit" loading={loading}>
            {t("track")}
          </Button>
        </VStack>
      </form>
      {error && <Text color={"red"}>{error}</Text>}
      {result && (
        <Box p="20px" border={"1px solid #E5E7EB"} rounded={"16px"}>
          <HStack justify={"space-between"} mb={"12px"}>
            <Text fontWeight={"bold"}>{result.data.reference}</Text>
            <Badge>{result.data.status}</Badge>
          </HStack>
          {result.kind === "order" ? (
            <VStack align={"stretch"} gap={"6px"}>
              {result.data.items?.map((i) => (
                <HStack key={i.id} justify={"space-between"}>
                  <Text>
                    {i.product_name} x{i.quantity}
                  </Text>
                  <Text>{i.total}</Text>
                </HStack>
              ))}
              <HStack justify={"space-between"} fontWeight={"bold"}>
                <Text>{t("total")}</Text>
                <Text>
                  {result.data.total} <CurrencySymbol />
                </Text>
              </HStack>
            </VStack>
          ) : (
            <VStack align={"stretch"} gap={"6px"}>
              <Text>{result.data.service?.name}</Text>
              <Text>{result.data.branch?.name}</Text>
              <Text>{new Date(result.data.scheduled_at).toLocaleString()}</Text>
            </VStack>
          )}
        </Box>
      )}
    </VStack>
  );
}
