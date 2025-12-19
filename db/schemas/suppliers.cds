using {
    cuid,
    managed
} from '@sap/cds/common';
using {sap.appraisers as appraiser} from './appraisers';
using {sap.evaluations as evaluation} from './evaluations';

namespace sap.suppliers;

/**
 * Master Data: Suppliers
 */
entity Suppliers : cuid, managed {
    supplierID  : String(10)    @title: 'Supplier ID';
    name        : String(255)   @title: 'Supplier Name'  @mandatory;
    email       : String(255)   @title: 'Email';
    phone       : String(50)    @title: 'Phone';
    address     : String(500)   @title: 'Address';
    city        : String(100)   @title: 'City';
    country     : String(100)   @title: 'Country';
    postalCode  : String(20)    @title: 'Postal Code';
    status      : String(20)    @title: 'Status' default 'Active'; // Active, Inactive, Suspended
    category    : String(50)    @title: 'Category'; // Raw Materials, Services, Components, etc.
    rating      : Decimal(3, 2) @title: 'Overall Rating'; // 0.00 to 5.00
    // Associations
    evaluations : Association to many evaluation.Evaluations
                      on evaluations.supplier = $self;
    assignments : Association to many SupplierAssignments
                      on assignments.supplier = $self;
}


/**
 * Supplier-Appraiser Assignment
 */
entity SupplierAssignments : cuid, managed {
    supplier       : Association to Suppliers            @mandatory;
    appraiser      : Association to appraiser.Appraisers @mandatory;
    assignedDate   : Date                                @title: 'Assigned Date';
    isActive       : Boolean                             @title: 'Active' default true;
    questionnaires : String(500)                         @title: 'Assigned Questionnaires (JSON)'; // Array of questionnaire IDs
    notes          : String(1000)                        @title: 'Assignment Notes';
}
