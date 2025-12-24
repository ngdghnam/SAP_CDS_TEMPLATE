using {sap.codelists as codelist} from '../schemas/codelist';
using {sap.questionaires as questionnaire} from '../schemas/questionaires';
using {sap.EvaluationView as vEvaluation} from './evaluations';
using {sap.evaluations as evaluation} from '../schemas/evaluations';


namespace sap.QuestionairesView;


/**
 * Questionnaire List View
 */
@readonly
view QuestionnaireListView as
    select
        q.ID,
        q.createdAt,
        q.createdBy,
        q.modifiedAt,
        q.modifiedBy,

        q.questionnaireID,
        q.name,
        q.description,
        q.version,
        q.category.code  as categoryCode,
        q.category.name  as categoryName,
        q.category.descr as categoryDescription,
        q.isActive,
        q.isTemplate,

        // Associations
        q.category    : redirected to codelist.QuestionnaireCategories,
        q.sections    : redirected to QuestionnaireSectionsView,
        q.evaluations : redirected to vEvaluation.EvaluationListView

    from questionnaire.Questionnaires as q;

/**
 * Questionnaire Detail View
 */
@readonly
view QuestionnaireDetailView as
    select
        q.ID,
        q.createdAt,
        q.createdBy,
        q.modifiedAt,
        q.modifiedBy,

        q.questionnaireID,
        q.name,
        q.description,
        q.version,
        q.category.code  as categoryCode,
        q.category.name  as categoryName,
        q.category.descr as categoryDescription,
        q.isActive,
        q.isTemplate,

        // Associations
        q.category    : redirected to codelist.QuestionnaireCategories,
        q.sections    : redirected to QuestionnaireSectionsView,
        q.evaluations : redirected to vEvaluation.EvaluationListView

    from questionnaire.Questionnaires as q;

/**
 * Questionnaire Sections View
 */
@readonly
view QuestionnaireSectionsView as
    select
        s.ID,

        q.ID   as questionnaire_ID,
        q.questionnaireID,
        q.name as questionnaireName,

        s.sectionNumber,
        s.title,
        s.description,
        s.weight,

        // Associations
        s.questionnaire : redirected to QuestionnaireDetailView,
        s.questions     : redirected to QuestionsView

    from questionnaire.QuestionnaireSections as s
    left join questionnaire.Questionnaires as q
        on s.questionnaire.ID = q.ID;

/**
 * Questions View
 */
@readonly
view QuestionsView as
    select
        qu.ID,

        s.ID                  as section_ID,
        s.sectionNumber,
        s.title               as sectionTitle,

        q.ID                  as questionnaire_ID,
        q.questionnaireID,
        q.name                as questionnaireName,

        qu.questionNumber,
        qu.text,
        qu.questionType.code  as questionTypeCode,
        qu.questionType.name  as questionTypeName,
        qu.questionType.descr as questionTypeDescription,
        qu.isMandatory,
        qu.weight,
        qu.helpText,
        qu.minRating,
        qu.maxRating,
        qu.choices,

        // Associations
        qu.section      : redirected to QuestionnaireSectionsView,
        qu.questionType : redirected to codelist.QuestionTypes,
        qu.responses    : redirected to QuestionResponseDetailView

    from questionnaire.Questions as qu
    left join questionnaire.QuestionnaireSections as s
        on qu.section.ID = s.ID
    left join questionnaire.Questionnaires as q
        on s.questionnaire.ID = q.ID;

/**
 * Question Response Detail View
 */
@readonly
view QuestionResponseDetailView as
    select
        r.ID,

        e.ID                 as evaluation_ID,
        e.evaluationID,
        e.title              as evaluationTitle,

        qu.ID                as question_ID,
        qu.questionNumber,
        qu.text              as questionText,
        qu.questionType.code as questionType,
        qu.questionType.name as questionTypeName,

        s.ID                 as section_ID,
        s.sectionNumber,
        s.title              as sectionTitle,

        r.responseText,
        r.responseRating,
        r.responseBoolean,
        r.responseChoice,
        r.score,
        r.maxScore,
        r.respondedAt,
        r.notes,

        // Associations
        r.evaluation : redirected to vEvaluation.EvaluationDetailView,
        r.question   : redirected to QuestionsView

    from questionnaire.QuestionResponses as r
    left join evaluation.Evaluations as e
        on r.evaluation.ID = e.ID
    left join questionnaire.Questions as qu
        on r.question.ID = qu.ID
    left join questionnaire.QuestionnaireSections as s
        on qu.section.ID = s.ID;
