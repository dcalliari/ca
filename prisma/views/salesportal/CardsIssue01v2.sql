SELECT
  DISTINCT 1 AS numerolote,
  date(so."paymentDate") AS datapagamento,
  so.id AS numeropedido,
  sodl.name AS entrega,
  sc.id AS id_empresa,
  sc.document AS documentompresa,
  sc."addrStreet",
  sc."addrNbr",
  sc."addrComplement",
  sc."addrDistrict",
  sc."addrZipCode",
  sc.name AS empresa,
  uu.id AS id_funcionario,
  crodu."usrUserName" AS func_name,
  crodu."usrUserBirthdate" AS data_nascimento,
  crodu."usrUserDocumentValue" AS cpf,
  mm."formatedLogical",
  uu."createdAt" AS datacriacao_user,
  ud."createdAt" AS datacriacao_documento,
  COALESCE(
    ((sodl.tax) :: numeric / (100) :: numeric),
    (0) :: numeric
  ) AS taxa,
  so."externalId" AS commerce,
  sc."contactName" AS contatoempresa,
  su.name AS contatotclient
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
      JOIN salesportal."SalCompanyCredential" scc ON ((scc."salCompanyId" = sc.id))
    )
    JOIN SECURITY."SecUser" su ON ((su.id = scc."secUserId"))
  )
WHERE
  (
    so."isPaid"
    AND so."isReleased"
    AND (uu."createdAt" > date(so."paymentDate"))
    AND (ud."usrDocumentTypeId" = 2147483646)
    AND mm."isActive"
    AND (mm."medMediaTypeId" = 4)
    AND (mm."reissueSequence" = 1)
    AND (mm."formatedLogical" = (se."cardNumber") :: text)
    AND (
      1 = (
        SELECT
          count(1) AS count
        FROM
          media."MedMedia" mmc
        WHERE
          (
            TRUE
            AND (
              mmc."usrUserId" IN (
                SELECT
                  mma."usrUserId"
                FROM
                  media."MedMedia" mma
                WHERE
                  (mma."formatedLogical" = mm."formatedLogical")
              )
            )
            AND (mm."medMediaTypeId" = 4)
          )
      )
    )
    AND (
      EXISTS (
        SELECT
          1
        FROM
          bureau."MediaToProcess" mp
        WHERE
          (mp.formatedlogical = mm."formatedLogical")
      )
    )
  )
ORDER BY
  (date(so."paymentDate")),
  sodl.name,
  sc.name,
  crodu."usrUserName";