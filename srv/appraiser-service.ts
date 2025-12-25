import cds from "@sap/cds"

export class AppraiserService extends cds.ApplicationService{
    async init(): Promise<void> {
        await super.init()
    }
}