WITH boleto_status AS (
  SELECT
    so.id AS "salOrderId",
    so."externalId",
    so.date,
    sc.name,
    so."totalValue",
    so.status,
    cro."paymentDate",
    cro."paymentType",
    cro.value,
    cpo."paymentStatus",
    cro.id,
    cpo."externalInfo2" AS linha_digitavel,
    b.nosso_numero,
    CASE
      WHEN (so.status <> 'new' :: salesportal."OrderStatus") THEN CASE
        WHEN (
          (b.nosso_numero IS NOT NULL)
          AND (
            so.status <> ALL (
              ARRAY ['paid'::salesportal."OrderStatus", 'released'::salesportal."OrderStatus"]
            )
          )
        ) THEN 'inconsistente' :: text
        WHEN (b.nosso_numero IS NOT NULL) THEN 'ok' :: text
        ELSE 'inexistente' :: text
      END
      ELSE '' :: text
    END AS status_boleto,
    so."isPaid",
    so."isReleased"
  FROM
    (
      (
        (
          (
            salesportal."SalOrder" so
            JOIN salesportal."SalCompany" sc ON ((so."salCompanyId" = sc.id))
          )
          JOIN commerce."ComRechargeOrder" cro ON ((cro.id = so."externalId"))
        )
        JOIN commerce."ComPaymentOrder" cpo ON ((cpo."comRechargeOrderId" = cro.id))
      )
      LEFT JOIN payment.bills b ON (
        (cpo."externalOrderId" = (b.transaction_id) :: text)
      )
    )
  WHERE
    (
      (so."isActive" IS TRUE)
      AND (
        so.status = ANY (
          ARRAY ['new'::salesportal."OrderStatus", 'paid'::salesportal."OrderStatus", 'released'::salesportal."OrderStatus", 'canceled'::salesportal."OrderStatus"]
        )
      )
      AND (so."totalValue" > 0)
      AND (
        cpo."paymentType" = 'billet' :: commerce."PaymentType"
      )
      AND (
        cro."paymentType" = 'billet' :: commerce."PaymentType"
      )
    )
)
SELECT
  boleto_status."salOrderId",
  boleto_status."externalId",
  boleto_status.date,
  boleto_status.name,
  boleto_status."totalValue",
  boleto_status.status,
  boleto_status."paymentDate",
  boleto_status."paymentType",
  boleto_status.value,
  boleto_status."paymentStatus",
  boleto_status.id,
  boleto_status.linha_digitavel,
  boleto_status.nosso_numero,
  boleto_status.status_boleto,
  boleto_status."isPaid",
  boleto_status."isReleased"
FROM
  boleto_status
ORDER BY
  boleto_status."salOrderId" DESC;