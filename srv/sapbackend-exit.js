const cds = require("@sap/cds");

/* module.exports = cds.service.impl(async function() {
    const { Incidents } = this.entities;
    const sapbackend = await cds.connect.to("sapbackend");

    this.on("READ", Incidents, async (req) => {
        return await sapbackend.tx(req).send({
            query : req.query,            
            headers : {
                Authorization: "Basic c2FwdWk1OnNhcHVpNQ=="
            }
        });
    });
}); */

module.exports = async (srv) => {
    const { Incidents } = srv.entities;
    const sapbackend = await cds.connect.to("sapbackend");

    srv.on(["READ"], Incidents, async (req) => {
        let IncidentsQuery = SELECT.from(req.query.SELECT.from).limit(req.query.SELECT.limit);
        if (req.query.SELECT.where) {
            IncidentsQuery.where(req.query.SELECT.where);
        };
        if (req.query.SELECT.orderBy) {
            IncidentsQuery.orderBy(req.query.SELECT.orderBy);
        };

        let incident = await sapbackend.tx(req).send({
            query: IncidentsQuery,
            headers: {
                //Authorization: "Basic c2FwdWk1OnNhcHVpNQ==",
                Authorization: `${process.env.SAP_GATEWAY_AUTH}`, 
            },
        });

        let incidents = [];
        if (Array.isArray(incident)) {
            incidents = incident;
        } else {
            incidents[0] = incident;
        }
        return incidents;
    });
};