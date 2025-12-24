using {sap.evaluations as my} from '../../../db/schemas/evaluations';

@path: ('/api/cnma/evaluations')
service Evaluation {
    @readonly
    entity Evaluations as
        projection on my.Evaluations {
            *
        }
}
