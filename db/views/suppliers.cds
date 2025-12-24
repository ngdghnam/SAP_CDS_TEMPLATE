using {sap.codelists as codelist} from '../schemas/codelist';
using {sap.suppliers as supplier} from '../schemas/suppliers';
using {sap.EvaluationView as vEvaluation} from './evaluations';
using {sap.evaluations as evaluation} from '../schemas/evaluations';
using {sap.appraisers as appraiser} from '../schemas/appraisers';
using {sap.AppraisersView as vAppraiser} from './appraisers';


namespace sap.SupplierView;

/**
 * Supplier List View
 */
@readonly
view SupplierListView as
    select
        s.ID,
        s.createdAt,
        s.createdBy,
        s.modifiedAt,
        s.modifiedBy,

        s.supplierID,
        s.name,
        s.email,
        s.phone,
        s.city,
        s.country,
        s.category.code  as categoryCode,
        s.category.name  as categoryName,
        s.category.descr as categoryDescription,
        s.status.code    as statusCode,
        s.status.name    as statusName,
        s.status.descr   as statusDescription,
        s.rating,

        // Associations
        s.status      : redirected to codelist.SupplierStatuses,
        s.category    : redirected to codelist.SupplierCategories,
        s.evaluations : redirected to vEvaluation.EvaluationListView,
        s.assignments : redirected to SupplierAssignmentsView

    from supplier.Suppliers as s;

/**
 * Supplier Detail View
 */
@readonly
view SupplierDetailView as
    select
        s.ID,
        s.createdAt,
        s.createdBy,
        s.modifiedAt,
        s.modifiedBy,

        s.supplierID,
        s.name,
        s.email,
        s.phone,
        s.address,
        s.city,
        s.country,
        s.postalCode,
        s.category.code  as categoryCode,
        s.category.name  as categoryName,
        s.category.descr as categoryDescription,
        s.status.code    as statusCode,
        s.status.name    as statusName,
        s.status.descr   as statusDescription,
        s.rating,

        // Associations
        s.status      : redirected to codelist.SupplierStatuses,
        s.category    : redirected to codelist.SupplierCategories,
        s.evaluations : redirected to vEvaluation.EvaluationListView,
        s.assignments : redirected to SupplierAssignmentsView

    from supplier.Suppliers as s;

/**
 * Supplier Assignments View
 */
@readonly
view SupplierAssignmentsView as
    select
        sa.ID,
        sa.createdAt,
        sa.createdBy,
        sa.modifiedAt,
        sa.modifiedBy,

        s.ID               as supplier_ID,
        s.supplierID,
        s.name             as supplierName,

        ap.ID              as appraiser_ID,
        ap.appraiserID,
        ap.name            as appraiserName,
        ap.department.code as appraiserDepartment,
        ap.department.name as appraiserDepartmentName,

        sa.assignedDate,
        sa.isActive,
        sa.questionnaires,
        sa.notes,

        // Associations
        sa.supplier  : redirected to SupplierDetailView,
        sa.appraiser : redirected to vAppraiser.AppraiserDetailView

    from supplier.SupplierAssignments as sa
    left join supplier.Suppliers as s
        on sa.supplier.ID = s.ID
    left join appraiser.Appraisers as ap
        on sa.appraiser.ID = ap.ID;

/**
 * Supplier Performance View
 */
@readonly
view SupplierPerformanceView as
    select
        s.ID,
        s.supplierID,
        s.name,
        s.category.code      as categoryCode,
        s.category.name      as categoryName,
        s.country,
        s.status.code        as statusCode,
        s.status.name        as statusName,
        s.rating,

        COUNT(e.ID)          as totalEvaluations   : Integer,
        AVG(e.percentage)    as avgScore           : Decimal(5, 2),

        SUM(case
                when e.grade.code = 'A'
                     then 1
                else 0
            end)             as gradeA             : Integer,
        SUM(case
                when e.grade.code = 'B'
                     then 1
                else 0
            end)             as gradeB             : Integer,
        SUM(case
                when e.grade.code = 'C'
                     then 1
                else 0
            end)             as gradeC             : Integer,
        SUM(case
                when e.grade.code = 'D'
                     then 1
                else 0
            end)             as gradeD             : Integer,
        SUM(case
                when e.grade.code = 'F'
                     then 1
                else 0
            end)             as gradeF             : Integer,

        MAX(e.completedDate) as lastEvaluationDate : Date,

        // Association
        s.status                                   : redirected to codelist.SupplierStatuses,
        s.category                                 : redirected to codelist.SupplierCategories,
        s.evaluations                              : redirected to vEvaluation.EvaluationListView

    from supplier.Suppliers as s
    left join evaluation.Evaluations as e
        on e.supplier.ID = s.ID
    group by
        s.ID,
        s.supplierID,
        s.name,
        s.category.code,
        s.category.name,
        s.country,
        s.status.code,
        s.status.name,
        s.rating;
