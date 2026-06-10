"use client"
import { IProduct } from '@/types'
import { Box, Image } from '@chakra-ui/react'
import React, { useState } from 'react'
import { Swiper, SwiperSlide } from "swiper/react"
import { EffectFade, FreeMode, Navigation, Thumbs } from "swiper/modules"
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
        <Box flex={1.3} maxW={"722px"}>
            <Swiper
                modules={[EffectFade, Thumbs]}
                effect='fade'
                loop
                thumbs={{
                    swiper: thumbsSwiper
                }}
            >
                {(product?.images.length ? product.images : images).map(image => <SwiperSlide key={image}>
                    <Image src={image} alt='' w="720px" h={"523px"} objectFit={"fill"} rounded={"12px"} />
                </SwiperSlide>)}
            </Swiper>
            <Swiper
                className='mt-6! py-2! productSwiperThumbs'
                onSwiper={setThumbsSwiper}
                spaceBetween={"16px"}
                slidesPerView={"auto"}
                freeMode={true}
                watchSlidesProgress={true}
                loop
                modules={[FreeMode, Thumbs]}
            >
                {(product?.images.length ? product.images : images).map(image => <SwiperSlide key={image}>
                    <Image src={image} alt='' w={"158px"} h={"158px"} objectFit={"fill"} rounded={"8px"} />
                </SwiperSlide>)}
            </Swiper>
        </Box>
    )
}