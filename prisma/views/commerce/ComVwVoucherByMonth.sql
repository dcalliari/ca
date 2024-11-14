WITH t AS (
  SELECT
    (
      "ComPaymentVoucher".date + (
        COALESCE(
          NULLIF(
            current_setting('app.time_zone' :: text, TRUE),
            '' :: text
          ),
          '3 hour' :: text
        )
      ) :: INTERVAL
    ) AS date
  FROM
    commerce."ComPaymentVoucher"
)
SELECT
  row_number() OVER () AS id,
  count(1) AS total,
  (date_trunc('month' :: text, t.date)) :: date AS MONTH
FROM
  t
WHERE
  (t.date >= t.date)
GROUP BY
  (date_trunc('month' :: text, t.date))
ORDER BY
  (date_trunc('month' :: text, t.date));