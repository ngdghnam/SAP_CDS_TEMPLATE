using { sap.appraisers as appraiser } from '../db/schemas/appraisers';
using { sap.AppraisersView as vAppraiser } from '../db/views/appraisers';


@(path: 'ap/cnma/appraiser')
service AppraiserService  {
    @readonly entity Appraisers as projection on appraiser.Appraisers;
    entity DetailAppraiser as projection on vAppraiser.AppraiserDetailView;

    // CREATE A NEW APPRAISER - POST METHOD
    action onCreateAppraiser(
        
    ) returns DetailAppraiser;
}