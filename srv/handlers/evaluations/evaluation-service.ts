import * as cds from "@sap/cds";
import { Request } from "@sap/cds";

export class EvaluationService extends cds.ApplicationService {
  async init(): Promise<void> {
    await super.init();
  }
}
