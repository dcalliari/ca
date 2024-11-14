SELECT
  row_number() OVER () AS id,
  count(1) AS total,
  pv."toTerminalCode",
  pv."toTransportOperatorId",
  pv."voucherType"
FROM
  commerce."ComPaymentVoucher" pv
WHERE
  (
    (
      pv."createdAt" + (
        COALESCE(
          NULLIF(
            current_setting('app.time_zone' :: text, TRUE),
            '' :: text
          ),
          '3 hour' :: text
        )
      ) :: INTERVAL
    ) >= (NOW() - '30 days' :: INTERVAL)
  )
GROUP BY
  pv."toTerminalCode",
  pv."toTransportOperatorId",
  pv."voucherType";