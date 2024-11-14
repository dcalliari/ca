SELECT
  uo.id AS "usrOrganizationId",
  uo.name,
  uo."shortName",
  uo."mailAddress",
  uo."paymentSecret",
  uod.value AS "mainDocument",
  uop."countryCode" AS "mainPhoneCountryCode",
  uop.number AS "mainPhoneNumber",
  uoa.street AS "mainAddressStreet",
  uoa.number AS "mainAddressNumber",
  uoa.complement AS "mainAddressComplement",
  uoa."zipCode" AS "mainAddressZipCode",
  uoa.city AS "mainAddressCity",
  uoa.district AS "mainAddressDistrict",
  uoa.state AS "mainAddressState",
  uoa.country AS "mainAddressCountry",
  uo."isActive"
FROM
  (
    (
      (
        "user"."UsrOrganization" uo
        LEFT JOIN "user"."UsrOrganizationPhone" uop ON ((uop.id = uo."usrMainOrganizationPhoneId"))
      )
      LEFT JOIN "user"."UsrOrganizationDocument" uod ON ((uod.id = uo."usrMainOrganizationDocumentId"))
    )
    LEFT JOIN "user"."UsrOrganizationAddress" uoa ON ((uoa.id = uo."usrMainOrganizationAddressId"))
  );