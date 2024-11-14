SELECT
  'qrcode' :: text AS TYPE,
  qrp.id AS "subType",
  qrp.description,
  0 AS code,
  qrp."toIssuerCode"
FROM
  qrcode."QrProduct" qrp
WHERE
  (qrp."isActive" = TRUE)
UNION
SELECT
  'media' :: text AS TYPE,
  mtp.id AS "subType",
  mtp.description,
  mtp.code,
  mtp."toIssuerCode"
FROM
  media."MedTransitProduct" mtp
WHERE
  (mtp."isActive" = TRUE)
UNION
SELECT
  'externalMedia' :: text AS TYPE,
  metp.id AS "subType",
  metp.description,
  metp.code,
  metp."toIssuerCode"
FROM
  media."MedExternalTransitProduct" metp;