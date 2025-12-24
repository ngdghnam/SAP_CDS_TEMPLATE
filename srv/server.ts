import cds from "@sap/cds";
import express from "express";
import swaggerUi from "swagger-ui-express";
import { generatePaths, generateSchemas } from "./utils/swagger";

cds.on("bootstrap", (app: express.Application) => {
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
});

// CONFIG SWAGGER
cds.on("served", async (services: any) => {
  const app = cds.app as express.Application;

  // Debug: Log tất cả services
  //   console.log("\n🔍 All CDS Services:");
  //   for (const [key, srv] of Object.entries(cds.services)) {
  //     const service = srv as any;
  //     console.log(
  //       `   - ${key}: ${service.name} (path: ${service.path || "N/A"})`
  //     );
  //   }

  // Lấy các application services
  const appServices = Object.values(services).filter(
    (srv: any) => srv && srv.name && !srv.name.startsWith("cds.")
  );

  //   console.log(`\n✅ Found ${appServices.length} application service(s)\n`);

  //   if (appServices.length === 0) {
  //     console.log(
  //       "⚠️  No application services found. Check your service definitions."
  //     );
  //     return;
  //   }

  // Tạo Swagger docs cho từng service
  const swaggerDocs: any = {};

  for (const srv of appServices) {
    const service = srv as any;
    const serviceName = service.name;
    const servicePath = service.path || `/${serviceName}`;

    // Tạo OpenAPI spec cơ bản
    const openApiSpec = {
      openapi: "3.0.0",
      info: {
        title: `${serviceName} Service`,
        version: "1.0.0",
        description: `REST API for ${serviceName}`,
      },
      servers: [
        {
          url: servicePath,
          description: "Service endpoint",
        },
      ],
      paths: generatePaths(service),
      components: {
        schemas: generateSchemas(service),
      },
    };

    swaggerDocs[serviceName] = openApiSpec;

    // Mount Swagger UI
    app.use(
      `/swagger/${serviceName}`,
      swaggerUi.serveFiles(openApiSpec, {}),
      swaggerUi.setup(openApiSpec, {
        explorer: true,
        customSiteTitle: `${serviceName} API`,
      })
    );

    console.log(`${serviceName}: http://localhost:4004/swagger/${serviceName}`);
  }

  // Endpoint chính
  if (appServices.length === 1) {
    const service = appServices[0] as any;
    app.get("/swagger", (req, res) => {
      res.redirect(`/swagger/${service.name}`);
    });
  } else {
    app.get("/swagger", (req, res) => {
      const links = appServices
        .map((s: any) => `<li><a href="/swagger/${s.name}">${s.name}</a></li>`)
        .join("");
      res.send(`<h1>API Documentation</h1><ul>${links}</ul>`);
    });
  }

  console.log(`\n Main: http://localhost:4004/swagger\n`);
});
