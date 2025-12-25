import cds from "@sap/cds";
import express from "express";
import swaggerUi from "swagger-ui-express";

cds.on("bootstrap", (app: express.Application) => {
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
});
