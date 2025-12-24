using {sap.codelists as codelist} from '../schemas/codelist';
using {sap.appraisers as appraiser} from '../schemas/appraisers';
using {sap.EvaluationView as vEvaluation} from './evaluations';
using {sap.SupplierView as vSupplier} from './suppliers';
using {sap.evaluations as evaluation} from '../schemas/evaluations';
using {sap.suppliers as supplier} from '../schemas/suppliers';

namespace sap.AppraisersView;

/**
 * Appraiser List View
 */
@readonly
view AppraiserListView as
    select
        a.ID,
        a.createdAt,
        a.createdBy,
        a.modifiedAt,
        a.modifiedBy,

        a.appraiserID,
        a.name,
        a.email,
        a.department.code  as departmentCode,
        a.department.name  as departmentName,
        a.department.descr as departmentDescription,
        a.role.code        as roleCode,
        a.role.name        as roleName,
        a.role.descr       as roleDescription,
        a.phone,
        a.isActive,

        // Associations
        a.department  : redirected to codelist.Departments,
        a.role        : redirected to codelist.AppraiserRoles,
        a.assignments : redirected to vSupplier.SupplierAssignmentsView,
        a.evaluations : redirected to vEvaluation.EvaluationListView

    from appraiser.Appraisers as a;

/**
 * Appraiser Detail View
 */
@readonly
view AppraiserDetailView as
    select
        a.ID,
        a.createdAt,
        a.createdBy,
        a.modifiedAt,
        a.modifiedBy,

        a.appraiserID,
        a.name,
        a.email,
        a.department.code  as departmentCode,
        a.department.name  as departmentName,
        a.department.descr as departmentDescription,
        a.role.code        as roleCode,
        a.role.name        as roleName,
        a.role.descr       as roleDescription,
        a.phone,
        a.isActive,

        // Associations
        a.department  : redirected to codelist.Departments,
        a.role        : redirected to codelist.AppraiserRoles,
        a.assignments : redirected to vSupplier.SupplierAssignmentsView,
        a.evaluations : redirected to vEvaluation.EvaluationListView

    from appraiser.Appraisers as a;

/**
 * Appraiser Workload View
 */
@readonly
view AppraiserWorkloadView as
    select
        a.ID,
        a.appraiserID,
        a.name,
        a.department.code as departmentCode,
        a.department.name as departmentName,
        a.role.code       as roleCode,
        a.role.name       as roleName,
        a.isActive,

        COUNT(e.ID)       as totalEvaluations       : Integer,

        SUM(case
                when e.status.code = 'Draft'
                     then 1
                else 0
            end)          as draftEvaluations       : Integer,
        SUM(case
                when e.status.code = 'In Progress'
                     then 1
                else 0
            end)          as inProgressEvaluations  : Integer,
        SUM(case
                when e.status.code = 'Submitted'
                     then 1
                else 0
            end)          as submittedEvaluations   : Integer,
        SUM(case
                when e.status.code = 'Under Review'
                     then 1
                else 0
            end)          as underReviewEvaluations : Integer,
        SUM(case
                when e.status.code = 'Approved'
                     then 1
                else 0
            end)          as approvedEvaluations    : Integer,

        COUNT(sa.ID)      as totalAssignments       : Integer,
        SUM(case
                when sa.isActive = true
                     then 1
                else 0
            end)          as activeAssignments      : Integer,

        // Associations
        a.department                                : redirected to codelist.Departments,
        a.role                                      : redirected to codelist.AppraiserRoles,
        a.evaluations                               : redirected to vEvaluation.EvaluationListView,
        a.assignments                               : redirected to vSupplier.SupplierAssignmentsView

    from appraiser.Appraisers as a
    left join evaluation.Evaluations as e
        on e.appraiser.ID = a.ID
    left join supplier.SupplierAssignments as sa
        on sa.appraiser.ID = a.ID
    group by
        a.ID,
        a.appraiserID,
        a.name,
        a.department.code,
        a.department.name,
        a.role.code,
        a.role.name,
        a.isActive;
