import * as cds from "@sap/cds";
import { Request } from "@sap/cds";

export class EvaluationService extends cds.ApplicationService {
  async init(): Promise<void> {

    const { Entity } = cds.entities('sap.evaluations')

    await super.init();
  }
}
