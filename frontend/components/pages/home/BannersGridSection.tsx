import { Link } from '@/i18n/navigation'
import { Box, Container, Grid, GridItem, Heading, Image, Text, VStack } from '@chakra-ui/react'
import { getTranslations } from 'next-intl/server'
import React from 'react'

const BannersGridSection = async () => {
    const t = await getTranslations("home")
    return (
        <Container bg="white" py="80px" roundedTop={"50px"} overflow={"hidden"}>
            <Grid
                templateColumns="repeat(7, 1fr)"
                gap={"31px"}>
                <GridItem colSpan={3}>
                    <VStack alignItems={'stretch'} gap={"31px"}>
                        <Box>
                            <Heading as="h2" fontSize={"28px"} fontWeight={"bold"} mb={"32px"}>{t("allInOneSolutionsForYourVehicle")}</Heading>
                            <Text fontSize={"18px"}>{t("findEverythingYourVehicleNeedsInOnePlace,FromPremiumTiresAndDependableBatteriesToExpertMaintenanceAndInstallationServices")}</Text>
                        </Box>
                        <Box rounded={"20px"} overflow={"hidden"} position={"relative"} h={"258px"}>
                            <Image src={"/images/maintenanceServicesBg.jpg"} alt='bg' objectFit={"cover"} position="absolute" inset={0} w={"full"} h="full" />
                            <Link href={"/"} className='bg-white absolute bottom-4 left-4 p-2.5! rounded-[10px]'>{t("maintenanceServices")}</Link>
                        </Box>
                    </VStack>
                </GridItem>
                <GridItem colSpan={2} >
                    <Box rounded={"20px"} overflow={"hidden"} position={"relative"} h={"full"}>
                        <Image src={"/images/bookAtTheCenterBg.jpg"} alt='bg' objectFit={"cover"} position="absolute" inset={0} w={"full"} h="full" />
                        <Link href={"/"} className='bg-white absolute bottom-4 left-4 p-2.5! rounded-[10px]'>{t("maintenanceServices")}</Link>
                    </Box>
                </GridItem>
                <GridItem colSpan={2}>
                    <VStack alignItems={"stretch"} gap="31px" h='full'>
                        <Box rounded={"20px"} overflow={"hidden"} position={"relative"} h="calc(100% - 31px / 2)">
                            <Image src={"/images/battaryInstallationBg.jpg"} alt='bg' objectFit={"cover"} position="absolute" inset={0} w={"full"} h="full" />
                            <Link href={"/"} className='bg-white absolute bottom-4 left-4 p-2.5! rounded-[10px]'>{t("batteryInstallation")}</Link>
                        </Box>
                        <Box rounded={"20px"} overflow={"hidden"} position={"relative"} h="calc(100% - 31px / 2)">
                            <Image src={"/images/tireInstallationBg.jpg"} alt='bg' objectFit={"cover"} position="absolute" inset={0} w={"full"} h="full" />
                            <Link href={"/"} className='bg-white absolute bottom-4 left-4 p-2.5! rounded-[10px]'>{t("tireInstallation")}</Link>
                        </Box>
                    </VStack>
                </GridItem>
            </Grid>
        </Container >
    )
}

export default BannersGridSection