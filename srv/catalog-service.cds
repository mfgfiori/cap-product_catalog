using {com.logali as logali} from '../db/schema';
using {com.training as training} from '../db/training';

// service CatalogService {
//     entity Products       as projection on logali.materials.Products;
//     entity Suppliers      as projection on logali.sales.Suppliers;
//     entity UnitOfMeasures as projection on logali.materials.UnitOfMeasures;
//     entity DimensionUnits as projection on logali.materials.DimensionUnits;
//     entity Categories     as projection on logali.materials.Categories;
//     entity Currencies     as projection on logali.materials.Currencies;
//     entity ProductReview  as projection on logali.sales.ProductReview;
//     entity SalesData      as projection on logali.sales.SalesData;
//     entity Order          as projection on logali.sales.Orders;
//     entity OrderItems     as projection on logali.sales.OrderItems;
//     entity Months         as projection on logali.sales.Months;
// // entity StockAvailability as projection on logali.StockAvailability;
// // entity car as projection on logali.car;
// }

define service CatalogService {
    entity Products          as
        select from logali.materials.Products {
            ID,
            Name          as ProductName     @mandatory,
            Description                      @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                            @mandatory,
            Height,
            Width,
            Depth,
            Quantity                          @(
                mandatory,
                assert.range : [
                    0.00,
                    20,00
                ]
            ),
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Category      as ToCategory      @mandatory,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit,
            ToSalesData,
            Supplier,
            Reviews
        };

    entity Supplier          as
        select from logali.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };
    @readonly
    entity Reviews           as
        select from logali.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };
    @readonly
    entity SalesData         as
        select from logali.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };
    @readonly
    entity StockAvailability as
        select from logali.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct,
        };
    @readonly
    // VH --> Value help
    entity VH_Categories     as
        select from logali.materials.Categories {
            ID   as Code,
            Name as Text
        };
    @readonly
    entity VH_Currencies     as
        select from logali.materials.Currencies {
            ID          as Code,
            Description as Text
        };
    @readonly
    entity VH_UnitOfMesaures as
        select from logali.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };
    @readonly
    entity VH_DimensionUnits as
        select from logali.materials.DimensionUnits {
            ID          as Code,
            Description as Text
        };
}
