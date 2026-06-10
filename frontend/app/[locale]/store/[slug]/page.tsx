import ProductDetails from '@/components/pages/productView/ProductDetails'
import Container from '@/components/ui/Container'
import { IProduct } from '@/types'
import axiosInstance from '@/utils/axiosInstance'
import { HStack } from '@chakra-ui/react'
import React from 'react'

interface props {
    params: Promise<{ slug: string }>
}

const page = async ({ params }: props) => {
    const slug = (await params).slug
    const { data } = await axiosInstance<{ data: IProduct }>(`products/${slug}`)
    return (
        <HStack gap={"40px"}><ProductDetails product={data.data} /></HStack>
    )
}

export default page 