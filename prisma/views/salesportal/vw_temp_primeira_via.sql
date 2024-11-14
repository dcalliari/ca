SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 5799)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
    AND (
      (se.name) :: text = 'JEFERSON OLIVEIRA BARROS' :: text
    )
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 14678)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 14624)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 14457)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
    AND (
      (se.name) :: text !~~ 'ANDRE CARLOS SILVA SOUZA' :: text
    )
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 2700)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
    AND (
      (se.name) :: text !~~ 'ANDRE CARLOS SILVA SOUZA' :: text
    )
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 6096)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 11610)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 15726)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
    AND (
      (se.name) :: text !~~ 'BIANCA FERREIRA DE OLIVEIRA' :: text
    )
  )
UNION
ALL
SELECT
  sc.document,
  se.document AS cpf,
  sc.name AS company,
  se.name,
  so."createdAt" AS datapedido,
  soi.value,
  se."cardNumber",
  so."paymentDate",
  so."externalId" AS commerce
FROM
  (
    (
      (
        salesportal."SalEmployee" se
        JOIN salesportal."SalOrderItem" soi ON ((se.id = soi."salEmployeeId"))
      )
      JOIN salesportal."SalOrder" so ON ((so.id = soi."salOrderId"))
    )
    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
  )
WHERE
  (
    (so.id = 1953)
    AND so."isPaid"
    AND so."isReleased"
    AND ((se."cardNumber") :: text = 'sem cartão' :: text)
  );