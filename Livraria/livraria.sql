CREATE DATABASE IF NOT EXISTS livraria;

USE livraria;

-- Banco de Dados: `livraria`
-- --------------------------------------------------------

-- Estrutura da tabela `autores`
-- 

CREATE TABLE `autores` (
  `ID_Autor` int(11) NOT NULL,
  `Nome` varchar(70) default NULL,
  `Contato` varchar(45) default NULL,
  `ID_Editora` int(11) default NULL,
  PRIMARY KEY  (`ID_Autor`),
  KEY `Fk_ID_Editora` (`ID_Editora`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Extraindo dados da tabela `autores`
-- 

INSERT INTO `autores` (`ID_Autor`, `Nome`, `Contato`, `ID_Editora`) VALUES 
(11111, 'Machado de Assis', 'Jose Antonio', 11115),
(11112, 'Jose de Alencar', 'Pedro Cicero', 11113),
(11113, 'Pedro Lemos de Brito', 'Marta Sul', 11112),
(11114, 'Savio de Neto', 'Joana Maranhao', 11115);

-- --------------------------------------------------------

-- 
-- Estrutura da tabela `cliente`
-- 

CREATE TABLE `cliente` (
  `ID_Cliente` int(11) NOT NULL,
  `Nome` varchar(70) default NULL,
  `Endereco` varchar(70) default NULL,
  `Telefone` varchar(14) default NULL,
  `Cidade` varchar(45) default NULL,
  `Cep` varchar(45) default NULL,
  `Email` varchar(70) default NULL,
  PRIMARY KEY  (`ID_Cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Extraindo dados da tabela `cliente`
-- 

INSERT INTO `cliente` (`ID_Cliente`, `Nome`, `Endereco`, `Telefone`, `Cidade`, `Cep`, `Email`) VALUES 
(11, 'Laura Soares', 'Rua Castro Alves 47', '71-99814525', 'Itabuna', '456000000', 'sergio@com.com.br'),
(12, 'Lais Souza Pieres de Santos', 'Rua Castro Alves 47', '71-66582144', 'Salvador', '41566222', 'saivio@oi.com.br'),
(13, 'Sergio Fred Andrade', 'Av. Manoel Dias da Silva, 67', '73-56899666', 'Jequie', '42566888', 'nove@oi.com.br'),
(14, 'Joana Prado Mendes', 'Av. Itabuna, 5678', '7-55655555', 'Rio de Janeiro', '45214111', 'bem@hotmail.com'),
(15, 'Celia Ribeiro', 'Rua Castro, 890', '21-25659899', 'Rio de Janeiro', '45689966', 'fsilva@hotmail.com'),
(16, 'Marta Souza Andrade', 'Rua das Rosas, 89', '73-88569999', 'Ilheus', '45698555', 'aporto@uol.com.br'),
(17, 'Flavia Alexandra', 'Rua Giovana Antoneli, 78', '73-99812566', 'Itabuna', '45685555', 'lae@gmail.com'),
(18, 'Fatima Bernardes', 'Rua Castro Natal, 45', '73-21536666', 'Camaca', '45855555', 'cdlia@hotmail.com');

-- --------------------------------------------------------

-- 
-- Estrutura da tabela `editora`
-- 

CREATE TABLE `editora` (
  `ID_Editora` int(11) NOT NULL,
  `Nome` varchar(70) default NULL,
  `Endereco` varchar(70) default NULL,
  `Telefone` varchar(14) default NULL,
  PRIMARY KEY  (`ID_Editora`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Extraindo dados da tabela `editora`
-- 

INSERT INTO `editora` (`ID_Editora`, `Nome`, `Endereco`, `Telefone`) VALUES 
(11111, 'Campos', 'Rua Castro Alves, 47', '73-211-5256'),
(11112, 'Atica', 'Av. Ciinquentenario, 43', '73-3215-6663'),
(11113, 'Erica e Campos', 'Av. Roberto Santos, 52', '74-9985-6522'),
(11114, 'Saraiva', 'Av. Contorno, 678', '71-6589-6522'),
(11115, 'Mundo Novo', 'Av. Ribeiro Neto, 6777', '11-5246-8574'),
(11116, 'Esperanca', 'Rua Nova, 89', '11-2525-8544');

-- --------------------------------------------------------

-- 
-- Estrutura da tabela `livros`
-- 

CREATE TABLE `livros` (
  `ISBN` int(11) NOT NULL,
  `Titulo` varchar(70) default NULL,
  `ID_Autor` int(11) default NULL,
  `ID_Editora` int(11) default NULL,
  `Preco` decimal(2,0) default NULL,
  `DataLanc` date default NULL,
  PRIMARY KEY  (`ISBN`),
  KEY `Fk_ID_Autor` (`ID_Autor`),
  KEY `Fk_ID_Ediora` (`ID_Editora`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Extraindo dados da tabela `livros`
-- 

INSERT INTO `livros` (`ISBN`, `Titulo`, `ID_Autor`, `ID_Editora`, `Preco`, `DataLanc`) VALUES 
(221111, 'Alice no Pais das Maravilhas', 11113, 11112, '99', '2003-02-25'),
(221112, 'Homem de Ferro', 11112, 11114, '56', '1899-12-20'),
(221113, 'E assim caminha a humanidade', 11114, 11112, '56', '2010-05-17'),
(221114, 'Todo Mundo', 11113, 11113, '75', '2010-05-17'),
(221115, 'Universidade para Todos', 11112, 11116, '51', '2010-05-17'),
(221116, 'Faculdade Ciencias', 11111, 11113, '36', '2010-05-17'),
(221117, 'Ruas de Medo', 11114, 11114, '45', '2010-05-17'),
(221118, 'Nada Entendi', 11111, 11114, '89', '2010-05-17'),
(221119, 'Comandatuba', 11111, 11115, '22', '1900-01-01'),
(221120, 'Barra Vento', 11112, 11116, '99', '2010-05-17');

-- --------------------------------------------------------

-- 
-- Estrutura da tabela `vendas`
-- 

CREATE TABLE `vendas` (
  `ISBN` int(11) NOT NULL,
  `Qtde` int(11) default NULL,
  `Preco` decimal(2,0) default NULL,
  `Total` decimal(2,0) default NULL,
  `Data` date default NULL,
  `ID_Cliente` int(11) default NULL,
  PRIMARY KEY  (`ISBN`),
  KEY `Fk_ID_Cliente` (`ID_Cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Extraindo dados da tabela `vendas`
-- 

INSERT INTO `vendas` (`ISBN`, `Qtde`, `Preco`, `Total`, `Data`, `ID_Cliente`) VALUES 
(221111, 8, '99', '99', '2010-05-17', 13),
(221112, 8, '28', '99', '2010-05-17', 11),
(221113, 5, '58', '96', '2010-05-17', 15),
(221114, 9, '25', '99', '2010-05-17', 14),
(221115, 10, '99', '99', '1899-12-26', 17),
(221116, 6, '25', '58', '2010-05-17', 18),
(221117, 6, '85', '99', '2010-05-17', 11),
(221119, 5, '58', '99', '2010-05-17', 12);

-- --------------------------------------------------------

-- 
-- Estrutura da tabela `vendas_livros`
-- 

CREATE TABLE `vendas_livros` (
  `Id_Vendas` int(11) NOT NULL,
  `Id_Livros` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 
-- Extraindo dados da tabela `vendas_livros`
-- 

INSERT INTO `vendas_livros` (`Id_Vendas`, `Id_Livros`) VALUES 
(221111, 221112),
(221113, 221111),
(221113, 221112),
(221111, 221113);

-- 
-- Restrições para as tabelas dumpadas
-- 

-- 
-- Restrições para a tabela `autores`
-- 
ALTER TABLE `autores`
  ADD CONSTRAINT `Fk_ID_Editora` FOREIGN KEY (`ID_Editora`) REFERENCES `editora` (`ID_Editora`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 
-- Restrições para a tabela `livros`
-- 
ALTER TABLE `livros`
  ADD CONSTRAINT `Fk_ID_Autor` FOREIGN KEY (`ID_Autor`) REFERENCES `autores` (`ID_Autor`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Fk_ID_Ediora` FOREIGN KEY (`ID_Editora`) REFERENCES `editora` (`ID_Editora`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- 
-- Restrições para a tabela `vendas`
-- 
ALTER TABLE `vendas`
  ADD CONSTRAINT `Fk_ID_Cliente` FOREIGN KEY (`ID_Cliente`) REFERENCES `cliente` (`ID_Cliente`) ON DELETE NO ACTION ON UPDATE NO ACTION;