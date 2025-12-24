using {sap.questionaires as my} from '../../../db/schemas/questionaires'

@(path: '/api/cnma/questionaires')
service Questionnaire {
    @readonly
    entity Questionaires as
        projection on my.Questionnaires {

        };
}
