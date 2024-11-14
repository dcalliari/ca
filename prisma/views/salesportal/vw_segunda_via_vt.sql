SELECT
  DISTINCT segunda_via_vt.localentrega,
  segunda_via_vt.tipo_usuario,
  segunda_via_vt.cartao,
  segunda_via_vt.tipo,
  segunda_via_vt.data_entrega,
  segunda_via_vt.lote,
  segunda_via_vt.data_lote,
  segunda_via_vt.pedido,
  segunda_via_vt.nosso_numero,
  segunda_via_vt.contato_empresa,
  segunda_via_vt.usuario_id,
  segunda_via_vt.nome_usuario,
  segunda_via_vt.data_nascimento,
  segunda_via_vt.cpf_usuario,
  segunda_via_vt.data_pagamento,
  segunda_via_vt.empresa_documento,
  segunda_via_vt.empresa_id,
  segunda_via_vt.empresa,
  segunda_via_vt.empresa_endereco,
  segunda_via_vt.empresa_num_endereco,
  segunda_via_vt.empresa_complemento,
  segunda_via_vt.empresa_cep,
  segunda_via_vt.empresa_cidade,
  segunda_via_vt.empresa_bairro,
  COALESCE(
    segunda_via_vt.empresa_telefone,
    'não informado' :: text
  ) AS empresa_telefone
FROM
  (
    SELECT
      sl.localentrega,
      'VALE TRANSPORTE' :: text AS tipo_usuario,
      "substring"((sl.cartao_novo) :: text, '[0-9]{8}-[0-9]' :: text) AS cartao,
      '2' :: text AS tipo,
      (NOW() + '7 days' :: INTERVAL) AS data_entrega,
      1 AS lote,
      NOW() AS data_lote,
      (sl.pedido) :: text AS pedido,
      (sl.nosso_numero) :: text AS nosso_numero,
      tp.prv_contactdepartment AS contato_empresa,
      sl.usr_id AS usuario_id,
      sl.usr_name AS nome_usuario,
      sl.dtnascimento AS data_nascimento,
      sl.cpf AS cpf_usuario,
      sl.dtpagamento AS data_pagamento,
      tp.prvdoc_number AS empresa_documento,
      uo.id AS empresa_id,
      uo.name AS empresa,
      uoa.street AS empresa_endereco,
      uoa.number AS empresa_num_endereco,
      uoa.complement AS empresa_complemento,
      uoa."zipCode" AS empresa_cep,
      uoa.city AS empresa_cidade,
      uoa.district AS empresa_bairro,
      uop.number AS empresa_telefone
    FROM
      (
        (
          (
            (
              migration.segundavia_vt_legado sl
              LEFT JOIN "user"."UsrOrganization" uo ON ((sl.prv_id = (uo."externalId") :: numeric))
            )
            LEFT JOIN (
              SELECT
                DISTINCT ON (uoa_1."usrOrganizationId") uoa_1.id,
                uoa_1.type,
                uoa_1.street,
                uoa_1.number,
                uoa_1.complement,
                uoa_1."zipCode",
                uoa_1.location,
                uoa_1."usrOrganizationId",
                uoa_1."isActive",
                uoa_1."blameUser",
                uoa_1."createdAt",
                uoa_1."updatedAt",
                uoa_1."isMain",
                uoa_1.city,
                uoa_1.district,
                uoa_1.country,
                uoa_1.state
              FROM
                "user"."UsrOrganizationAddress" uoa_1
              WHERE
                (uoa_1."isActive" = TRUE)
              ORDER BY
                uoa_1."usrOrganizationId",
                uoa_1.id DESC
            ) uoa ON ((uo.id = uoa."usrOrganizationId"))
          )
          LEFT JOIN salesportal.tw_providers tp ON (((tp.prv_id) :: numeric = sl.prv_id))
        )
        LEFT JOIN "user"."UsrOrganizationPhone" uop ON (
          (
            (uo.id = uop."usrOrganizationId")
            AND (uop.id = uo."usrMainOrganizationPhoneId")
          )
        )
      )
  ) segunda_via_vt
ORDER BY
  segunda_via_vt.localentrega,
  segunda_via_vt.empresa,
  segunda_via_vt.nome_usuario;