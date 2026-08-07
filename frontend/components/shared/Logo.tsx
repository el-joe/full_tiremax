import { Link } from "@/i18n/navigation";
import { Image } from "@chakra-ui/react";
import React from "react";

const Logo = () => {
  return (
    <Link href={"/"}>
      <Image
        src={"/images/logo.svg"}
        alt=""
        w={{ base: "44px", md: "64px", xl: "94px", "2xl": "121px" }}
      />
    </Link>
  );
};

export default Logo;
