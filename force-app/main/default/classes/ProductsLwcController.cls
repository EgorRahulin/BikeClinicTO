public with sharing class ProductsLwcController {
    
    @AuraEnabled
    public static ResultData getProductList() {
        ResultData outputData = new ResultData();

        try {
            List<Product2> products = [
                SELECT 
                    Id,
                    Name, 
                    ProductCode, 
                    Article__c
                FROM Product2
            ];

            // (SELECT Id FROM ProductCategoryProducts)

            outputData.products.addAll(products);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData getCatalogs() {
        ResultData outputData = new ResultData();

        try {
            List<ProductCatalog> catalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(catalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData insertCatalog(String name) {
        ResultData outputData = new ResultData();

        try {
            CatalogService.insertCatalog(name);

            List<ProductCatalog> catalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(catalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData updateCatalogs(List<ProductCatalog> catalogs) {
        ResultData outputData = new ResultData();

        try {
            CatalogService.updateCatalogs(catalogs);

            List<ProductCatalog> uspdatedCatalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(uspdatedCatalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData deleteCatalog(Id catalogId) {
        ResultData outputData = new ResultData();

        try {
            CatalogService.deleteCatalog(catalogId);

            List<ProductCatalog> catalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(catalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData insertCategories(Map<Id, String> newCategoryNameByCatalogIdMap) {
        ResultData outputData = new ResultData();

        // System.debug(newCategoryNameByCatalogIdMapJSON);
        // Map<Id, String> newCategoryNameByCatalogIdMap = new Map<Id, String>();
        
        try {
            List<ProductCategory> newCategories = new List<ProductCategory>();

            System.debug(newCategoryNameByCatalogIdMap);

            for(Id catalogId : newCategoryNameByCatalogIdMap.keySet()) {
                String newCategoryName = newCategoryNameByCatalogIdMap.get(catalogId);
                newCategories.add(new ProductCategory(
                    Name = newCategoryName,
                    catalogId = catalogId
                ));
            }

            System.debug(newCategories);

            CatalogService.insertCategories(newCategories);

            List<ProductCatalog> catalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(catalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData updateCategories(List<ProductCategory> categories) {
        ResultData outputData = new ResultData();

        System.debug(categories);
        try {
            CatalogService.updateCategories(categories);

            List<ProductCatalog> catalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(catalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    @AuraEnabled
    public static ResultData deleteCategory(Id categoryId) {
        System.debug('categoryId >>' + categoryId);
        ResultData outputData = new ResultData();

        try {
            CatalogService.deleteCategory(categoryId);

            List<ProductCatalog> catalogs = [
                SELECT 
                    Id,
                    Name,
                    NumberOfCategories,
                    (SELECT 
                        Id, 
                        Name
                        FROM ContainedCategories)
                FROM ProductCatalog
            ];

            outputData.catalogs.addAll(catalogs);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }

    public with sharing class ResultData {
        @AuraEnabled public String                  status   = 'SUCCESS';
        @AuraEnabled public List<Product2>          products = new list<Product2>();
        @AuraEnabled public List<ProductCatalog>    catalogs = new list<ProductCatalog>();
    }
}