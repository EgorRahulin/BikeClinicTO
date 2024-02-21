import { LightningElement, api } from 'lwc';

import getProductList from '@salesforce/apex/ProductsLwcController.getProductList';

export default class ProductsLwc extends LightningElement {
    @api products;

    connectedCallback() {
        this.init();
    }

    async init() {
        const { status, products } = await getProductList();

        if (status === 'SUCCESS') {
            this.products = products;
            console.log(this.products);
        } else {
            console.log('getProductList() error');
        }
    }
    
}