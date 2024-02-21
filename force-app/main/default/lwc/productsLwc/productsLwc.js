import { LightningElement, api } from 'lwc';

import getProductList from '@salesforce/apex/ProductsLwcController.getProductList';
import getCatalogs from '@salesforce/apex/ProductsLwcController.getCatalogs'

export default class ProductsLwc extends LightningElement {
    @api products;
    @api catalogs;

    connectedCallback() {
        this.init();
    }

    async init() {
        const { status, products } = await getProductList();

        if (status === 'SUCCESS') {
            this.products = products;
        } else {
            console.log('getProductList() error');
        }

        this.getCatalogs();
    }

    async getCatalogs() {
        const { status, products, catalogs } = await getCatalogs();

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
            console.log('catalogs');
            console.log(this.products);
            console.log(this.catalogs);
        } else {
            console.log('getCatalogs() error');
        }
    }
}