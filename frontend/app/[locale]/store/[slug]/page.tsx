import Actions from '@/components/pages/productView/Actions'
import ProductDetails from '@/components/pages/productView/ProductDetails'
import ProductImagesPreview from '@/components/pages/productView/ProductImagesPreview'
import { IProduct } from '@/types'
import axiosInstance from '@/utils/axiosInstance'
import { HStack } from '@chakra-ui/react'


interface props {
    params: Promise<{ slug: string }>
}

const page = async ({ params }: props) => {
    const slug = (await params).slug
    const { data } = await axiosInstance<{ data: IProduct }>(`products/${slug}`)
    return (
        <>
            <HStack gap={{ base: "16px", md: "26px", lg: "32px", xl: "40px" }} flexWrap={'wrap'} align={"start"} pb={{ base: "66px", "2xl": "36px" }}>
                <ProductImagesPreview product={data.data} />
                <ProductDetails product={data.data} />
            </HStack>
            <Actions product={data.data} />
        </>
    )
}

export default page 