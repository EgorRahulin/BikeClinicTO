public with sharing class CatalogService {
    private static CatalogService.WithoutSharingOps wosInstance;

    private static CatalogService.WithoutSharingOps getWOSInstance() {
        if(wosInstance != null) {
            return wosInstance;
        }
        wosInstance = new CatalogService.WithoutSharingOps();
        return wosInstance;
    }

    public static void insertCatalog(String catalogName) {
        getWOSInstance().insertCatalog(new ProductCatalog(Name = catalogName));
    }

    public static void updateCatalogs(List<ProductCatalog> catalogs) {
        getWOSInstance().updateCatalogs(catalogs);
    }

    public static void deleteCatalog(Id catalogId) {
        getWOSInstance().deleteCatalog(catalogId);
    }
    

    public static void insertCategories(List<ProductCategory> newCategories) {
        getWOSInstance().insertCategories(newCategories);
    }

    public static void updateCategories(List<ProductCategory> categories) {
        getWOSInstance().updateCategories(categories);
    }

    public static void deleteCategory(Id categoryId) {
        getWOSInstance().deleteCategory(categoryId);
    }

    public without sharing class WithoutSharingOps {
        public void insertCatalog(ProductCatalog catalog) {
            insert catalog;
        }

        public void updateCatalogs(List<ProductCatalog> catalogs) {
            update catalogs;
        }

        public void deleteCatalog(Id catalogId) {
            delete [SELECT Id FROM ProductCatalog WHERE Id = :catalogId];
        }


        public void insertCategories(List<ProductCategory> newCategories) {
            insert newCategories;
        }

        public void updateCategories(List<ProductCategory> categories) {
            update categories;
        }

        public void deleteCategory(Id categoryId) {
            delete [SELECT Id FROM ProductCategory WHERE Id = :categoryId];
        }

    }
}