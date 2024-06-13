1. Selecionar todos os pedidos, nome, sobrenome e cargo do funcionário que emitiu pedidos com total de preço abaixo de R$ 10,00.

SELECT 
    p.NumPed,
    f.Nome,
    f.Sobrenome,
    f.Cargo,
    SUM(d.Preco * d.Qtde - d.Desconto) as Total
FROM 
    pedidos p
JOIN 
    detalhesped d ON p.NumPed = d.NumPed
JOIN 
    funcionarios f ON p.CodFun = f.CodFun
GROUP BY 
    p.NumPed, f.Nome, f.Sobrenome, f.Cargo
HAVING 
    Total < 10.00;


2. Recuperar todos os funcionários e os respectivos clientes atendidos cujo valor do pedido está acima de R$ 50,00.

SELECT 
    f.Nome,
    f.Sobrenome,
    f.Cargo,
    c.Nome AS Cliente,
    SUM(d.Preco * d.Qtde - d.Desconto) AS ValorPedido
FROM 
    pedidos p
JOIN 
    detalhesped d ON p.NumPed = d.NumPed
JOIN 
    funcionarios f ON p.CodFun = f.CodFun
JOIN 
    clientes c ON p.CodCli = c.CodCli
GROUP BY 
    f.CodFun, c.CodCli
HAVING 
    ValorPedido > 50.00;


3. Complete a instrução para retornar todos os nomes e cargos dos funcionários e os respectivos nomes clientes atendidos cujo valor do pedido está acima de R$ 40,00 e produtos com preço acima de R$ 11,00 e não foram descontinuados.


SELECT 
    p.NumPed,
    f.Nome,
    f.Cargo,
    c.Nome AS Cliente,
    SUM(d.Preco * d.Qtde - d.Desconto) AS Valor,
    prod.Descontinuado,
    prod.Preco
FROM 
    pedidos p
JOIN 
    detalhesped d ON p.NumPed = d.NumPed
JOIN 
    funcionarios f ON p.CodFun = f.CodFun
JOIN 
    clientes c ON p.CodCli = c.CodCli
JOIN 
    produtos prod ON d.CodProd = prod.CodProd
WHERE 
    prod.Preco > 11.00 AND prod.Descontinuado = 0
GROUP BY 
    p.NumPed, f.Nome, f.Cargo, c.Nome, prod.Descontinuado, prod.Preco
HAVING 
    Valor > 40.00;


4. Retornar o cargo, o salário mínimo e salário máximo de todos os funcionários que tenham cargo de Representante na empresa ordenado ascendentemente.


SELECT 
    Cargo,
    MIN(Salario) AS SalarioMinimo,
    MAX(Salario) AS SalarioMaximo
FROM 
    funcionarios
WHERE 
    Cargo = 'Representante'
GROUP BY 
    Cargo
ORDER BY 
    Cargo ASC;


5. Instrução com ROLLUP para extrair informações conforme solicitado.


SELECT 
    clientes.Nome AS Cliente,
    produtos.Descr AS Produto,
    pedidos.Frete,
    FORMAT(SUM(produtos.Preco), 2) AS Preco,
    FORMAT(SUM(produtos.Preco + pedidos.Frete), 2) AS Total
FROM 
    pedidos
JOIN 
    detalhesped ON pedidos.NumPed = detalhesped.NumPed
JOIN 
    produtos ON detalhesped.CodProd = produtos.CodProd
JOIN 
    clientes ON pedidos.CodCli = clientes.CodCli
WHERE 
    produtos.Preco > 50
GROUP BY 
    clientes.Nome, produtos.Descr, pedidos.Frete
WITH ROLLUP;



