import ProductCard from '@/components/shared/ProductCard'
import { IProduct } from '@/types'
import { HStack } from '@chakra-ui/react'

type Props = {
    data: IProduct[]
}

const ProductListView = ({ data }: Props) => {
    return (
        <HStack flexWrap={"wrap"} gap={{ base: "14px", md: "14px", xl: "22px", "2xl": "32px" }} alignItems={"stretch"}>
            {data.map(product => <ProductCard key={product.id} product={product} />)}
        </HStack>
    )
}

export default ProductListView