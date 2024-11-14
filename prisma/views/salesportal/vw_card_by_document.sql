SELECT
  mm."usrUserId",
  ud.value,
  mm."formatedLogical",
  uu.name,
  mm.csn
FROM
  (
    (
      media."MedMedia" mm
      JOIN "user"."UsrUser" uu ON ((uu.id = mm."usrUserId"))
    )
    JOIN "user"."UsrDocument" ud ON ((ud."usrUserId" = uu.id))
  )
WHERE
  (
    TRUE
    AND (ud."usrDocumentTypeId" = 2147483646)
    AND mm."isActive"
    AND (mm."medMediaTypeId" = 4)
  );