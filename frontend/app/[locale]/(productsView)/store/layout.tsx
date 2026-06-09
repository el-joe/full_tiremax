import ProductTabsHeader from '@/components/pages/productsView/ProductTabsHeader';
import { Link } from '@/i18n/navigation';
import { Box, Button, HStack, Tabs, Text } from '@chakra-ui/react'
import { getLocale, getTranslations } from 'next-intl/server';
import React, { Suspense } from 'react'

type props = {
    batteriesList: React.ReactNode;
    tiresList: React.ReactNode;
    allProductsList: React.ReactNode;
}

const page = async ({ batteriesList, tiresList, allProductsList }: props) => {
    const t = await getTranslations("store")
    const locale = await getLocale()
    const dir = locale === "ar" ? "rtl" : "ltr"
    return (
        <Box>
            <ProductTabsHeader />
            <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>{allProductsList}</Suspense>
        </Box>
        // <Tabs.Root defaultValue="all">
        //     <Tabs.List dir={dir} >
        //         <Tabs.Trigger value="all" _selected={{ _before: { background: "primary" } }}>
        //             {t("all")}
        //         </Tabs.Trigger>
        //         <Tabs.Trigger value="tires">
        //             {t("tires")}
        //         </Tabs.Trigger>
        //         <Tabs.Trigger value="batteries">
        //             {t("batteries")}
        //         </Tabs.Trigger>
        //     </Tabs.List>
        //     <Tabs.Content value="all" dir={dir}>
        //         <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>{allProductsList}</Suspense>
        //     </Tabs.Content>
        //     <Tabs.Content value="tires" dir={dir}>
        //         <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>{tiresList}</Suspense>
        //     </Tabs.Content>
        //     <Tabs.Content value="batteries" dir={dir}>
        //         <Suspense fallback={<Text fontSize={"48px"}>Loading</Text>}>{batteriesList}</Suspense>
        //     </Tabs.Content>
        // </Tabs.Root>
    )
}

export default page