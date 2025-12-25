import cds from "@sap/cds";

export class SupplierService extends cds.ApplicationService {
    async init(): Promise<void> {
        await super.init()
    }
}