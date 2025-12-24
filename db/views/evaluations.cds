using {sap.evaluations as evaluation} from '../schemas/evaluations';
using {sap.codelists as codelist} from '../schemas/codelist';
using {sap.questionaires as questionnaire} from '../schemas/questionaires';
using {sap.appraisers as appraiser} from '../schemas/appraisers';
using {sap.suppliers as supplier} from '../schemas/suppliers';
using {sap.AppraisersView as vAppraiser} from './appraisers';
using {sap.SupplierView as vSupplier} from './suppliers';
using {sap.QuestionairesView as vQuestionaire} from './questionaires';


namespace sap.EvaluationView;

/**
 * Evaluation List View
 */
@readonly
view EvaluationListView as
    select
        e.ID,
        e.createdAt,
        e.createdBy,
        e.modifiedAt,
        e.modifiedBy,

        e.evaluationID,
        e.title,
        e.description,

        e.status.code      as statusCode,
        e.status.name      as statusName,
        e.status.descr     as statusDescription,

        e.grade.code       as gradeCode,
        e.grade.name       as gradeName,
        e.grade.descr      as gradeDescription,

        e.startDate,
        e.dueDate,
        e.completedDate,
        e.totalScore,
        e.maxScore,
        e.percentage,

        e.language.code    as languageCode,
        e.language.name    as languageName,

        e.communicationSent,
        e.supplierNotified,

        // Supplier information
        s.ID               as supplier_ID,
        s.supplierID,
        s.name             as supplierName,
        s.email            as supplierEmail,
        s.category.code    as supplierCategory,
        s.category.name    as supplierCategoryName,
        s.status.code      as supplierStatus,
        s.status.name      as supplierStatusName,

        // Appraiser information
        ap.ID              as appraiser_ID,
        ap.appraiserID,
        ap.name            as appraiserName,
        ap.email           as appraiserEmail,
        ap.department.code as appraiserDepartment,
        ap.department.name as appraiserDepartmentName,

        // Questionnaire information
        q.ID               as questionnaire_ID,
        q.questionnaireID,
        q.name             as questionnaireName,
        q.category.code    as questionnaireCategory,
        q.category.name    as questionnaireCategoryName,

        // Associations
        e.supplier      : redirected to vSupplier.SupplierDetailView,
        e.appraiser     : redirected to vAppraiser.AppraiserDetailView,
        e.questionnaire : redirected to vQuestionaire.QuestionnaireDetailView,
        e.status        : redirected to codelist.EvaluationStatuses,
        e.grade         : redirected to codelist.Grades,
        e.language      : redirected to codelist.Languages,
        e.responses     : redirected to vQuestionaire.QuestionResponseDetailView,
        e.comments      : redirected to EvaluationCommentsView,
        e.attachments   : redirected to EvaluationAttachmentsView

    from evaluation.Evaluations as e
    left join supplier.Suppliers as s
        on e.supplier.ID = s.ID
    left join appraiser.Appraisers as ap
        on e.appraiser.ID = ap.ID
    left join questionnaire.Questionnaires as q
        on e.questionnaire.ID = q.ID;


/**
 * Evaluation Detail View
 */
@readonly
view EvaluationDetailView as
    select
        e.ID,
        e.createdAt,
        e.createdBy,
        e.modifiedAt,
        e.modifiedBy,

        e.evaluationID,
        e.title,
        e.description,

        e.status.code      as statusCode,
        e.status.name      as statusName,
        e.status.descr     as statusDescription,

        e.grade.code       as gradeCode,
        e.grade.name       as gradeName,
        e.grade.descr      as gradeDescription,

        e.startDate,
        e.dueDate,
        e.completedDate,
        e.totalScore,
        e.maxScore,
        e.percentage,

        e.language.code    as languageCode,
        e.language.name    as languageName,

        e.communicationSent,
        e.supplierNotified,

        // Supplier detailed information
        s.ID               as supplier_ID,
        s.supplierID,
        s.name             as supplierName,
        s.email            as supplierEmail,
        s.phone            as supplierPhone,
        s.address          as supplierAddress,
        s.city             as supplierCity,
        s.country          as supplierCountry,
        s.postalCode       as supplierPostalCode,
        s.category.code    as supplierCategory,
        s.category.name    as supplierCategoryName,
        s.category.descr   as supplierCategoryDescription,
        s.status.code      as supplierStatus,
        s.status.name      as supplierStatusName,
        s.rating           as supplierRating,

        // Appraiser detailed information
        ap.ID              as appraiser_ID,
        ap.appraiserID,
        ap.name            as appraiserName,
        ap.email           as appraiserEmail,
        ap.phone           as appraiserPhone,
        ap.department.code as appraiserDepartment,
        ap.department.name as appraiserDepartmentName,
        ap.role.code       as appraiserRole,
        ap.role.name       as appraiserRoleName,

        // Questionnaire detailed information
        q.ID               as questionnaire_ID,
        q.questionnaireID,
        q.name             as questionnaireName,
        q.description      as questionnaireDescription,
        q.version          as questionnaireVersion,
        q.category.code    as questionnaireCategory,
        q.category.name    as questionnaireCategoryName,
        q.isActive         as questionnaireActive,

        // Associations
        e.supplier      : redirected to vSupplier.SupplierDetailView,
        e.appraiser     : redirected to vAppraiser.AppraiserDetailView,
        e.questionnaire : redirected to vQuestionaire.QuestionnaireDetailView,
        e.status        : redirected to codelist.EvaluationStatuses,
        e.grade         : redirected to codelist.Grades,
        e.language      : redirected to codelist.Languages,
        e.responses     : redirected to vQuestionaire.QuestionResponseDetailView,
        e.comments      : redirected to EvaluationCommentsView,
        e.attachments   : redirected to EvaluationAttachmentsView

    from evaluation.Evaluations as e
    left join supplier.Suppliers as s
        on e.supplier.ID = s.ID
    left join appraiser.Appraisers as ap
        on e.appraiser.ID = ap.ID
    left join questionnaire.Questionnaires as q
        on e.questionnaire.ID = q.ID;


/**
 * Evaluation Comments View
 */
@readonly
view EvaluationCommentsView as
    select
        c.ID,
        c.createdAt,
        c.createdBy,
        c.modifiedAt,
        c.modifiedBy,

        e.ID                as evaluation_ID,
        e.evaluationID,
        e.title             as evaluationTitle,

        c.commentText,
        c.commentType.code  as commentTypeCode,
        c.commentType.name  as commentTypeName,
        c.commentType.descr as commentTypeDescription,
        c.isInternal,

        // Association
        c.evaluation  : redirected to EvaluationDetailView,
        c.commentType : redirected to codelist.CommentTypes

    from evaluation.EvaluationComments as c
    left join evaluation.Evaluations as e
        on c.evaluation.ID = e.ID
    order by
        c.createdAt desc;

/**
 * Evaluation Attachments View
 */
@readonly
view EvaluationAttachmentsView as
    select
        a.ID,
        a.createdAt,
        a.createdBy,
        a.modifiedAt,
        a.modifiedBy,

        e.ID    as evaluation_ID,
        e.evaluationID,
        e.title as evaluationTitle,

        a.fileName,
        a.fileType,
        a.fileSize,
        a.fileUrl,
        a.description,

        // Association
        a.evaluation : redirected to EvaluationDetailView

    from evaluation.EvaluationAttachments as a
    left join evaluation.Evaluations as e
        on a.evaluation.ID = e.ID;
