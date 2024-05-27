CREATE DATABASE IF NOT EXISTS reserva_hotel; 

USE reserva_hotel;

CREATE TABLE CLIENTE(
	nome_completo VARCHAR(100),
	cpf VARCHAR(20),
	idade INTEGER,
	senha VARCHAR(100),
	email VARCHAR(100),
	PRIMARY KEY(cpf)
);

CREATE TABLE Quarto (
    Id_quarto INT PRIMARY KEY AUTO_INCREMENT,
    NumeroQuarto VARCHAR(10) NOT NULL,
    TipoQuarto VARCHAR(50) NOT NULL, 
    Preco DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL
);

CREATE TABLE Reserva (
    Id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    Id_quarto INT,
    DataCheckIn DATE NOT NULL,
    DataCheckOut DATE NOT NULL,
    FOREIGN KEY (Id_quarto) REFERENCES Quarto(Id_quarto)
);

-- Essa tabela é para cadastrar varios clientes em um quarto

CREATE TABLE ReservaCliente (
    Id_reserva INT,
    cpf_cliente VARCHAR(20),
    PRIMARY KEY (Id_reserva, cpf_cliente),
    FOREIGN KEY (Id_reserva) REFERENCES Reserva(Id_reserva),
    FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf)
);

-- INSERÇÕES

-- Insere quartos
INSERT INTO Quarto (NumeroQuarto, TipoQuarto, Preco, Status)
VALUES 
    ('101', 'Standard', 150.00, 'Disponível'),
    ('102', 'Standard', 150.00, 'Disponível'),
    ('103', 'Standard', 150.00, 'Disponível'),
    ('200', 'Luxo', 200.00, 'Disponível'),
    ('201', 'Luxo', 200.00, 'Disponível'),
    ('202', 'Luxo', 200.00, 'Disponível'),
    ('105', 'Standard', 150.00, 'Disponível'),
    ('106', 'Standard', 150.00, 'Disponível'),
    ('203', 'Luxo', 200.00, 'Disponível');

-- Insere reservas
INSERT INTO Reserva (Id_quarto, DataCheckIn, DataCheckOut)
VALUES (1, "2024-05-24", "2024-06-01");

INSERT INTO Reserva (Id_quarto, DataCheckIn, DataCheckOut)
VALUES (2, "2024-06-01", "2024-06-10");

INSERT INTO Reserva (Id_quarto, DataCheckIn, DataCheckOut)
VALUES (3, "2024-05-25", "2024-06-02");

-- Insere clientes
INSERT INTO CLIENTE (nome_completo, cpf, idade, senha, email) 
VALUES ("Flávia Alessandra Santos de Jesus", "12134356578", 21, "fravineas123", "fullflavy@gmail.com");

INSERT INTO CLIENTE (nome_completo, cpf, idade, senha, email) 
VALUES ("Bruno Peruno", "12345678900", 24, "bruno123", "bruno@gmail.com");

INSERT INTO CLIENTE (nome_completo, cpf, idade, senha, email) 
VALUES ("Brenda Castro", "12223334456", 21, "brenda123", "brenda@gmail.com");

-- Insere reservas de um cliente
INSERT INTO ReservaCliente (Id_reserva, cpf_cliente) 
VALUES (1, "12134356578");

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado)
UPDATE Quarto 
SET Status = "Ocupado"
WHERE Id_quarto = 1;

INSERT INTO ReservaCliente (Id_reserva, cpf_cliente) 
VALUES (2, "12345678900");

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado
UPDATE Quarto 
SET Status = "Ocupado"
WHERE Id_quarto = 2;

INSERT INTO ReservaCliente (Id_reserva, cpf_cliente) 
VALUES (3, "12223334456");

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado
UPDATE Quarto 
SET Status = "Ocupado"
WHERE Id_quarto = 3;

-- Mostra todos os quartos reservados
SELECT NumeroQuarto, TipoQuarto FROM Quarto
JOIN Reserva ON Quarto.Id_quarto = Reserva.Id_quarto 
JOIN ReservaCliente ON Reserva.Id_reserva = ReservaCliente.Id_reserva; 

-- Mostra os quartos desocupados (Não vai mostrar nenhum quarto pois todos estão ocupados)
SELECT NumeroQuarto, TipoQuarto, Preco, Quarto.Status FROM Quarto 
WHERE Quarto.Status = "Disponível";

-- Deleta o quarto na posição 9 (última posição)
DELETE FROM Quarto WHERE Id_quarto = '9';