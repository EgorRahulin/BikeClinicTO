import { LightningElement, api } from 'lwc';

import getProductList from '@salesforce/apex/ProductsLwcController.getProductList';
import getCatalogs from '@salesforce/apex/ProductsLwcController.getCatalogs';
import insertCatalog from '@salesforce/apex/ProductsLwcController.insertCatalog';
import updateCatalogs from '@salesforce/apex/ProductsLwcController.updateCatalogs';
import deleteCatalog from '@salesforce/apex/ProductsLwcController.deleteCatalog';
import insertCategories from '@salesforce/apex/ProductsLwcController.insertCategories';
import updateCategories from '@salesforce/apex/ProductsLwcController.updateCategories';
import deleteCategory from '@salesforce/apex/ProductsLwcController.deleteCategory';

export default class ProductsLwc extends LightningElement {
    @api products;
    @api catalogs;

    newCatalogName;
    newCategoryName;
    catalogNameByCatalogIdMap = new Map();
    newCategoryNameByCatalogIdMap = new Map();
    categoryNameByCategoryIdMap = new Map();

    connectedCallback() {
        this.init();
    }

    async init() {
        const { status, products } = await getProductList();

        if (status === 'SUCCESS') {
            this.products = products;
        } else {
            console.log('getProductList error');
        }

        this.getCatalogs();
    }

    async getCatalogs() {
        const { status, products, catalogs } = await getCatalogs();

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
        } else {
            console.log('getCatalogs error');
        }
    }

    async createCatalog() {
        const { status, products, catalogs } = await insertCatalog({name : this.newCatalogName});

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
            this.newCatalogName = '';
        } else {
            console.log('createCatalog error');
        }
    }

    async handleRenameCatalog() {
        let catalogsToUpdateList = new Array();
     
        this.catalogs.forEach(catalog => {
            if (this.catalogNameByCatalogIdMap.has(catalog.Id)) {
                catalog.Name = this.catalogNameByCatalogIdMap.get(catalog.Id);
                catalogsToUpdateList.push(catalog);
            }
        });

        const { status, products, catalogs } = await updateCatalogs({catalogs : [].concat(catalogsToUpdateList)});

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
        } else {
            console.log('RenameCatalog error');
        }
    }

    async handleDeleteCatalog(event) {
        let catalogId = event.target.dataset.id + '';
        const { status, products, catalogs } = await deleteCatalog({catalogId : catalogId});

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
        } else {
            console.log('createCatalog error');
        }
    }

    
    async handleCreateCategories() {
        const { status, products, catalogs } = await insertCategories({newCategoryNameByCatalogIdMap : Object.fromEntries(this.newCategoryNameByCatalogIdMap)});

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
        } else {
            console.log('createCatalog error');
        }
    }

    async handleRenameCategories() {
        let categoryToUpdateList = new Array();
     
        this.catalogs.forEach(catalog => {
            if (catalog.ContainedCategories) {
                catalog.ContainedCategories.forEach(category => {
                    if (this.categoryNameByCategoryIdMap.has(category.Id)) {
                        category.Name = this.categoryNameByCategoryIdMap.get(category.Id);
                        categoryToUpdateList.push(category);
                    }
                })
            }
           
        });

        const { status, products, catalogs } = await updateCategories({categories : [].concat(categoryToUpdateList)});

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
        } else {
            console.log('createCatalog error');
        }
    }

    async handleDeleteCategory(event) {
        let categoryId = event.target.dataset.id + '';
        const { status, products, catalogs } = await deleteCategory({categoryId : categoryId});

        if (status === 'SUCCESS') {
            this.catalogs = catalogs;
        } else {
            console.log('deleteCategory error');
        }
    }

    handleCatalogNameChange(event) {
        let catalogId = event.target.dataset.id;
        let catalogName = event.target.value;
        this.catalogNameByCatalogIdMap.set(catalogId, catalogName);
    }

    handleNewCatalogNameChange(event) {
        let catalogName = event.target.value;
        this.newCatalogName = catalogName;
    }

    handleNewCategoryNameChange(event) {
        let catalogId = event.target.dataset.id;
        let newCategoryName = event.target.value;
        this.newCategoryNameByCatalogIdMap.set(catalogId, newCategoryName);
    }

    handleCategoryNameChange(event) {
        let categoryId = event.target.dataset.id;
        let newCategoryName = event.target.value;
        this.categoryNameByCategoryIdMap.set(categoryId, newCategoryName);
    }
}