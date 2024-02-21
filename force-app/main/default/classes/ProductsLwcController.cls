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


    public with sharing class ResultData {
        @AuraEnabled public String                  status   = 'SUCCESS';
        @AuraEnabled public List<Product2>          products = new list<Product2>();
        @AuraEnabled public List<ProductCatalog>    catalogs = new list<ProductCatalog>();
    }
}