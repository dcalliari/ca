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
      ci.entrega AS localentrega,
      'VALE TRANSPORTE' :: text AS tipo_usuario,
      (
        regexp_matches(ci."formatedLogical", '\d{8}' :: text)
      ) [1] AS cartao,
      '2' :: text AS tipo,
      (ci.datapagamento + 7) AS data_entrega,
      1 AS lote,
      (ci."DetailId") :: text AS pedido,
      (ci."DetailId") :: text AS nosso_numero,
      tp.prv_contactdepartment AS contato_empresa,
      ci.datacriacao_user AS usuario_id,
      ci.func_name AS nome_usuario,
      ci.cpf AS cpf_usuario,
      ci.datapagamento AS data_pagamento,
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
              salesportal."CardsIssue01" ci
              JOIN "user"."UsrOrganization" uo ON (
                (
                  (ci.organizationid) :: numeric = (uo."externalId") :: numeric
                )
              )
            )
            JOIN "user"."UsrOrganizationAddress" uoa ON ((uo.id = uoa."usrOrganizationId"))
          )
          JOIN salesportal.tw_providers tp ON (
            (
              (tp.prv_id) :: numeric = (uo."externalId") :: numeric
            )
          )
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