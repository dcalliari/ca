SELECT
  row_number() OVER () AS id,
  cpm."paymentMethod",
  cm.name AS "comMerchant",
  cts."comMerchantId",
  cts.date,
  sum(cts."transactionAmount") AS amount,
  sum(cts."receivedAmount") AS received,
  sum(cts."transactionCount") AS count
FROM
  (
    (
      commerce."ComTransactionSummary" cts
      LEFT JOIN commerce."ComPaymentMode" cpm ON ((cts."comPaymentModeId" = cpm.id))
    )
    LEFT JOIN commerce."ComMerchant" cm ON ((cm.id = cts."comMerchantId"))
  )
GROUP BY
  cpm."paymentMethod",
  cts.date,
  cts."comMerchantId",
  cm.name;