namespace com.training;

using {cuid} from '@sap/cds/common';

type EmailsAddresses_01 : array of {
    kind  : String;
    email : String;
};

type EmailsAddresses_02 : {
    kind  : String;
    email : String;
};

entity Emails {
    email_01 :      EmailsAddresses_01;
    email_02 : many EmailsAddresses_02;
    email_03 : many {
        kind  : String;
        email : String;
    }
}


/*type Gender             : String;
entity Order {
    clientGender : Gender;
    status       : Integer enum {
        submitted = 1;
        fulfiller = 2;

        shipped   = 3;
        cancel    = -1;
    };
    priority : String @assert.range enum{
        high;
        megium;
        low;
    }
};*/
/*
entity Suppliers_01 {
    key ID         : UUID;
        Name       : String;
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
        Email      : String;
        Phone      : String;
        Fax        : String;
};
 */

/* entity Suppliers_02 {
   key ID    : UUID;
       Name  : String;
       Address {
           Street     : String;
           City       : String;
           State      : String(2);
           PostalCode : String(5);
           Country    : String(3);
       };
       Email : String;
       Phone : String;
       Fax   : String;
};
*/
/* entity ParamProducts(pName : String)     as
    select from Products {
        Name,
        Price,
        Quantity
    }
    where
        Name = : pName;

entity ProjParamProducts(pName : String) as projection on Products where Name = : pName; */

entity Course {
    key ID      : UUID;
        Student : Association to many StudentCourse
                      on Student.Course = $self;
};

entity Student {
    key ID     : UUID;
        Course : Association to many StudentCourse
                     on Course.Student = $self;
};

entity StudentCourse {
    key ID      : UUID;
        Student : Association to Student;
        Course  : Association to Course;
}
entity car {
    key ID                 : UUID;
        Name               : String;
        virtual discount_1 : Decimal;
        @Core.Computed : false
        virtual discount_2 : Decimal;
}
