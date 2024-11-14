SELECT
  mm.id AS "medMediaId",
  mm."usrUserId",
  mm."isActive" AS "isMediaActive",
  mmp.id AS "medMediaProductId",
  mmp."medTransitProductId",
  mmp."endValidity",
  mmp."isActive" AS "isMediaProductActive",
  mmp.usn
FROM
  (
    media."MedMedia" mm
    JOIN media."MedMediaProduct" mmp ON ((mmp."medMediaId" = mm.id))
  );