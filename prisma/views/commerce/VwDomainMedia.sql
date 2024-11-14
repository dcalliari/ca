SELECT
  mm.id AS "medMediaId",
  mm.csn AS "medMediaCsn",
  mm."formatedLogical" AS "medMediaFormatedLogical",
  mm."isProcessed" AS "medMediaIsProcessed",
  mm."usrUserId" AS "medMediaUsrUserId"
FROM
  media."MedMedia" mm;