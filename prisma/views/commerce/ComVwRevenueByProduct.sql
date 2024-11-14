WITH products AS (
  SELECT
    'qrcode' :: commerce."MediaType" AS TYPE,
    "QrProduct".id,
    "QrProduct".description,
    0 AS "medTransitProductCollectorGroupId",
    0 AS "collectorGroupId",
    '' :: text AS "collectorGroup"
  FROM
    qrcode."QrProduct"
  UNION
  SELECT
    'externalMedia' :: commerce."MediaType" AS TYPE,
    "MedExternalTransitProduct".id,
    "MedExternalTransitProduct".description,
    0 AS "medTransitProductCollectorGroupId",
    0 AS "collectorGroupId",
    '' :: text AS "collectorGroup"
  FROM
    media."MedExternalTransitProduct"
  UNION
  SELECT
    'media' :: commerce."MediaType" AS TYPE,
    mtp.id,
    mtp.description,
    mtp."medTransitProductCollectorGroupId",
    mtpcg.id AS "collectorGroupId",
    mtpcg.description AS "collectorGroup"
  FROM
    (
      media."MedTransitProduct" mtp
      LEFT JOIN media."MedTransitProductCollectorGroup" mtpcg ON (
        (
          mtpcg.id = mtp."medTransitProductCollectorGroupId"
        )
      )
    )
)
SELECT
  row_number() OVER () AS id,
  cts.type,
  cts."subType",
  (
    SELECT
      products.description
    FROM
      products
    WHERE
      (
        (products.id = cts."subType")
        AND (
          products.type = CASE
            WHEN (
              cts.type = ANY (
                ARRAY ['qrcode'::commerce."MediaType", 'abt'::commerce."MediaType"]
              )
            ) THEN 'qrcode' :: commerce."MediaType"
            ELSE cts.type
          END
        )
      )
  ) AS product,
  (
    SELECT
      products."collectorGroupId"
    FROM
      products
    WHERE
      (
        (products.type = cts.type)
        AND (products.id = cts."subType")
      )
  ) AS "collectorGroupId",
  (
    SELECT
      products."collectorGroup"
    FROM
      products
    WHERE
      (
        (products.type = cts.type)
        AND (products.id = cts."subType")
      )
  ) AS "collectorGroup",
  cm.name AS "comMerchant",
  cts."comMerchantId",
  cts.date,
  sum(cts."transactionAmount") AS amount,
  sum(cts."receivedAmount") AS received,
  sum(cts."transactionCount") AS count
FROM
  (
    (
      (
        commerce."ComTransactionSummary" cts
        LEFT JOIN qrcode."QrProduct" qp ON ((qp.id = cts."subType"))
      )
      LEFT JOIN media."MedExternalTransitProduct" metp ON ((metp.id = cts."subType"))
    )
    JOIN commerce."ComMerchant" cm ON ((cm.id = cts."comMerchantId"))
  )
GROUP BY
  cts.type,
  cts."subType",
  cm.name,
  cts."comMerchantId",
  cts.date;