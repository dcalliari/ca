SELECT
  op.id AS "usrOperatorId",
  us.id AS "usrUserId",
  us.name,
  us."socialName"
FROM
  (
    "user"."UsrOperator" op
    LEFT JOIN "user"."UsrUser" us ON ((op."usrUserId" = us.id))
  );