CREATE DATABASE IF NOT EXISTS reserva_hotel; 

USE reserva_hotel;

CREATE TABLE CLIENTE (
	nome_completo VARCHAR(100),
	cpf VARCHAR(20),
	idade INTEGER,
	senha VARCHAR(100),
	email VARCHAR(100),
	PRIMARY KEY(cpf)
);

CREATE TABLE QUARTO (
    Id_quarto INT PRIMARY KEY AUTO_INCREMENT,
    NumeroQuarto VARCHAR(10) NOT NULL,
    TipoQuarto VARCHAR(50) NOT NULL, 
    Preco DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL
);

CREATE TABLE RESERVA (
    Id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    FK_Id_quarto INT,
    FK_cpf VARCHAR(20),
    DataCheckIn DATE NOT NULL,
    DataCheckOut DATE NOT NULL,
    FOREIGN KEY (FK_Id_quarto) REFERENCES QUARTO(Id_quarto) ON DELETE CASCADE,
    FOREIGN KEY (FK_cpf) REFERENCES CLIENTE(cpf) ON DELETE CASCADE
);

-- INSERÇÕES

-- Insere quartos
INSERT INTO QUARTO (NumeroQuarto, TipoQuarto, Preco, Status)
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


-- Insere clientes
INSERT INTO CLIENTE (nome_completo, cpf, idade, senha, email) 
VALUES ("Flávia Alessandra Santos de Jesus", "12134356578", 21, "fravineas123", "fullflavy@gmail.com");

INSERT INTO CLIENTE (nome_completo, cpf, idade, senha, email) 
VALUES ("Bruno Peruno", "12345678900", 24, "bruno123", "bruno@gmail.com");

INSERT INTO CLIENTE (nome_completo, cpf, idade, senha, email) 
VALUES ("Brenda Castro", "12223334456", 21, "brenda123", "brenda@gmail.com");


-- Insere reservas
INSERT INTO RESERVA (FK_Id_quarto, FK_cpf, DataCheckIn, DataCheckOut)
VALUES (1, "12134356578", "2024-05-24", "2024-06-01");

INSERT INTO RESERVA (FK_Id_quarto, FK_cpf, DataCheckIn, DataCheckOut)
VALUES (2, "12345678900", "2024-06-01", "2024-06-10");

INSERT INTO RESERVA (FK_Id_quarto, FK_cpf, DataCheckIn, DataCheckOut)
VALUES (3, "12223334456", "2024-05-25", "2024-06-02");


-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado)
UPDATE QUARTO
SET Status = "Ocupado"
WHERE Id_quarto = 1;

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado
UPDATE QUARTO 
SET Status = "Ocupado"
WHERE Id_quarto = 2;

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado
UPDATE QUARTO
SET Status = "Ocupado"
WHERE Id_quarto = 3;

-- Mostra todos os quartos reservados
SELECT NumeroQuarto, TipoQuarto FROM QUARTO
JOIN RESERVA ON QUARTO.Id_quarto = RESERVA.FK_Id_quarto
JOIN CLIENTE ON CLIENTE.cpf = RESERVA.FK_cpf; 

-- Mostra os quartos disponíveis (vai mostrar 6 quartos)
SELECT NumeroQuarto, TipoQuarto, Preco, QUARTO.Status FROM QUARTO
WHERE QUARTO.Status = "Disponível";

-- Deleta o quarto na posição 9 (última posição)
DELETE FROM QUARTO WHERE Id_quarto = '9';

-- Mostra os quartos disponíveis (vai mostrar 5 quartos)
SELECT NumeroQuarto, TipoQuarto, Preco, QUARTO.Status FROM QUARTO
WHERE QUARTO.Status = "Disponível";