/* Esse Database foi criado por Brenda C. da Silva e Flávia A. S. de Jesus para a composição de um crédito na 
 disciplina de Banco de Dados.           
 Maio/Junho de 2024. 
*/ 

CREATE DATABASE IF NOT EXISTS reserva_hotel; 

USE reserva_hotel;

CREATE TABLE CLIENTE (
    user_name VARCHAR(255),
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

-- INSERÇÕES:

-- Insere quartos:
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


-- Insere clientes:
INSERT INTO CLIENTE (user_name, nome_completo, cpf, idade, senha, email) 
VALUES ("fullflavy", "Flávia Alessandra Santos de Jesus", "12134356578", 21, "fravineas123", "fullflavy@gmail.com");

INSERT INTO CLIENTE (user_name, nome_completo, cpf, idade, senha, email) 
VALUES ("bperuno", "Bruno Peruno", "12345678900", 24, "bruno123", "bruno@gmail.com");

INSERT INTO CLIENTE (user_name, nome_completo, cpf, idade, senha, email) 
VALUES ("bcastro", "Brenda Castro", "12223334456", 21, "brenda123", "brenda@gmail.com");


-- Insere reservas:
INSERT INTO RESERVA (FK_Id_quarto, FK_cpf, DataCheckIn, DataCheckOut)
VALUES (1, "12134356578", "2024-05-24", "2024-06-01");

INSERT INTO RESERVA (FK_Id_quarto, FK_cpf, DataCheckIn, DataCheckOut)
VALUES (2, "12345678900", "2024-06-01", "2024-06-10");

INSERT INTO RESERVA (FK_Id_quarto, FK_cpf, DataCheckIn, DataCheckOut)
VALUES (3, "12223334456", "2024-05-25", "2024-06-02");


-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado):
UPDATE QUARTO
SET Status = "Ocupado"
WHERE Id_quarto = 1;

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado:
UPDATE QUARTO 
SET Status = "Ocupado"
WHERE Id_quarto = 2;

-- Atualiza o status do quarto (pois quando um usuario faz a reserva do quarto, 
-- a reserva dele precisa ser atualizada para Status = ocupado:
UPDATE QUARTO
SET Status = "Ocupado"
WHERE Id_quarto = 3;

-- Mostra todos os quartos reservados:
SELECT NumeroQuarto, TipoQuarto FROM QUARTO
JOIN RESERVA ON QUARTO.Id_quarto = RESERVA.FK_Id_quarto
JOIN CLIENTE ON CLIENTE.cpf = RESERVA.FK_cpf; 

-- Mostra os quartos disponíveis (vai mostrar 6 quartos):
SELECT NumeroQuarto, TipoQuarto, Preco, QUARTO.Status FROM QUARTO
WHERE QUARTO.Status = "Disponível";

-- Deleta o quarto na posição 9 (última posição):
DELETE FROM QUARTO WHERE Id_quarto = '9';

-- Mostra os quartos disponíveis (vai mostrar 5 quartos):
SELECT NumeroQuarto, TipoQuarto, Preco, QUARTO.Status FROM QUARTO
WHERE QUARTO.Status = "Disponível";

-- Mostra as tabelas:
-- SELECT * FROM CLIENTE;
-- SELECT * FROM QUARTO;
-- SELECT * FROM RESERVA;

-- Passo 1: Remover a chave estrangeira
ALTER TABLE reserva DROP FOREIGN KEY reserva_ibfk_2;

-- Passo 2: Remover a coluna
ALTER TABLE reserva DROP COLUMN FK_cpf;

ALTER TABLE reserva
ADD COLUMN FK_Email VARCHAR(100);

-- Criar um índice único na coluna 'email' da tabela 'cliente'
ALTER TABLE cliente
ADD UNIQUE (email);

-- Adicionar a chave estrangeira na tabela 'reserva'
ALTER TABLE reserva
ADD CONSTRAINT fk_email
FOREIGN KEY (FK_Email) REFERENCES cliente(email);

DELETE FROM quarto WHERE Id_quarto = 10;
DELETE FROM quarto WHERE Id_quarto = 11;

CREATE TABLE metodo_pagamento (
    id_metodoPag INT AUTO_INCREMENT PRIMARY KEY,
    nome_metodoPag VARCHAR(100) NOT NULL
);

ALTER TABLE reserva 
ADD COLUMN MetodoPagamento VARCHAR(255);


 -- ==================================== USADO PARA REMOVER AS RESERVAS DEFEITUOSAS FEITAS ANTERIORMENTE ====================================
 --
 use reserva_hotel;
SELECT * FROM RESERVA
WHERE 
    FK_Id_quarto IS NULL OR
    DataCheckIn IS NULL OR
    DataCheckOut IS NULL OR
    FK_Email IS NULL OR
    MetodoPagamento IS NULL;

-- Desativa o modo seguro temporariamente
SET SQL_SAFE_UPDATES = 0;

-- Executa a exclusão
DELETE FROM RESERVA
WHERE 
    FK_Id_quarto IS NULL OR
    DataCheckIn IS NULL OR
    DataCheckOut IS NULL OR
    FK_Email IS NULL OR
    MetodoPagamento IS NULL;

-- Reativa o modo seguro
SET SQL_SAFE_UPDATES = 1;


-- ===================================================== USADO PARA EVITAR QUARTOS OCUPADOS SEM RESERVA ================================
--
use reserva_hotel;

SET SQL_SAFE_UPDATES = 0;

UPDATE QUARTO 
SET Status = 'Disponível' 
WHERE Id_quarto NOT IN (
    SELECT FK_Id_quarto 
    FROM RESERVA
);

SET SQL_SAFE_UPDATES = 1;


-- ============================================= USADO PARA CONSEGUIR ORDENAR OS QUARTOS COM ORDER BY PELO NÚMERO ================================
--
ALTER TABLE QUARTO MODIFY COLUMN NumeroQuarto INT;

-- =============================================================================
--
-- Alterar tabela reserva para incluir FK_Id_pagamento e remover MetodoPagamento
ALTER TABLE reserva
ADD COLUMN FK_Id_pagamento INT,
DROP COLUMN MetodoPagamento,
ADD CONSTRAINT fk_reserva_metodo_pagamento FOREIGN KEY (FK_Id_pagamento) REFERENCES metodo_pagamento(id_metodoPag);


DELETE FROM QUARTO
WHERE Id_quarto = 1;

INSERT INTO QUARTO (NumeroQuarto, TipoQuarto, Preco, Status)
VALUES 
    ('101', 'Standard', 150.00, 'Disponível');