import { Link } from '@/i18n/navigation'
import { Image } from '@chakra-ui/react'
import React from 'react'

const Logo = () => {
    return (
        <Link href={"/"}>
            <Image src={"/images/logo.svg"} alt='' />
        </Link>
    )
}

export default Logo