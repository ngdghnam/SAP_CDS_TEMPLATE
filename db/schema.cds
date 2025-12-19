using {sap.common.CodeList} from '@sap/cds/common';


namespace supplier.evaluation;

/**
 * Code Lists
 */
entity EvaluationStatuses : CodeList {
    key code : String(20);
}

entity QuestionTypes : CodeList {
    key code : String(50);
}

entity SupplierCategories : CodeList {
    key code : String(50);
}
