"use client";
import { IProduct } from "@/types";
import { Badge, Box, Image } from "@chakra-ui/react";
import React, { useState } from "react";
import { Swiper, SwiperSlide } from "swiper/react";
import { EffectFade, FreeMode, Thumbs } from "swiper/modules";
import type { Swiper as SwiperType } from "swiper/types";
import {
  BadgeBestIcon,
  BestPriceCircleIcon,
  NewIcon,
  PercentageCircleIcon,
} from "@/components/Icons";

const images = [
  "/images/product-image.jpg",
  "/images/product-image2.jpg",
  "/images/product-image3.jpg",
  "/images/product-image4.jpg",
  "/images/product-image5.jpg",
  "/images/product-image6.jpg",
];

type Props = {
  product: IProduct;
};

export default function ProductImagesPreview({ product }: Props) {
  const [thumbsSwiper, setThumbsSwiper] = useState<SwiperType>();
  return (
    <Box
      flex={1}
      maxW={{
        base: "full",
        md: "396px",
        lg: "582px",
        xl: "654px",
        "2xl": "722px",
      }}
      position={"relative"}
    >
      {!!product.badges.length && <CustomBadge content={product.badges[0]} />}
      <Swiper
        modules={[EffectFade, Thumbs]}
        effect="fade"
        loop
        thumbs={{
          swiper: thumbsSwiper,
        }}
      >
        {(product?.images.length ? product.images : images).map((image) => (
          <SwiperSlide key={image}>
            <Image
              src={image}
              alt=""
              w="full"
              aspectRatio={"1/0.8"}
              objectFit={"fill"}
              rounded={"12px"}
            />
          </SwiperSlide>
        ))}
      </Swiper>
      <Box mt={{ base: "6px", lg: "10px", xl: "12px" }}>
        <Swiper
          className="py-2! productSwiperThumbs"
          onSwiper={setThumbsSwiper}
          spaceBetween={"16px"}
          slidesPerView={"auto"}
          freeMode={true}
          watchSlidesProgress={true}
          loop
          modules={[FreeMode, Thumbs]}
        >
          {(product?.images.length ? product.images : images).map((image) => (
            <SwiperSlide key={image}>
              <Image
                src={image}
                alt=""
                w={{
                  base: "86px",
                  md: "86px",
                  lg: "107px",
                  xl: "127px",
                  "2xl": "158px",
                }}
                aspectRatio={"1/1"}
                objectFit={"fill"}
                rounded={"8px"}
              />
            </SwiperSlide>
          ))}
        </Swiper>
      </Box>
    </Box>
  );
}

type badgeProps = {
  content: string;
};

const CustomBadge = ({ content }: badgeProps) => {
  const baseStyle = {
    position: "absolute",
    top: "16px",
    right: "19px",
    zIndex: 10,
    color: "white",
    fontSize: { base: "7px", md: "10px", lg: "14px" },
    fontWeight: "800",
    rounded: "12px",
    px: { base: "4px", md: "8px", lg: "20px", xl: "30px" },
    py: { base: "2px", md: "5px" },
    lineHeight: "16px",
  };
  const formattedContent = content.split("_").join(" ");
  switch (content) {
    case "special_offer":
      return (
        <Badge {...baseStyle} bg="#AE1819">
          <PercentageCircleIcon size={"xs"} color="#FFD166" />
          {formattedContent}
        </Badge>
      );
    case "best_seller":
      return (
        <Badge {...baseStyle} bg={"primary"}>
          <BadgeBestIcon size={"xs"} color="#5C4033" />
          {formattedContent}
        </Badge>
      );
    case "best_choice":
      return (
        <Badge {...baseStyle} bg="#2E7D32">
          <BestPriceCircleIcon size={"xs"} color="#00F40A" />
          {formattedContent}
        </Badge>
      );
    case "new":
      return (
        <Badge {...baseStyle} bg="#1976D2">
          <NewIcon size={"xs"} color="#B4DDFF" />
          {formattedContent}
        </Badge>
      );
    default:
      return (
        <Badge {...baseStyle}>
          <BadgeBestIcon />
          {formattedContent}
        </Badge>
      );
  }
};
