import React from 'react'
import { Container as ChakraContainer, ContainerProps } from '@chakra-ui/react'

interface IContainerProps extends ContainerProps {
    children: React.ReactNode
}

const Container = ({ children, ...rest }: IContainerProps) => {
    return (
        <ChakraContainer bg="white" py={{ base: "24px", md: "42px", xl: "80px" }} roundedTop={"50px"} overflow={"hidden"} {...rest}>{children}</ChakraContainer>
    )
}

export default Container