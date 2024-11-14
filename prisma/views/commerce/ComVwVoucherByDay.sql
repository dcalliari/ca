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
  (t.date) :: date AS DAY
FROM
  t
WHERE
  (
    t.date >= (
      ((NOW()) :: date + '03:00:00' :: INTERVAL) - '30 days' :: INTERVAL
    )
  )
GROUP BY
  ((t.date) :: date)
ORDER BY
  ((t.date) :: date);