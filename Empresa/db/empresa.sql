CREATE DATABASE IF NOT EXISTS empresa; 

USE empresa;

CREATE TABLE DetalhesPed (
    NumPed int(11) NOT NULL DEFAULT '0',
    CodProd int(11) NOT NULL DEFAULT '0',
    Preco float DEFAULT NULL,
    Qtde smallint(6) DEFAULT NULL,
    Desconto float DEFAULT NULL,
    PRIMARY KEY (NumPed,CodProd),
    KEY CodProd (CodProd)
);

CREATE TABLE Pedidos (
    NumPed int(11) NOT NULL AUTO_INCREMENT,
    CodCli char(5) DEFAULT NULL,
    CodFun int(11) DEFAULT '0',
    DataPed date DEFAULT NULL,
    DataEntrega date DEFAULT NULL,
    Frete float DEFAULT '0',
    PRIMARY KEY (NumPed),
    KEY CodCli (CodCli),
    KEY CodFun (CodFun)
);

CREATE TABLE Funcionarios (
    CodFun int(11) NOT NULL AUTO_INCREMENT,
    Sobrenome varchar(20) DEFAULT NULL,
    Nome varchar(10) DEFAULT NULL,
    Cargo varchar(30) DEFAULT NULL,
    DataNasc date DEFAULT NULL,
    Endereco varchar(60) DEFAULT NULL,
    Cidade varchar(15) DEFAULT NULL,
    CEP varchar(10) DEFAULT NULL,
    Pais varchar(15) DEFAULT NULL,
    Fone varchar(24) DEFAULT NULL,
    Salario float DEFAULT '0',
    PRIMARY KEY (CodFun)
);

CREATE TABLE Produtos (
    CodProd int(11) NOT NULL AUTO_INCREMENT,
    Descr varchar(40) DEFAULT NULL,
    CodFor int(11) DEFAULT NULL,
    CodCategoria int(11) DEFAULT NULL,
    Preco float DEFAULT '0',
    Unidades smallint(6) DEFAULT '0',
    Descontinuado bit(1) DEFAULT NULL,
    PRIMARY KEY (CodProd),
    KEY CodCategoria (CodCategoria),
    KEY CodFor (CodFor)
);

CREATE TABLE Clientes (
    CodCli char(5) NOT NULL,
    Nome varchar(40) NOT NULL,
    Contato varchar(30) NOT NULL,
    Cargo varchar(30) NOT NULL,
    Endereco varchar(60) NOT NULL,
    Cidade varchar(15) NOT NULL,
    Regiao varchar(15) NOT NULL,
    CEP varchar(10) NOT NULL,
    Pais varchar(15) NOT NULL,
    Telefone varchar(24) NOT NULL,
    Fax varchar(24) NOT NULL,
    PRIMARY KEY (CodCli)
);

CREATE TABLE Fornecedores (
    CodFor int(11) NOT NULL AUTO_INCREMENT,
    Empresa varchar(40) DEFAULT NULL,
    Contato varchar(30) DEFAULT NULL,
    Cargo varchar(30) DEFAULT NULL,
    Endereco varchar(60) DEFAULT NULL,
    Cidade varchar(15) DEFAULT NULL,
    CEP varchar(10) DEFAULT NULL,
    Pais varchar(15) DEFAULT NULL,
    PRIMARY KEY (CodFor)
);

CREATE TABLE Categorias (
    CodCategoria int(11) NOT NULL AUTO_INCREMENT,
    Descr varchar(15) DEFAULT NULL,
    PRIMARY KEY (CodCategoria)
);

-- Restrições para a tabela `detalhesped` --

ALTER TABLE DetalhesPed
  ADD CONSTRAINT DetalhesPed_ibfk_1 FOREIGN KEY (NumPed) REFERENCES Pedidos (NumPed) ON DELETE CASCADE,
  ADD CONSTRAINT DetalhesPed_ibfk_2 FOREIGN KEY (CodProd) REFERENCES Produtos (CodProd) ON DELETE CASCADE;

-- Restrições para a tabela `pedidos` --

ALTER TABLE Pedidos
  ADD CONSTRAINT Pedidos_ibfk_1 FOREIGN KEY (CodCli) REFERENCES Clientes (CodCli) ON DELETE CASCADE,
  ADD CONSTRAINT Pedidos_ibfk_2 FOREIGN KEY (CodFun) REFERENCES Funcionarios (CodFun) ON DELETE CASCADE;

-- Restrições para a tabela `produtos` --

ALTER TABLE Produtos
  ADD CONSTRAINT Produtos_ibfk_1 FOREIGN KEY (CodCategoria) REFERENCES Categorias (CodCategoria) ON DELETE CASCADE,
  ADD CONSTRAINT Produtos_ibfk_2 FOREIGN KEY (CodFor) REFERENCES Fornecedores (CodFor) ON DELETE CASCADE;