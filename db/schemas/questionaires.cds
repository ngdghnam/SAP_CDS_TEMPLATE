using {
    cuid,
    managed,
    sap
} from '@sap/cds/common';

using {sap.evaluations as evaluation} from './evaluations';
using {sap.codelists as codelist} from './codelist';

namespace sap.questionaires;

/**
 * Questionnaire Templates
 */
entity Questionnaires : cuid, managed {
    questionnaireID : String(10)                                      @title: 'Questionnaire ID';
    name            : String(255)                                     @title: 'Questionnaire Name'  @mandatory;
    description     : String(1000)                                    @title: 'Description';
    version         : String(20)                                      @title: 'Version';
    category        : Association to codelist.QuestionnaireCategories @title: 'Category';
    isActive        : Boolean                                         @title: 'Active' default true;
    isTemplate      : Boolean                                         @title: 'Is Template' default true;
    // Associations
    sections        : Composition of many QuestionnaireSections
                          on sections.questionnaire = $self;
    evaluations     : Association to many evaluation.Evaluations
                          on evaluations.questionnaire = $self;
}

/**
 * Questionnaire Sections
 */
entity QuestionnaireSections : cuid {
    questionnaire : Association to Questionnaires;
    sectionNumber : Integer       @title: 'Section Number';
    title         : String(255)   @title: 'Section Title'  @mandatory;
    description   : String(1000)  @title: 'Description';
    weight        : Decimal(5, 2) @title: 'Weight (%)'; // For weighted scoring
    // Associations
    questions     : Composition of many Questions
                        on questions.section = $self;
}

/**
 * Questions in Questionnaire
 */
entity Questions : cuid {
    section        : Association to QuestionnaireSections;
    questionNumber : String(20)                            @title: 'Question Number';
    text           : String(1000)                          @title: 'Question Text'  @mandatory;
    questionType   : Association to codelist.QuestionTypes @title: 'Question Type';
    isMandatory    : Boolean                               @title: 'Mandatory' default false;
    weight         : Decimal(5, 2)                         @title: 'Weight'; // Individual question weight
    helpText       : String(500)                           @title: 'Help Text';
    // For rating type questions
    minRating      : Integer                               @title: 'Minimum Rating';
    maxRating      : Integer                               @title: 'Maximum Rating';
    // For multiple choice
    choices        : String(1000)                          @title: 'Choices (JSON)'; // Store as JSON array
    // Associations
    responses      : Association to many QuestionResponses
                         on responses.question = $self;
}

/**
 * Question Responses
 */
entity QuestionResponses : cuid {
    evaluation      : Association to evaluation.Evaluations;
    question        : Association to Questions;
    // Response values
    responseText    : String(2000)  @title: 'Text Response';
    responseRating  : Integer       @title: 'Rating Response';
    responseBoolean : Boolean       @title: 'Yes/No Response';
    responseChoice  : String(500)   @title: 'Multiple Choice Response';
    // Scoring
    score           : Decimal(5, 2) @title: 'Score';
    maxScore        : Decimal(5, 2) @title: 'Maximum Score';
    // Metadata
    respondedAt     : Timestamp     @title: 'Responded At';
    notes           : String(1000)  @title: 'Notes';
}
