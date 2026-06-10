import ProductTabsHeader from '@/components/pages/productsView/ProductTabsHeader';
import { Box, Text } from '@chakra-ui/react'

import React, { Suspense } from 'react'

type props = {

    allProductsList: React.ReactNode;
}

const page = async ({ allProductsList }: props) => {

    return (
        <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>{allProductsList}</Suspense>
    )
}

export default page