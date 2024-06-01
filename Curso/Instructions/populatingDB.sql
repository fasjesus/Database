-- INSERÇÕES:

-- Insere estudantes:
INSERT INTO ESTUDANTE (id_estudante, nome, dt_nascimento, sexo, classe, mtest, hcode, dcode, remission)
VALUES 
    (9802, 'Mary', '06/08/2006', 'F', '1A', 92, 'Y', 'HHM', 'F'),
    (9803, 'Johnny', '02/07/2006', 'M', '1A', 91, 'G', 'SSP', 'T'),
    (9804, 'Wendy', '16/06/2006', 'F', '1B', 84, 'B', 'YMT', 'F'),
    (9805, 'Tobe', '06/05/2006', 'M', '1B', 88, 'R', 'YMT', 'F'),
    (9901, 'ROY', '09/07/2006', 'M', NULL, NULL, NULL, NULL, NULL),
    (9912, 'IAN', '02/04/2006', NULL, NULL, NULL, NULL, NULL, NULL),
    (9914, 'CAMIL', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Insere disciplinas:
INSERT INTO DISCIPLINA (id_disciplina, FK_id_estudante, disciplina, turno)
VALUES 
    (12, 9804, 'Português', 'Mat'),
    (14, 9803, 'Matemática', 'Mat'),
    (17, 9804, 'Biologia', 'Mat'),
    (13, 9801, 'Português', 'Not'),
    (11, 9805, 'Física', 'Not'),
    (19, 9813, 'Biologia', 'Mat'),
    (20, 9802, 'Química', 'Mat'),
    (16, 9801, 'Matemática', 'Not'),
    (10, 9803, 'Português', 'Not'),
    (21, 9804, 'Física', 'Not'),
    (22, 9802, 'Matemática', 'Not');
