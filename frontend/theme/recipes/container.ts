import { defineRecipe } from "@chakra-ui/react";

export const containerRecipe = defineRecipe({
  className: "chakra-container",
  base: {
    position: "relative",
    maxWidth: "8xl",
    w: "100%",
    mx: "auto",
    px: {
      base: "4",
      md: "6",
      lg: "30px",
      xl: "40px",
      "2xl": "60px",
    },
  },
  variants: {
    centerContent: {
      true: {
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      },
    },
    fluid: {
      true: {
        maxWidth: "full",
      },
    },
  },
});
