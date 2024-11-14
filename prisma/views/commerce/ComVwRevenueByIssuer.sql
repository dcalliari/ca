SELECT
  row_number() OVER () AS id,
  cts."comMerchantId",
  cm.name AS "comMerchant",
  cts."toIssuerCode",
  ti.name AS "toIssuer",
  cts.date,
  sum(cts."transactionAmount") AS amount,
  sum(cts."receivedAmount") AS received,
  sum(cts."transactionCount") AS count
FROM
  (
    (
      commerce."ComTransactionSummary" cts
      JOIN commerce."ComMerchant" cm ON ((cm.id = cts."comMerchantId"))
    )
    LEFT JOIN transport."ToIssuer" ti ON ((cts."toIssuerCode" = ti.code))
  )
GROUP BY
  cts.date,
  cts."comMerchantId",
  cm.name,
  cts."toIssuerCode",
  ti.name;