"use client"
import { IProduct } from '@/types'
import { Box, Image } from '@chakra-ui/react'
import React, { useState } from 'react'
import { Swiper, SwiperSlide } from "swiper/react"
import { EffectFade, FreeMode, Thumbs } from "swiper/modules"
import type { Swiper as SwiperType } from 'swiper/types'

const images = ["/images/product-image.jpg",
    "/images/product-image2.jpg",
    "/images/product-image3.jpg",
    "/images/product-image4.jpg",
    "/images/product-image5.jpg",
    "/images/product-image6.jpg"]


type Props = {
    product: IProduct
}

export default function ProductImagesPreview({ product }: Props) {
    const [thumbsSwiper, setThumbsSwiper] = useState<SwiperType>()
    return (
        <Box flex={1} maxW={{ base: "full", md: "396px", lg: "582px", xl: "654px", "2xl": "722px" }}>
            <Swiper
                modules={[EffectFade, Thumbs]}
                effect='fade'
                loop
                thumbs={{
                    swiper: thumbsSwiper
                }}
            >
                {(product?.images.length ? product.images : images).map(image => <SwiperSlide key={image}>
                    <Image src={image} alt='' w="full" aspectRatio={"1/0.8"} objectFit={"fill"} rounded={"12px"} />
                </SwiperSlide>)}
            </Swiper>
            <Box mt={{ base: "6px", lg: "10px", xl: "12px" }}>
                <Swiper
                    className='py-2! productSwiperThumbs'
                    onSwiper={setThumbsSwiper}
                    spaceBetween={"16px"}
                    slidesPerView={"auto"}
                    freeMode={true}
                    watchSlidesProgress={true}
                    loop
                    modules={[FreeMode, Thumbs]}
                >
                    {(product?.images.length ? product.images : images).map(image => <SwiperSlide key={image}>
                        <Image src={image} alt='' w={{ base: "86px", md: "86px", lg: "107px", xl: "127px", "2xl": "158px" }} aspectRatio={"1/1"} objectFit={"fill"} rounded={"8px"} />
                    </SwiperSlide>)}
                </Swiper>
            </Box>
        </Box>
    )
}