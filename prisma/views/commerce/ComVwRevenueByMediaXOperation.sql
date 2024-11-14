SELECT
  row_number() OVER () AS id,
  cts.type AS "mediaType",
  cts."operationType",
  cm.name AS "comMerchant",
  cts."comMerchantId",
  cts.date,
  sum(cts."transactionAmount") AS amount,
  sum(cts."receivedAmount") AS received,
  sum(cts."transactionCount") AS count
FROM
  (
    commerce."ComTransactionSummary" cts
    JOIN commerce."ComMerchant" cm ON ((cm.id = cts."comMerchantId"))
  )
GROUP BY
  cts.type,
  cts."operationType",
  cm.name,
  cts."comMerchantId",
  cts.date;