using {
    cuid,
    managed,
} from '@sap/cds/common';

using {sap.suppliers as supplier} from './suppliers';
using {sap.evaluations as evaluation} from './evaluations';
using {sap.codelists as codelist} from './codelist';

namespace sap.appraisers;

/**
 * Master Data: Appraisers (Evaluators)
 */
entity Appraisers : cuid, managed {
    appraiserID : String(10)                             @title: 'Appraiser ID';
    name        : String(255)                            @title: 'Full Name'  @mandatory;
    email       : String(255)                            @title: 'Email'      @mandatory;
    department  : Association to codelist.Departments    @title: 'Department';
    role        : Association to codelist.AppraiserRoles @title: 'Role';
    phone       : String(50)                             @title: 'Phone';
    isActive    : Boolean                                @title: 'Active' default true;
    // Associations
    assignments : Association to many supplier.SupplierAssignments
                      on assignments.appraiser = $self;
    evaluations : Association to many evaluation.Evaluations
                      on evaluations.appraiser = $self;
}
