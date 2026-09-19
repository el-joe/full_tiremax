import { Link as ChakraLink } from "@chakra-ui/react";
import { getTranslations } from "next-intl/server";
import { FaWhatsapp } from "react-icons/fa";
import type { PublicSettings } from "@/helpers/getPublicSettings";

const WhatsappFloatingButton = async ({
  settings,
}: {
  settings: PublicSettings | null;
}) => {
  if (!settings?.whatsapp_button_enabled || !settings.whatsapp_url) return null;
  const t = await getTranslations("whatsapp");
  return (
    <ChakraLink
      href={settings.whatsapp_url}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={t("ariaLabel")}
      title={t("ariaLabel")}
      position="fixed"
      insetInlineEnd={{ base: 4, md: 6 }}
      bottom={{ base: "96px", md: 6 }}
      zIndex={20}
      w="56px"
      h="56px"
      rounded="full"
      bg="#25D366"
      color="white"
      display="flex"
      alignItems="center"
      justifyContent="center"
      shadow="lg"
      transition="transform 0.2s"
      _hover={{ transform: "scale(1.1)", bg: "#25D366" }}
    >
      <FaWhatsapp size={30} />
    </ChakraLink>
  );
};

export default WhatsappFloatingButton;
