CREATE DATABASE IF NOT EXISTS curso; 

USE curso;

CREATE TABLE ESTUDANTE (
    id_estudante INT,
    nome VARCHAR(100),
	dt_nascimento VARCHAR(10),
	sexo VARCHAR(2),
	classe VARCHAR(5),
	mtest INT,
    hcode VARCHAR(2),
    dcode VARCHAR(5),
    remission VARCHAR(2),
	PRIMARY KEY(id_estudante)
);

CREATE TABLE DISCIPLINA (
    id_disciplina INT,
    FK_id_estudante INT,
    disciplina VARCHAR(100),
    turno VARCHAR(5),
    PRIMARY KEY(id_disciplina),
    FOREIGN KEY (FK_id_estudante) REFERENCES ESTUDANTE(id_estudante) ON DELETE CASCADE
);