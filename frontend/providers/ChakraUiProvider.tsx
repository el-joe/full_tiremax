"use client"

import { ChakraProvider } from "@chakra-ui/react"
import { system } from "@/theme"
// import { ThemeProvider } from "next-themes"

export function ChakraUiProvider(props: { children: React.ReactNode }) {
  return (
    <ChakraProvider value={system}>
      {props.children}
      {/* <ThemeProvider>{props.children}</ThemeProvider> */}
    </ChakraProvider>
  )
}
