using {sap.common.CodeList} from '@sap/cds/common';

namespace sap.codelists;

/**
 * Evaluation Status Code List
 */
entity EvaluationStatuses : CodeList {
    key code : String(20);
}

/**
 * Grade Code List
 */
entity Grades : CodeList {
    key code : String(10);
}

/**
 * Question Types Code List
 */
entity QuestionTypes : CodeList {
    key code : String(50);
}

/**
 * Supplier Status Code List
 */
entity SupplierStatuses : CodeList {
    key code : String(20);
}

/**
 * Supplier Categories Code List
 */
entity SupplierCategories : CodeList {
    key code : String(50);
}

/**
 * Comment Types Code List
 */
entity CommentTypes : CodeList {
    key code : String(50);
}

/**
 * Questionnaire Categories Code List
 */
entity QuestionnaireCategories : CodeList {
    key code : String(100);
}

/**
 * Language Code List
 */
entity Languages : CodeList {
    key code : String(10);
}

/**
 * Department Code List (for Appraisers)
 */
entity Departments : CodeList {
    key code : String(100);
}

/**
 * Appraiser Role Code List
 */
entity AppraiserRoles : CodeList {
    key code : String(100);
}
