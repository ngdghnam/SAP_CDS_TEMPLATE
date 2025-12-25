using {
    cuid,
    managed,
} from '@sap/cds/common';

using {sap.suppliers as supplier} from './suppliers';
using {sap.questionaires as questionnaire} from './questionaires';
using {sap.appraisers as appraiser} from './appraisers';
using {sap.codelists as codelist} from './codelist';

namespace sap.evaluations;

/**
 * Evaluation (Main evaluation record)
 */
entity Evaluations : cuid, managed {
    evaluationID      : String(20)                                      @title: 'Evaluation ID';
    title             : String(255)                                 @title: 'Evaluation Title'  @mandatory;
    description       : String(1000)                                @title: 'Description';
    supplier          : Association to supplier.Suppliers           @mandatory;
    questionnaire     : Association to questionnaire.Questionnaires @mandatory;
    appraiser         : Association to appraiser.Appraisers         @mandatory;
    // Dates
    startDate         : Date                                        @title: 'Start Date';
    dueDate           : Date                                        @title: 'Due Date';
    completedDate     : Date                                        @title: 'Completed Date';
    // Status
    status            : Association to codelist.EvaluationStatuses  @title: 'Status';
    // Draft, In Progress, Submitted, Under Review, Approved, Rejected, Cancelled
    // Scoring
    totalScore        : Decimal(5, 2)                               @title: 'Total Score';
    maxScore          : Decimal(5, 2)                               @title: 'Maximum Score';
    percentage        : Decimal(5, 2)                               @title: 'Percentage';
    grade             : Association to codelist.Grades              @title: 'Grade';
    // Communication
    language          : Association to codelist.Languages           @title: 'Language';
    communicationSent : Boolean                                     @title: 'Communication Sent' default false;
    supplierNotified  : Boolean                                     @title: 'Supplier Notified' default false;
    // Associations - Relations
    responses         : Composition of many questionnaire.QuestionResponses
                            on responses.evaluation = $self;
    comments          : Composition of many EvaluationComments
                            on comments.evaluation = $self;
    attachments       : Composition of many EvaluationAttachments
                            on attachments.evaluation = $self;
}


/**
 * Evaluation Comments/Notes
 */
entity EvaluationComments : cuid, managed {
    evaluation  : Association to Evaluations;
    commentText : String(2000)                         @title: 'Comment'  @mandatory;
    commentType : Association to codelist.CommentTypes @title: 'Comment Type';
    isInternal  : Boolean                              @title: 'Internal Only' default false;
}

/**
 * Evaluation Attachments
 */
entity EvaluationAttachments : cuid, managed {
    evaluation  : Association to Evaluations;
    fileName    : String(255)  @title: 'File Name';
    fileType    : String(100)  @title: 'File Type';
    fileSize    : Integer      @title: 'File Size (bytes)';
    fileUrl     : String(1000) @title: 'File URL';
    description : String(500)  @title: 'Description';
}
