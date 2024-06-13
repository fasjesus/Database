-- Estrutura para vista `view_dw_empresa`
--
DROP TABLE IF EXISTS `view_dw_empresa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_dw_empresa` 
AS SELECT `empresa`.`clientes`.`CodCli` AS `CLI_codcli`, `empresa`.`clientes`.`Nome` AS `CLI_nome`, `empresa`.`clientes`.`Contato`
AS `CLI_contato`, `empresa`.`clientes`.`Cargo` AS `CLI_cargo`, `empresa`.`clientes`.`Endereco` 
AS `CLI_endereco`, `empresa`.`clientes`.`Cidade` AS `CLI_cidade`, `empresa`.`clientes`.`Regiao` 
AS `CLI_Regiao`, `empresa`.`clientes`.`Pais` AS `CLI_pais`, `empresa`.`clientes`.`Telefone` 
AS `CLI_telefone`, `empresa`.`clientes`.`Fax` AS `CLI_fax`, `empresa`.`pedidos`.`NumPed` 
AS `PED_numped`, `empresa`.`pedidos`.`CodCli` AS `PED_codcli`, `empresa`.`pedidos`.`CodFun` 
AS `PED_codfun`, `empresa`.`pedidos`.`DataPed` AS `PED_dataped`, `empresa`.`pedidos`.`DataEntrega` 
AS `PED_dataentrega`, `empresa`.`pedidos`.`Frete` AS `PED_frete`, `empresa`.`funcionarios`.`CodFun` 
AS `FUNC_codfun`, `empresa`.`funcionarios`.`Nome` AS `FUNC_nome`, `empresa`.`funcionarios`.`Cargo` 
AS `FUNC_cargo`, `empresa`.`funcionarios`.`DataNasc` AS `FUNC_datanasc`, `empresa`.`funcionarios`.`Endereco` 
AS `FUNC_endereco`, `empresa`.`funcionarios`.`Cidade` AS `FUNC_cidade`, `empresa`.`funcionarios`.`CEP` 
AS `FUNC_cep`, `empresa`.`funcionarios`.`Pais` AS `FUNC_pais`, `empresa`.`funcionarios`.`Fone` 
AS `FUNC_fone`, `empresa`.`funcionarios`.`Salario` AS `FUNC_salario`, `empresa`.`detalhesped`.`NumPed` 
AS `DETAPED_numped`, `empresa`.`detalhesped`.`CodProd` AS `DETAPED_codprod`, `empresa`.`detalhesped`.`Preco` 
AS `DETAPED_preco`, `empresa`.`detalhesped`.`Qtde` AS `DETAPED_qtde`, `empresa`.`detalhesped`.`Desconto` 
AS `DETAPED_desconto`, `empresa`.`produtos`.`CodProd` AS `PROD_codprod`, `empresa`.`produtos`.`Descr` 
AS `PROD_descr`, `empresa`.`produtos`.`CodFor` AS `PROD_codfor`, `empresa`.`produtos`.`CodCategoria` 
AS `PROD_codcategoria`, `empresa`.`produtos`.`Preco` AS `PROD_preco`, `empresa`.`produtos`.`Unidades` 
AS `PROD_unidades`, `empresa`.`produtos`.`Descontinuado` AS `PROD_descontinuado`, `empresa`.`fornecedores`.`CodFor` 
AS `FORN_codfor`, `empresa`.`fornecedores`.`Empresa` AS `FORN_empresa`, `empresa`.`fornecedores`.`Contato` 
AS `FORN_contato`, `empresa`.`fornecedores`.`Cargo` AS `FORN_cargo`, `empresa`.`fornecedores`.`Endereco` 
AS `FORN_endereco`, `empresa`.`fornecedores`.`Cidade` AS `FORN_cidade`, `empresa`.`fornecedores`.`CEP` 
AS `FORN_cep`, `empresa`.`fornecedores`.`Pais` AS `FORN_pais`, `empresa`.`categorias`.`CodCategoria` 
AS `CATE_codcategoria`, `empresa`.`categorias`.`Descr` AS `CATE_descr` 
FROM ((((((`empresa`.`detalhesped` join `empresa`.`produtos` on(`empresa`.`detalhesped`.`CodProd` = `empresa`.`produtos`.`CodProd`)) 
join `empresa`.`pedidos` on(`empresa`.`detalhesped`.`NumPed` = `empresa`.`pedidos`.`NumPed`)) 
join `empresa`.`clientes` on(`empresa`.`pedidos`.`CodCli` = `empresa`.`clientes`.`CodCli`)) 
join `empresa`.`funcionarios` on(`empresa`.`pedidos`.`CodFun` = `empresa`.`funcionarios`.`CodFun`)) 
join `empresa`.`fornecedores` on(`empresa`.`produtos`.`CodFor` = `empresa`.`fornecedores`.`CodFor`)) 
join `empresa`.`categorias` on(`empresa`.`produtos`.`CodCategoria` = `empresa`.`categorias`.`CodCategoria`))  ;


