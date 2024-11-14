SELECT
  uu.id AS "usrUserId",
  udt.id AS "usrDocumentTypeId",
  ud.id AS "usrDocumentId",
  uu.birthdate,
  udt.description AS "usrDocumentTypeDescription",
  ud.value AS "usrDocumentValue",
  mm."formatedLogical",
  mm."isActive" AS "mediaIsActive",
  mm."isHotlisted" AS "mediaIsHotlisted",
  mm."isProcessed" AS "mediaIsProcessed",
  mm.id AS "mediaId"
FROM
  (
    (
      (
        "user"."UsrUser" uu
        LEFT JOIN "user"."UsrDocument" ud ON ((ud."usrUserId" = uu.id))
      )
      LEFT JOIN "user"."UsrDocumentType" udt ON ((udt.id = ud."usrDocumentTypeId"))
    )
    LEFT JOIN media."MedMedia" mm ON ((mm."usrUserId" = uu.id))
  );