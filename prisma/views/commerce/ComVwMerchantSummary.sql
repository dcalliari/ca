SELECT
  cts.date,
  COALESCE(cts."toIssuerCode", 0) AS "toIssuerCode",
  ti.name AS "toIssuerName",
  cts."comMerchantId",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'sale' :: commerce."OperationType"
        )
        AND (cts.type = 'qrcode' :: commerce."MediaType")
      ) THEN cts."receivedAmount"
      ELSE 0
    END
  ) AS "receivedQrCodeSale",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'sale' :: commerce."OperationType"
        )
        AND (cts.type = 'qrcode' :: commerce."MediaType")
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS "transactionQrCodeSale",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'salecancel' :: commerce."OperationType"
        )
        AND (cts.type = 'qrcode' :: commerce."MediaType")
      ) THEN cts."receivedAmount"
      ELSE 0
    END
  ) AS "receivedQrCodeSaleCancel",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'salecancel' :: commerce."OperationType"
        )
        AND (cts.type = 'qrcode' :: commerce."MediaType")
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS "transactionQrCodeSaleCancel",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'salecancel' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS "transactionMediaSaleCancel",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'salecancel' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."receivedAmount"
      ELSE 0
    END
  ) AS "receivedMediaSaleCancel",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'sale' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS "transactionMediaSale",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'sale' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."receivedAmount"
      ELSE 0
    END
  ) AS "receivedMediaSale",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'rechargePurchase' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS "transactionMediaRechargePurchase",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'rechargePurchase' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."receivedAmount"
      ELSE 0
    END
  ) AS "receivedMediaRechargePurchase",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'topup' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS "transactionMediaTopup",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'topup' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."receivedAmount"
      ELSE 0
    END
  ) AS "receivedMediaTopup",
  sum(
    CASE
      WHEN (
        cpm."paymentMethod" = 'credit' :: commerce."PaymentMethod"
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS credit,
  sum(
    CASE
      WHEN (
        cpm."paymentMethod" = 'debit' :: commerce."PaymentMethod"
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS debit,
  sum(
    CASE
      WHEN (
        cpm."paymentMethod" = 'cash' :: commerce."PaymentMethod"
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS cash,
  sum(
    CASE
      WHEN (
        cpm."paymentMethod" = 'voucher' :: commerce."PaymentMethod"
      ) THEN cts."transactionAmount"
      ELSE 0
    END
  ) AS voucher,
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'sale' :: commerce."OperationType"
        )
        AND (cts.type = 'qrcode' :: commerce."MediaType")
      ) THEN cts."transactionCount"
      ELSE 0
    END
  ) AS "countQrCodeSale",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'salecancel' :: commerce."OperationType"
        )
        AND (cts.type = 'qrcode' :: commerce."MediaType")
      ) THEN cts."transactionCount"
      ELSE 0
    END
  ) AS "countQrCodeSaleCancel",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'salecancel' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionCount"
      ELSE 0
    END
  ) AS "countMediaSaleCancel",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'sale' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionCount"
      ELSE 0
    END
  ) AS "countMediaSale",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'rechargePurchase' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionCount"
      ELSE 0
    END
  ) AS "countMediaRechargePurchase",
  sum(
    CASE
      WHEN (
        (
          cts."operationType" = 'topup' :: commerce."OperationType"
        )
        AND (
          (cts.type = 'media' :: commerce."MediaType")
          OR (cts.type = 'externalMedia' :: commerce."MediaType")
        )
      ) THEN cts."transactionCount"
      ELSE 0
    END
  ) AS "countMediaTopup",
  COALESCE(sum(cts."errorCount"), (0) :: bigint) AS "errorCount"
FROM
  (
    (
      commerce."ComTransactionSummary" cts
      LEFT JOIN commerce."ComPaymentMode" cpm ON ((cpm.id = cts."comPaymentModeId"))
    )
    LEFT JOIN transport."ToIssuer" ti ON ((ti.code = cts."toIssuerCode"))
  )
GROUP BY
  cts.date,
  cts."toIssuerCode",
  ti.name,
  cts."comMerchantId";