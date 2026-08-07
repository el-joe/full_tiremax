"use client";
import CurrencySymbol from "@/components/ui/CurrencySymbol";
import { Link } from "@/i18n/navigation";
import { useCartContext } from "@/providers/CartProvider";
import { ICartItem } from "@/types/customerCart.type";
import {
  Badge,
  Box,
  Button,
  Center,
  Heading,
  HStack,
  IconButton,
  Image,
  NumberInput,
  Spinner,
  Text,
  VStack,
} from "@chakra-ui/react";
import { FaMinus, FaPlus } from "react-icons/fa";
import { RiDeleteBin6Line } from "react-icons/ri";

const ItemsList = () => {
  const { cart, cartIsLoading = true, totalQuantity } = useCartContext();
  if (cartIsLoading) {
    return (
      <Center h="full">
        <Spinner size={"xl"} />
      </Center>
    );
  }
  // if empty cart
  if (!totalQuantity) {
    return (
      <VStack gap={"24px"}>
        <Heading fontSize={"24px"} fontWeight={"extrabold"}>
          your cart is empty
        </Heading>
        <Link href={"store"}>
          <Button>Go to shopping</Button>
        </Link>
      </VStack>
    );
  }
  // if cart has items
  return (
    <VStack
      gap={"24px"}
      align={"stretch"}
      w={{ base: "", md: "480px", lg: "603px", "2xl": "805px" }}
    >
      {cart.items.map((item) => (
        <Item data={item} key={item.id} />
      ))}
    </VStack>
  );
};

export default ItemsList;

const Item = ({ data }: { data: ICartItem }) => {
  const {
    removeItem,
    isUpdating: isLoading,
    isRemoving,
    addOrUpdateItem,
  } = useCartContext();
  return (
    <HStack
      align={"stretch"}
      gap={{ base: "12px", md: "16px", lg: "22px", "2xl": "32px" }}
      p={{ base: "8px", md: "12px", lg: "18px", "2xl": "24px" }}
      bg={"gray-4"}
      rounded={"8px"}
    >
      <Box
        w={{ base: "104px", md: "132px", lg: "160px", "2xl": "192px" }}
        aspectRatio={"square"}
        alignSelf={"start"}
        bg={"white"}
      >
        <Image
          src={data.product.primary_image ?? "/images/product-image.jpg"}
          alt="thumb"
          objectFit={"cover"}
          w="full"
          h="full"
        />
      </Box>
      <VStack
        flex={1}
        justify={"space-between"}
        align={"stretch"}
        h={"auto"}
        gap={"2px"}
      >
        <Box>
          <HStack justify={"space-between"}>
            <Badge
              size={{ base: "xs", md: "sm", xl: "md" }}
              color={"gray-2"}
              fontSize={{ base: "6px", md: "8px", xl: "10px" }}
              rounded="12px"
              fontWeight={"bold"}
              textTransform={"uppercase"}
              bg={"myGray"}
            >
              {data?.product?.brand.name}
            </Badge>
            <IconButton
              variant={"ghost"}
              color={"black"}
              onClick={(e) => {
                e.preventDefault();
                removeItem(data?.product?.id);
              }}
              size={{ base: "xs", lg: "sm", xl: "md" }}
              minW={"auto"}
              h="auto"
            >
              <RiDeleteBin6Line className="w-3! lg:w-4! xl:w-8!" />
            </IconButton>
          </HStack>
          <Link href={`/store/${data?.product?.id}`}>
            {" "}
            <Heading
              fontSize={{ base: "12px", md: "14px", lg: "16px", xl: "18px" }}
              fontWeight={"bold"}
            >
              {data?.product?.name}
            </Heading>
          </Link>
          <Text
            color={"gray-2"}
            lineClamp={1}
            fontSize={{ base: "9px", md: "10px", lg: "12px", xl: "14px" }}
          >
            {data.product.short_description}
          </Text>
        </Box>
        <Badge
          alignSelf={"start"}
          size={{ base: "xs", md: "sm", xl: "md" }}
          color={"gray-2"}
          fontSize={{ base: "6px", md: "8px", xl: "10px" }}
          rounded="12px"
          fontWeight={"bold"}
          textTransform={"uppercase"}
          bg={"myGray"}
        >
          {data?.product?.brand.country}
        </Badge>
        <HStack justify={"space-between"}>
          <NumberInput.Root
            defaultValue="3"
            unstyled
            spinOnPress={false}
            min={1}
            value={String(data.quantity)}
            disabled={isLoading}
            onValueChange={(e) => {
              addOrUpdateItem(data.product, +e.value);
            }}
          >
            <HStack
              gap="2"
              border={"1px solid {colors.primary}"}
              rounded="full"
            >
              {data.quantity <= 1 ? (
                <IconButton
                  variant="ghost"
                  size="sm"
                  color={"black"}
                  onClick={(e) => {
                    e.preventDefault();
                    removeItem(data?.product?.id);
                  }}
                  minW="auto"
                  loading={isRemoving}
                  h="auto"
                  p={{ base: "1px", md: "3px", lg: "6px", xl: "8px" }}
                >
                  <RiDeleteBin6Line className="w-3! lg:w-4!" />
                </IconButton>
              ) : (
                <NumberInput.DecrementTrigger asChild>
                  <IconButton
                    variant="ghost"
                    size={{ base: "xs", lg: "sm" }}
                    color={"black"}
                    minW="auto"
                    h="auto"
                    p={{ base: "1px", md: "3px", lg: "6px", xl: "8px" }}
                  >
                    <FaMinus className="w-3! lg:w-4!" />
                  </IconButton>
                </NumberInput.DecrementTrigger>
              )}
              <NumberInput.ValueText
                textAlign="center"
                fontSize={{ base: "sm", lg: "md", xl: "lg" }}
                minW="3ch"
              />
              <NumberInput.IncrementTrigger asChild>
                <IconButton
                  variant="ghost"
                  size={{ base: "xs", lg: "sm" }}
                  color={"black"}
                  minW="auto"
                  h="auto"
                  p={{ base: "1px", md: "3px", lg: "6px", xl: "8px" }}
                >
                  <FaPlus className="w-3! lg:w-4!" />
                </IconButton>
              </NumberInput.IncrementTrigger>
            </HStack>
          </NumberInput.Root>
          <Text
            fontSize={{ base: "12px", md: "16px", lg: "18px", "2xl": "28px" }}
            fontWeight={"bold"}
          >
            {data.product.effective_price.toLocaleString()} <CurrencySymbol />
          </Text>
        </HStack>
      </VStack>
    </HStack>
  );
};
