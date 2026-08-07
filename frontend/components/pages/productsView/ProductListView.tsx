import ProductCard from "@/components/shared/ProductCard";
import Pagination from "@/components/ui/Pagination";
import { IApiMetaRes, IProduct } from "@/types";
import { Box, Center, HStack, Text } from "@chakra-ui/react";

type Props = {
  data: IProduct[];
  paginationInfo: IApiMetaRes;
};

const ProductListView = ({ data, paginationInfo }: Props) => {
  return (
    <Box>
      {!data.length && (
        <Center>
          <Text fontSize={"80px"}>Oops! No Data here</Text>
        </Center>
      )}
      <HStack
        flexWrap={"wrap"}
        gapX={{ base: "14px", md: "14px", xl: "18px", "2xl": "24px" }}
        gapY={"48px"}
        alignItems={"stretch"}
      >
        {data.map((product) => (
          <ProductCard key={product.id} product={product} />
        ))}
      </HStack>
      <Box justifySelf={"center"} mt={"68px"}>
        <Pagination
          currentPage={paginationInfo?.pagination?.current_page}
          itemsCount={paginationInfo?.pagination?.total}
          pageSize={paginationInfo?.pagination?.per_page}
        />
      </Box>
    </Box>
  );
};

export default ProductListView;
