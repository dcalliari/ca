SELECT
  ct.id AS "comTransactionId",
  ct.guid AS "comTransactionGuid",
  cm.id AS "comMerchantId",
  cm.name AS "comMerchant",
  (ct.date) :: date AS date,
  ct.date AS datetime,
  COALESCE(tt.code, cs."toTerminalCode") AS "toTerminalCode",
  COALESCE(tt."toTerminalGroupId", cs."toTerminalGroupId") AS "toTerminalGroupId",
  COALESCE(
    tt."toTransportOperatorId",
    cs."toTransportOperatorId"
  ) AS "toTransportOperatorId",
  tt.description AS "toTerminal",
  ct."operationType",
  ct.type,
  ct."subType",
  ct."comissionType",
  ct."comissionTypeValue",
  CASE
    WHEN (
      ct.type = ANY (
        ARRAY ['qrcode'::commerce."MediaType", 'abt'::commerce."MediaType"]
      )
    ) THEN qp.description
    WHEN (ct.type = 'media' :: commerce."MediaType") THEN mtp.description
    WHEN (ct.type = 'externalMedia' :: commerce."MediaType") THEN metp.description
    ELSE '' :: text
  END AS "subTypeDesc",
  ct."mediaId",
  ct."externalMediaId",
  CASE
    WHEN (ct.type = 'media' :: commerce."MediaType") THEN COALESCE(mm."formatedLogical", ct."mediaId")
    WHEN (ct.type = 'externalMedia' :: commerce."MediaType") THEN ct."externalMediaId"
    ELSE ct."mediaId"
  END AS media,
  ct."comPaymentModeId",
  cpm.description AS "comPaymentMode",
  ct.value,
  ct."receivedValue",
  CASE
    WHEN (ct."comissionType" IS NULL) THEN 0
    ELSE 0
  END AS comission,
  ct."isProcessed",
  ct."isPaymentComplete",
  ct."isActive"
FROM
  (
    (
      (
        (
          (
            (
              (
                (
                  commerce."ComTransaction" ct
                  JOIN commerce."ComService" cs ON ((cs.guid = ct."comServiceGuid"))
                )
                LEFT JOIN commerce."ComMerchant" cm ON ((cm.id = cs."comMerchantId"))
              )
              LEFT JOIN transport."ToTerminal" tt ON (
                (
                  (tt.code = cs."toTerminalCode")
                  AND (
                    tt."toTransportOperatorId" = cs."toTransportOperatorId"
                  )
                )
              )
            )
            LEFT JOIN qrcode."QrProduct" qp ON (
              (
                (
                  ct.type = ANY (
                    ARRAY ['qrcode'::commerce."MediaType", 'abt'::commerce."MediaType"]
                  )
                )
                AND (qp.id = ct."subType")
              )
            )
          )
          LEFT JOIN media."MedTransitProduct" mtp ON (
            (
              (ct.type = 'media' :: commerce."MediaType")
              AND (ct."subType" = mtp.id)
            )
          )
        )
        LEFT JOIN media."MedExternalTransitProduct" metp ON (
          (
            (ct.type = 'externalMedia' :: commerce."MediaType")
            AND (metp.id = ct."subType")
          )
        )
      )
      LEFT JOIN media."MedMedia" mm ON (
        (
          (ct.type = 'media' :: commerce."MediaType")
          AND (ct."mediaId" IS NOT NULL)
          AND (
            mm.csn = (
              COALESCE(
                NULLIF(
                  regexp_replace(
                    split_part(ct."mediaId", ',' :: text, 1),
                    '[^0-9]+' :: text,
                    '' :: text,
                    'g' :: text
                  ),
                  '' :: text
                ),
                '-1' :: text
              )
            ) :: bigint
          )
        )
      )
    )
    LEFT JOIN commerce."ComPaymentMode" cpm ON ((cpm.id = ct."comPaymentModeId"))
  );