namespace com.logali;

using {
    cuid,
    managed
} from '@sap/cds/common';


define type Name : String(50);

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};


type Dec         : Decimal(16, 2);

context materials {

    entity Products : cuid, managed {
        //key ID               : UUID;
        Name             : localized String not null;
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Dec; //Decimal(16, 2);
        Height           : type of Price; // Decimal(16, 2);
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to one sales.Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures;
        Currency         : Association to Currencies;
        DimensionUnit    : Association to DimensionUnits;
        Category         : Association to Categories;
        ToSalesData      : Association to many sales.SalesData
                               on ToSalesData.Product = $self;
        Reviews          : Association to many materials.ProductReview
                               on Reviews.Product = $self;
    // Supplier_Id      : UUID;
    // ToSupplier       : Association to one Suppliers
    //                        on ToSupplier.ID = Supplier_Id;
    // UnitOfMeasures_Id: String(2);
    // ToUnitOfMeasures : Association to UnitOfMeasures
    //                        on ToUnitOfMeasures.ID = UnitOfMeasures_Id;
    // DimensionUnit_Id : String(2);
    // ToDimensionUnit : Association to  DimensionUnits
    //                        on ToDimensionUnit.ID = DimensionUnit_Id;
    };

    entity Categories {
        key ID   : String(1);
            Name : localized String;
    };

    entity StockAvailability {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products;
    };

    entity Currencies {
        key ID          : String(3);
            Description : localized String;
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : localized String;
    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;
    };

    entity ProductReview : cuid, managed {
        //    key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to materials.Products;
    };

    extend Products with {
        PriceCondition     : String(2);
        PriceDetermination : String(3)
    };
}

context sales {
    entity Suppliers : cuid, managed {
        //    key ID      : UUID;
        Name    : type of materials.Products : Name; //String;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many materials.Products
                      on Product.Supplier = $self;
    };


    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(2);
    };


    entity SalesData : cuid, managed {
        //    key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;
    };


    entity SelProducts   as select from materials.Products;

    entity SelProducts1  as
        select from materials.Products {
            *
        };

    entity SelProducts2  as
        select from materials.Products {
            Name,
            Price,
            Quantity
        };

    entity SelProducts3  as
        select from materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            Rating,
            Products.Name,
            Sum(Price) as TotalPrice
        }
        group by
            Rating,
            Products.Name
        order by
            Rating;

    entity ProjProducts  as projection on materials.Products;

    entity ProjProducts2 as projection on materials.Products {
        *
    };

    entity ProjProducts3 as projection on materials.Products {
        ReleaseDate,
        Name
    };


    entity Orders : cuid {
        ///key ID : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    };

    entity OrderItems : cuid {
        //key ID : UUID;
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;
    }
}

context reports {
    entity AverageRating as
        select from logali.materials.ProductReview {
            Product.ID  as ProductID,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products      as
        select from logali.materials.Products
        mixin {
            ToStockAvailabity : Association to logali.materials.StockAvailability
                                    on ToStockAvailabity.ID = $projection.StockAvailability;
            ToAverageRating   : Association to AverageRating
                                    on ToAverageRating.ProductID = ID;

        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
                when
                    Quantity >= 8
                then
                    3
                when
                    Quantity > 0
                then
                    2
                else
                    1
            end                           as StockAvailability : Integer,
            ToStockAvailabity
        }
}
