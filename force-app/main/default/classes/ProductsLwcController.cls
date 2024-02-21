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

            outputData.products.addAll(products);
        } catch (Exception ex) {
            outputData.status = 'ERROR';
            return outputData;
        }

        return outputData;
    }


    public with sharing class ResultData {
        @AuraEnabled public String status           = 'SUCCESS';
        @AuraEnabled public List<Product2> products = new list<Product2>();
    }
}