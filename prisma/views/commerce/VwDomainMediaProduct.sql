SELECT
  row_number() OVER () AS id,
  mm.id AS "medMediaId",
  mm.csn AS "medMediaCsn",
  mmp.id AS "medMediaProductId",
  mtp.id AS "medTransitProductId",
  mtp.description AS "medTransitProductDesc",
  mtp.code AS "medTransitProductCode",
  mtp."toIssuerCode",
  CASE
    WHEN (mmp."medQuotaId" IS NOT NULL) THEN (
      SELECT
        ARRAY [mpq.quotalimit, COALESCE(mpq.rechargedvalue, (0)::numeric)] AS "array"
      FROM
        media."calculateMedMediaProductRecharge"(mmp.id) mpq(quotalimit, rechargedvalue)
    )
    ELSE NULL :: numeric []
  END AS "quotaLimit",
  mm."formatedLogical" AS "medMediaFormatedLogical"
FROM
  (
    (
      media."MedTransitProduct" mtp
      JOIN media."MedMediaProduct" mmp ON ((mmp."medTransitProductId" = mtp.id))
    )
    JOIN media."MedMedia" mm ON ((mm.id = mmp."medMediaId"))
  );