using { sap.evaluations as evaluation } from '../db/schemas/evaluations';
using { sap.EvaluationView as vEvaluation } from '../db/views/evaluations';

@(path: '/api/cnma/evaluation')
service EvaluationService {
    entity Evaluation as projection on evaluation.Evaluations;
    entity EvaluationDetailView as projection on vEvaluation.EvaluationDetailView;

    action onCreateEvaluation() returns EvaluationDetailView ;
}   