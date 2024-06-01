-- Listar os nomes e idades, ordenados por data nascimento decrescente:

SELECT nome, 
       YEAR(CURDATE()) - YEAR(STR_TO_DATE(dt_nascimento, '%d/%m/%Y')) AS idade
FROM ESTUDANTE
ORDER BY STR_TO_DATE(dt_nascimento, '%d/%m/%Y') DESC;

-- Listar os nomes, idade, turno e média de score (mtest) dos alunos da classe 1B:

SELECT e.nome, 
       YEAR(CURDATE()) - YEAR(STR_TO_DATE(e.dt_nascimento, '%d/%m/%Y')) AS idade, 
       d.turno, 
       e.mtest
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE e.classe = '1B';

-- Listar os estudantes do sexo masculino com respectivo score médio de notas (mtest):

SELECT nome, 
       AVG(mtest) AS media_mtest
FROM ESTUDANTE
WHERE sexo = 'M'
GROUP BY nome;

-- Listar os nomes e sexo dos estudantes que cursam matemática, cuja nota seja acima de 80:

SELECT e.nome, 
       e.sexo
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE d.disciplina = 'Matemática' 
  AND e.mtest > 80;

-- Listar os nomes e nascimento dos estudantes do turno noturno, por disciplina:

SELECT e.nome, 
       e.dt_nascimento, 
       d.disciplina
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE d.turno = 'Not'
ORDER BY d.disciplina;

-- Listar os nomes dos estudantes que estudam biologia e contagem por agrupamento:

SELECT e.nome, 
       COUNT(d.disciplina) AS count_biologia
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE d.disciplina = 'Biologia'
GROUP BY e.nome;

-- Consultar o sexo e nome dos estudantes da classe 1B que cursam física:

SELECT e.sexo, 
       e.nome
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE e.classe = '1B' 
  AND d.disciplina = 'Física';

-- Query com todos os estudantes cadastrados por disciplina e com data nascimento não informada (usar inner join):

SELECT e.nome, 
       e.dt_nascimento, 
       d.disciplina
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE e.dt_nascimento IS NULL;

-- Query com todos estudantes e respectivas disciplinas, agrupados por disciplina, com idade abaixo de 16 anos (usar inner join):

SELECT d.disciplina, 
       e.nome, 
       YEAR(CURDATE()) - YEAR(STR_TO_DATE(e.dt_nascimento, '%d/%m/%Y')) AS idade
FROM ESTUDANTE e
JOIN DISCIPLINA d ON e.id_estudante = d.FK_id_estudante
WHERE YEAR(CURDATE()) - YEAR(STR_TO_DATE(e.dt_nascimento, '%d/%m/%Y')) < 16
GROUP BY d.disciplina, e.nome;