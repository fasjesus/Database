CREATE DATABASE IF NOT EXISTS reserva_hoteis; 

USE reserva_hoteis;

CREATE TABLE CLIENTE(
	nome_completo VARCHAR(100),
	cpf VARCHAR(20),
	idade INTEGER,
	user_name VARCHAR(30),
	senha VARCHAR(100),
	email VARCHAR(100),
	PRIMARY KEY(cpf, user_name)
);

CREATE TABLE Hotel (
    Id_hotel INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Cidade VARCHAR(100) NOT NULL,
    Estado VARCHAR(100) NOT NULL,
    Pais VARCHAR(100) NOT NULL,
    Telefone VARCHAR(15),
    Email VARCHAR(100)
);

CREATE TABLE Quarto (
    Id_quarto INT PRIMARY KEY AUTO_INCREMENT,
    Id_hotel INT,
    NumeroQuarto VARCHAR(10) NOT NULL,
    TipoQuarto VARCHAR(50) NOT NULL, 
    Preco DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL, 
    FOREIGN KEY (Id_hotel) REFERENCES Hotel(id_hotel)
);

CREATE TABLE Reserva (
    Id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    Id_quarto INT,
    DataCheckIn DATE NOT NULL,
    DataCheckOut DATE NOT NULL,
    Status VARCHAR(50) NOT NULL, 
    FOREIGN KEY (Id_quarto) REFERENCES Quarto(Id_quarto)
);


-- Essa tabela é para cadastrar varios clientes em um quarto

CREATE TABLE ReservaCliente (
    Id_reserva INT,
    cpf_cliente VARCHAR(20),
    user_name_cliente VARCHAR(30),
    PRIMARY KEY (Id_reserva, cpf_cliente, user_name_cliente),
    FOREIGN KEY (Id_reserva) REFERENCES Reserva(Id_reserva),
    FOREIGN KEY (cpf_cliente, user_name_cliente) REFERENCES CLIENTE(cpf, user_name)
);

-- INSERÇÕES

-- Insere hoteis
INSERT INTO Hotel (Nome, cnpj, Endereco, Cidade, Estado, Pais, Telefone, Email) 
VALUES ('Hotel Prime', '123.456.789/0001-01', 'Rua cinco, 123', 'ilheus', 'Bahia', 'Brasil', '733456-7890', 'hotelprime@gmail.com');	

INSERT INTO Hotel (Nome, cnpj, Endereco, Cidade, Estado, Pais, Telefone, Email)
VALUES ('Hotel Aldeia', '234.567.890/0001-02', 'Avenida Olivenca, 456', 'ilheus', 'Bahia', 'Brasil', '732345-6789', 'hotelaldeia@gmail.com');

INSERT INTO Hotel (Nome, cnpj, Endereco, Cidade, Estado, Pais, Telefone, Email)
VALUES ('Hotel Premium', '345.678.901/0001-03', 'Travessa dois, 789', 'ilheus', 'Bahia', 'Brasil', '733456-7890', 'hotelpremium@gmail.com');

-- Insere quartos
INSERT INTO Quarto (Id_hotel, NumeroQuarto, TipoQuarto, Preco, Status)
VALUES 
    (1, '101', 'Standard', 150.00, 'Disponível'),
    (1, '102', 'Standard', 150.00, 'Disponível'),
    (1, '201', 'Luxo', 250.00, 'Disponível');


INSERT INTO Quarto (Id_hotel, NumeroQuarto, TipoQuarto, Preco, Status)
VALUES 
    (2, '101', 'Standard', 120.00, 'Disponível'),
    (2, '201', 'Luxo', 200.00, 'Disponível'),
    (2, '202', 'Luxo', 200.00, 'Disponível');


INSERT INTO Quarto (Id_hotel, NumeroQuarto, TipoQuarto, Preco, Status)
VALUES 
    (3, '101', 'Standard', 170.00, 'Disponível'),
    (3, '102', 'Standard', 170.00, 'Disponível'),
    (3, '202', 'Luxo', 280.00, 'Disponível');

-- Insere reservas
INSERT INTO Reserva (Id_quarto, DataCheckIn, DataCheckOut, Status)
VALUES (1, "2024-05-24", "2024-06-01", "Desocupado");

INSERT INTO Reserva (Id_quarto, DataCheckIn, DataCheckOut, Status)
VALUES (2, "2024-06-01", "2024-06-10", "Desocupado");

INSERT INTO Reserva (Id_quarto, DataCheckIn, DataCheckOut, Status)
VALUES (3, "2024-05-25", "2024-06-02", "Desocupado");

-- Insere clientes
INSERT INTO CLIENTE (nome_completo, cpf, idade, user_name, senha, email) 
VALUES ("Flávia Alessandra Santos de Jesus", "12134356578", 21, "fullflavy", "fravineas123", "fullflavy@gmail.com");

INSERT INTO CLIENTE (nome_completo, cpf, idade, user_name, senha, email) 
VALUES ("Bruno Peruano", "12345678900", 24, "brunoperuano", "bruno123", "bruno@gmail.com");

INSERT INTO CLIENTE (nome_completo, cpf, idade, user_name, senha, email) 
VALUES ("Brenda Castro", "12223334456", 21, "brendacastro", "brenda123", "brenda@gmail.com");

-- Insere reservas de um cliente
INSERT INTO ReservaCliente (Id_reserva, cpf_cliente, user_name_cliente) 
VALUES (1, "12134356578", "fullflavy");

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, a reserva dele precisa ser atualizada para Status = ocupado)
UPDATE Reserva 
SET Status = "Ocupado"
WHERE Id_reserva = 1;

INSERT INTO ReservaCliente (Id_reserva, cpf_cliente, user_name_cliente) 
VALUES (2, "12345678900", "brunoatsoc");

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, a reserva dele precisa ser atualizada para Status = ocupado
UPDATE Reserva 
SET Status = "Ocupado"
WHERE Id_reserva = 2;

INSERT INTO ReservaCliente (Id_reserva, cpf_cliente, user_name_cliente) 
VALUES (3, "12223334456", "brendacastro");

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, a reserva dele precisa ser atualizada para Status = ocupado
UPDATE Reserva 
SET Status = "Ocupado"
WHERE Id_reserva = 3;

-- Mostra todos os usuarios que estão com quartos reservados
SELECT NumeroQuarto, TipoQuarto, nome_completo, cpf, idade, user_name, senha, email FROM Quarto 
JOIN Reserva ON Quarto.Id_quarto = Reserva.Id_quarto 
JOIN ReservaCliente ON Reserva.Id_reserva = ReservaCliente.Id_reserva 
JOIN CLIENTE ON cpf_cliente = cpf
ORDER BY nome_completo;

-- Mostra os quartos desocupados (Não vai mostrar nenhum quarto pois todos estão ocupados)
SELECT NumeroQuarto, TipoQuarto, Preco, DataCheckIn, DataCheckOut, Reserva.Status FROM Quarto 
JOIN Reserva ON Quarto.Id_quarto = Reserva.Id_quarto 
WHERE Reserva.Status = "Desocupado";