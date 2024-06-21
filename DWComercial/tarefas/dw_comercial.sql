-- Estrutura da tabela `dim_clientes` --

CREATE TABLE `dim_clientes` (
  `Id_DimClient` int(11) NOT NULL,
  `CodCli` char(5) DEFAULT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Contato` varchar(40) DEFAULT NULL,
  `Endereco` varchar(100) DEFAULT NULL,
  `Cidade` varchar(20) DEFAULT NULL,
  `Regiao` varchar(20) DEFAULT NULL,
  `Pais` varchar(20) DEFAULT NULL,
  `Telefone` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Estrutura da tabela `dim_datas`--

CREATE TABLE `dim_datas` (
  `id_data` int(11) NOT NULL,
  `dataped` date DEFAULT NULL,
  `dataentr` date DEFAULT NULL,
  `trimestre` char(4) DEFAULT NULL,
  `semana` char(10) DEFAULT NULL,
  `dia_semana` char(10) DEFAULT NULL,
  `mes` char(10) DEFAULT NULL,
  `dia_mes` char(4) DEFAULT NULL,
  `ano` char(4) DEFAULT NULL,
  `dia_ano` char(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Estrutura da tabela `dim_fornecedores --

CREATE TABLE `dim_fornecedores` (
  `Id_DimFornec` int(11) NOT NULL,
  `CodFor` int(11) DEFAULT NULL,
  `Empresa` varchar(100) DEFAULT NULL,
  `Contato` varchar(100) DEFAULT NULL,
  `Cargo` varchar(40) DEFAULT NULL,
  `Endereco` varchar(100) DEFAULT NULL,
  `Cidade` varchar(20) DEFAULT NULL,
  `Pais` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Estrutura da tabela `dim_pedidos` --

CREATE TABLE `dim_pedidos` (
  `Id_DimPedi` int(11) NOT NULL,
  `NumPed` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Estrutura da tabela `dim_produtos`--

CREATE TABLE `dim_produtos` (
  `Id_DimProdutos` int(11) NOT NULL,
  `Cod_Prod` int(11) DEFAULT NULL,
  `Descri` varchar(100) DEFAULT NULL,
  `Unidades` smallint(6) DEFAULT NULL,
  `Descontinuado` bit(1) DEFAULT NULL,
  `Desconto` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Estrutura da tabela `fat_empresa`--

CREATE TABLE `fat_empresa` (
  `Id_Fat` int(11) NOT NULL,
  `IdDimClient` int(11) DEFAULT NULL,
  `IdDimFornec` int(11) DEFAULT NULL,
  `IdDimFunc` int(11) DEFAULT NULL,
  `IdDimPedi` int(11) DEFAULT NULL,
  `IdDimProdut` int(11) DEFAULT NULL,
  `IdDimData` int(11) DEFAULT NULL,
  `PrecoProd` float DEFAULT NULL,
  `TotalPrecoProd` float DEFAULT NULL,
  `FretePedid` float DEFAULT NULL,
  `TotalFrete` float DEFAULT NULL,
  `QuantidPed` int(11) DEFAULT NULL,
  `PrecoPedid` float DEFAULT NULL,
  `TotalPrecoPedid` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Estrutura stand-in para vista `view_dw_empresa`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `view_dw_empresa` (
`CLI_codcli` char(5)
,`CLI_nome` varchar(40)
,`CLI_contato` varchar(30)
,`CLI_cargo` varchar(30)
,`CLI_endereco` varchar(60)
,`CLI_cidade` varchar(15)
,`CLI_Regiao` varchar(15)
,`CLI_pais` varchar(15)
,`CLI_telefone` varchar(24)
,`CLI_fax` varchar(24)
,`PED_numped` int(11)
,`PED_codcli` char(5)
,`PED_codfun` int(11)
,`PED_dataped` date
,`PED_dataentrega` date
,`PED_frete` float
,`FUNC_codfun` int(11)
,`FUNC_nome` varchar(10)
,`FUNC_cargo` varchar(30)
,`FUNC_datanasc` date
,`FUNC_endereco` varchar(60)
,`FUNC_cidade` varchar(15)
,`FUNC_cep` varchar(10)
,`FUNC_pais` varchar(15)
,`FUNC_fone` varchar(24)
,`FUNC_salario` float
,`DETAPED_numped` int(11)
,`DETAPED_codprod` int(11)
,`DETAPED_preco` float
,`DETAPED_qtde` smallint(6)
,`DETAPED_desconto` float
,`PROD_codprod` int(11)
,`PROD_descr` varchar(40)
,`PROD_codfor` int(11)
,`PROD_codcategoria` int(11)
,`PROD_preco` float
,`PROD_unidades` smallint(6)
,`PROD_descontinuado` bit(1)
,`FORN_codfor` int(11)
,`FORN_empresa` varchar(40)
,`FORN_contato` varchar(30)
,`FORN_cargo` varchar(30)
,`FORN_endereco` varchar(60)
,`FORN_cidade` varchar(15)
,`FORN_cep` varchar(10)
,`FORN_pais` varchar(15)
,`CATE_codcategoria` int(11)
,`CATE_descr` varchar(15)
);

