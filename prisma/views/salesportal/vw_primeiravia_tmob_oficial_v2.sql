SELECT
  DISTINCT date(so."paymentDate") AS datapagamento,
  sodl.name AS entrega,
  sc.name AS empresa,
  crodu."usrUserName" AS func_name,
  crodu."usrUserDocumentValue" AS cpf,
  mm."formatedLogical",
  uu."createdAt" AS datacriacao_user,
  ud."createdAt" AS datacriacao_documento,
  COALESCE(
    ((sodl.tax) :: numeric / (100) :: numeric),
    (0) :: numeric
  ) AS taxa,
  so."externalId" AS commerce
FROM
  (
    (
      (
        (
          (
            (
              (
                (
                  (
                    salesportal."SalOrder" so
                    JOIN salesportal."SalCompany" sc ON ((sc.id = so."salCompanyId"))
                  )
                  JOIN salesportal."SalOrderDeliveryLocation" sodl ON ((sodl.id = so."salOrderDeliveryLocationId"))
                )
                JOIN commerce."ComRechargeOrder" cro ON ((cro.id = so."externalId"))
              )
              JOIN commerce."ComRechargeOrderDetail" crod ON ((crod."comRechargeOrderId" = so."externalId"))
            )
            JOIN commerce."ComRechargeOrderDetailUser" crodu ON ((crodu."comRechargeOrderDetailId" = crod.id))
          )
          JOIN "user"."UsrDocument" ud ON ((ud.value = crodu."usrUserDocumentValue"))
        )
        JOIN salesportal."SalEmployee" se ON (
          (
            (se.document) :: text = crodu."usrUserDocumentValue"
          )
        )
      )
      JOIN "user"."UsrUser" uu ON ((ud."usrUserId" = uu.id))
    )
    JOIN media."MedMedia" mm ON ((mm."usrUserId" = uu.id))
  )
WHERE
  (
    so."isPaid"
    AND so."isReleased"
    AND (ud."usrDocumentTypeId" = 2147483646)
    AND mm."isActive"
    AND (mm."medMediaTypeId" = 4)
    AND (mm.csn IS NULL)
    AND (mm."reissueSequence" = 1)
    AND (
      crodu."usrUserName" ~~ 'VICTORIA CAROLINI RIBEIRO XIMENES%' :: text
    )
  )
ORDER BY
  (date(so."paymentDate")),
  sodl.name,
  sc.name,
  crodu."usrUserName";