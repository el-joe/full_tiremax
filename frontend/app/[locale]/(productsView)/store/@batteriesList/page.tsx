import ProductListView from '@/components/pages/productsView/ProductListView';
import { IProduct } from '@/types';
import axiosInstance from '@/utils/axiosInstance';
import React from 'react'

const page = async () => {
    try {
        const { data } = await axiosInstance.get<{ data: IProduct[] }>('products?type=battery');

        if (data) {
            return <ProductListView data={data.data} />;
        }
    } catch (error: unknown) {
        if (error instanceof Error) {
            return <div>{error.message}</div>;
        }

        return <div>Unexpected error</div>;
    }
}

export default page