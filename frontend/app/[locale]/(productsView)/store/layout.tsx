import { Text } from '@chakra-ui/react'

import React, { Suspense } from 'react'

type props = {
    children: React.ReactNode;
    allProductsList: React.ReactNode;
}

const page = async ({ children, allProductsList }: props) => {

    return (
        <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>{children}</Suspense>
    )
}

export default page