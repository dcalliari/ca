SELECT
  t.code AS "toTerminalCode",
  t."toTransportOperatorId",
  t."toTerminalGroupId",
  t.description,
  top.name AS "toTransportOperatorDesc",
  ttg.id AS "stationId",
  ttg.description AS station,
  ttg2.id AS "lineId",
  ttg2.description AS line,
  ttg3.id AS "companyId",
  ttg3.description AS company
FROM
  (
    (
      (
        (
          transport."ToTerminal" t
          LEFT JOIN transport."ToTransportOperator" top ON ((top.id = t."toTransportOperatorId"))
        )
        LEFT JOIN transport."ToTerminalGroup" ttg ON ((t."toTerminalGroupId" = ttg.id))
      )
      LEFT JOIN transport."ToTerminalGroup" ttg2 ON ((ttg."parentId" = ttg2.id))
    )
    LEFT JOIN transport."ToTerminalGroup" ttg3 ON ((ttg2."parentId" = ttg3.id))
  );