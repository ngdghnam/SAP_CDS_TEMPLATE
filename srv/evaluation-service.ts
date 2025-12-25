import cds from "@sap/cds";

export class EvaluationService extends cds.ApplicationService {
    async init(): Promise<void> {

        const {Evaluation, EvaluationDetailView} = this.entities

        this.on('onCreateEvaluation', async (req: cds.Request) => {
            const {} = req.data

            // const code = await 
        })

        await super.init()
    }
}