export const generatePaths = (service: any): any => {
  const paths: any = {};

  if (!service.entities) return paths;

  for (const [entityName, entity] of Object.entries(service.entities)) {
    const entityDef = entity as any;

    // Skip draft entities và associations
    if (entityName.includes("_") || entityName.startsWith("Draft")) continue;

    const entityPath = `/${entityName}`;

    // GET collection
    paths[entityPath] = {
      get: {
        summary: `Get all ${entityName}`,
        tags: [entityName],
        parameters: [
          {
            name: "$top",
            in: "query",
            schema: { type: "integer" },
            description: "Show only the first n items",
          },
          {
            name: "$skip",
            in: "query",
            schema: { type: "integer" },
            description: "Skip the first n items",
          },
          {
            name: "$filter",
            in: "query",
            schema: { type: "string" },
            description: "Filter items by property values",
          },
        ],
        responses: {
          "200": {
            description: "Retrieved entities",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    value: {
                      type: "array",
                      items: { $ref: `#/components/schemas/${entityName}` },
                    },
                  },
                },
              },
            },
          },
        },
      },
    };

    // POST
    if (!entityDef["@readonly"]) {
      paths[entityPath].post = {
        summary: `Create ${entityName}`,
        tags: [entityName],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: `#/components/schemas/${entityName}` },
            },
          },
        },
        responses: {
          "201": { description: "Created" },
        },
      };
    }

    // GET by key
    const keyName = getKeyName(entityDef);
    paths[`${entityPath}({${keyName}})`] = {
      get: {
        summary: `Get ${entityName} by key`,
        tags: [entityName],
        parameters: [
          {
            name: keyName,
            in: "path",
            required: true,
            schema: { type: "string" },
          },
        ],
        responses: {
          "200": {
            description: "Retrieved entity",
            content: {
              "application/json": {
                schema: { $ref: `#/components/schemas/${entityName}` },
              },
            },
          },
        },
      },
    };

    // PATCH & DELETE
    if (!entityDef["@readonly"]) {
      paths[`${entityPath}({${keyName}})`].patch = {
        summary: `Update ${entityName}`,
        tags: [entityName],
        parameters: [
          {
            name: keyName,
            in: "path",
            required: true,
            schema: { type: "string" },
          },
        ],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: { $ref: `#/components/schemas/${entityName}` },
            },
          },
        },
        responses: {
          "200": { description: "Updated" },
        },
      };

      paths[`${entityPath}({${keyName}})`].delete = {
        summary: `Delete ${entityName}`,
        tags: [entityName],
        parameters: [
          {
            name: keyName,
            in: "path",
            required: true,
            schema: { type: "string" },
          },
        ],
        responses: {
          "204": { description: "Deleted" },
        },
      };
    }
  }

  return paths;
};

export const generateSchemas = (service: any): any => {
  const schemas: any = {};

  if (!service.entities) return schemas;

  for (const [entityName, entity] of Object.entries(service.entities)) {
    const entityDef = entity as any;

    // Skip draft entities
    if (entityName.includes("_") || entityName.startsWith("Draft")) continue;

    const properties: any = {};
    const required: string[] = [];

    if (entityDef.elements) {
      for (const [elemName, elem] of Object.entries(entityDef.elements)) {
        const elemDef = elem as any;

        // Skip associations và compositions
        if (
          elemDef.target ||
          elemDef.type === "cds.Association" ||
          elemDef.type === "cds.Composition"
        ) {
          continue;
        }

        properties[elemName] = {
          type: mapCdsTypeToOpenApi(elemDef.type),
          description: elemDef["@title"] || elemDef["@description"] || "",
        };

        if (elemDef.key) {
          properties[elemName].readOnly = true;
        }

        if (elemDef.notNull && !elemDef.key) {
          required.push(elemName);
        }
      }
    }

    schemas[entityName] = {
      type: "object",
      properties,
      ...(required.length > 0 && { required }),
    };
  }

  return schemas;
};

export const getKeyName = (entity: any): string => {
  if (entity.elements) {
    for (const [name, elem] of Object.entries(entity.elements)) {
      const elemDef = elem as any;
      if (elemDef.key) return name;
    }
  }
  return "ID";
};

export const mapCdsTypeToOpenApi = (cdsType: string): string => {
  const typeMap: { [key: string]: string } = {
    "cds.String": "string",
    "cds.Integer": "integer",
    "cds.Integer64": "integer",
    "cds.Decimal": "number",
    "cds.Double": "number",
    "cds.Boolean": "boolean",
    "cds.Date": "string",
    "cds.DateTime": "string",
    "cds.Time": "string",
    "cds.Timestamp": "string",
    "cds.UUID": "string",
  };

  return typeMap[cdsType] || "string";
};
