SELECT
  segunda_via_vt.localentrega,
  segunda_via_vt.tipo_usuario,
  segunda_via_vt.cartao,
  segunda_via_vt.tipo,
  segunda_via_vt.data_entrega,
  segunda_via_vt.lote,
  segunda_via_vt.pedido,
  segunda_via_vt.nosso_numero,
  segunda_via_vt.contato_empresa,
  segunda_via_vt.usuario_id,
  segunda_via_vt.nome_usuario,
  segunda_via_vt.cpf_usuario,
  segunda_via_vt.data_pagamento,
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
      '1234567' :: text AS cartao,
      '2' :: text AS tipo,
      (sl.dtpagamento + 7) AS data_entrega,
      '1' :: text AS lote,
      (sl.pedido) :: text AS pedido,
      (sl.nosso_numero) :: text AS nosso_numero,
      tp.prv_contactdepartment AS contato_empresa,
      sl.usr_id AS usuario_id,
      sl.usr_name AS nome_usuario,
      sl.cpf AS cpf_usuario,
      sl.dtpagamento AS data_pagamento,
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
              JOIN "user"."UsrOrganization" uo ON ((sl.prv_id = (uo."externalId") :: numeric))
            )
            JOIN "user"."UsrOrganizationAddress" uoa ON ((uo.id = uoa."usrOrganizationId"))
          )
          JOIN salesportal.tw_providers tp ON (((tp.prv_id) :: numeric = sl.prv_id))
        )
        LEFT JOIN "user"."UsrOrganizationPhone" uop ON (
          (
            (uo.id = uop."usrOrganizationId")
            AND (uop.id = uo."usrMainOrganizationPhoneId")
          )
        )
      )
    WHERE
      (uoa."isActive" = TRUE)
  ) segunda_via_vt
ORDER BY
  segunda_via_vt.localentrega,
  segunda_via_vt.empresa,
  segunda_via_vt.nome_usuario;