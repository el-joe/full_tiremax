import { IProductReviewMeta, IReview } from '@/types'
import { Box, HStack, Image, RatingGroup, Text, VStack } from '@chakra-ui/react'
import { useLocale, useTranslations } from 'next-intl'
import React from 'react'

type Props = {
    reviews: {
        reviews: IReview[],
        meta: IProductReviewMeta
    }
}

const ProductReviews = ({ reviews }: Props) => {
    const t = useTranslations("productView")
    const locale = useLocale()
    return (
        <Box>
            <HStack mb={"16px"} justify={"space-between"}>
                <Text fontSize={{ base: "12px", md: "14px", lg: "16px", xl: "18px" }} fontWeight={"semibold"}>{t("userReviews")}</Text>
                <HStack>
                    <RatingGroup.Root readOnly allowHalf count={5} defaultValue={reviews?.meta.rating_avg} size={{ base: "sm", md: "lg" }} colorPalette={"yellow"}>
                        <RatingGroup.HiddenInput />
                        <RatingGroup.Control dir={locale === "en" ? "ltr" : "rtl"} />
                    </RatingGroup.Root>
                    <Text fontWeight={"bold"}>{reviews?.meta?.rating_count}</Text>
                </HStack>
            </HStack>
            {/* reviews */}
            {!!reviews.reviews?.length && <VStack gap={"8px"}>{reviews.reviews.map(review => <ReviewCard key={review.id} review={review} />)}</VStack>}
        </Box>
    )
}

export default ProductReviews

const ReviewCard = ({ review }: { review: IReview }) => {
    return <Box p={"20px"} rounded={"16px"} border={"2px solid {colors.primary}"} >
        <HStack gap={"8px"} align={"start"} justify={"space-between"}>
            <Box>
                <Text fontSize={"14px"} fontWeight={"semibold"} mb="4px">{review?.customer?.name}</Text>
                <Text fontSize={"12px"} color={"gray-2"}>منذ يومين</Text>
            </Box>
            <Image src={"/images/testimonialUserAvatar.jpg"} alt='avatar' w="48px" h={"48px"} rounded={"12px"} outline={"2px solid {colors.primary}"} outlineOffset={"1px"} />
        </HStack>
        <Text fontSize={"14px"} color={"gray-2"}>{review?.comment}</Text>
    </Box>
}