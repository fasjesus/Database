-- 1. Selecionar todos os pedidos, nome, sobrenome e cargo do funcionário que emitiu pedidos com total de preço abaixo de R$ 10,00.

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


-- 2. Recuperar todos os funcionários e os respectivos clientes atendidos cujo valor do pedido está acima de R$ 50,00. 

SELECT  
    c.Nome AS Cliente,
    f.Nome AS Funcionario,
    f.Sobrenome,
    f.Cargo,
    SUM(d.Preco * d.Qtde - d.Desconto) as Total
FROM pedidos p
JOIN detalhesped d ON p.NumPed = d.NumPed
JOIN funcionarios f ON p.CodFun = f.CodFun
JOIN clientes c ON p.CodCli = c.CodCli
GROUP BY f.CodFun, c.CodCli
HAVING Total > 50.00;


-- 3. Complete a instrução para retornar todos os nomes e cargos dos funcionários e os respectivos nomes clientes atendidos 
-- cujo valor do pedido está acima de R$ 40,00 e produtos com preço acima de R$ 11,00 e não foram descontinuados.


SELECT 
    p.NumPed,
    f.Nome,
    f.Cargo,
    c.Nome AS Cliente,
    SUM(d.Preco) AS Valor,
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


-- 4. Retornar o cargo, o salário mínimo e salário máximo de todos os funcionários que tenham cargo de Representante na empresa 
-- ordenado ascendentemente.


SELECT 
    Cargo,
    MIN(Salario) AS SalarioMinimo,
    MAX(Salario) AS SalarioMaximo
FROM 
    funcionarios
WHERE 
    Cargo = 'Representante de Vendas'
GROUP BY 
    Cargo, Salario
ORDER BY 
    SalarioMinimo ASC;


/* 5. Considere a instrução com rollup abaixo e complete para extrair informações com: 
número de pedidos, nome de cliente, descrição de produtos, frete do pedido, preço do produto 
e total entre o preço do produto e frete por cliente, para preço de produtos maior que 50.

SELECT _______________,____________________,________________________,
format(sum(pedidos.frete),2) as frete,
format(sum(produtos.preco),2) as preco,
format(___________________________,2) as total
FROM ___________,____________,____________,_____________
WHERE
pedidos.codcli=clientes.codcli AND
pedidos.numped=detalhesped.numped and
produtos.codprod=detalhesped.codprod and
detalhesped.preco < 50
GROUP by ___________,_____________WITH ROLLUP
*/

SELECT 
    pedidos.numped AS NumeroPedidos,
    clientes.nome AS NomeCliente,
    produtos.descr AS DescricaoProduto,
    FORMAT(SUM(pedidos.frete), 2) AS Frete,
    FORMAT(SUM(produtos.preco), 2) AS PrecoProduto,
    FORMAT(SUM(produtos.preco + pedidos.frete), 2) AS Total
FROM 
    pedidos
JOIN 
    detalhesped ON pedidos.numped = detalhesped.numped
JOIN 
    produtos ON detalhesped.codprod = produtos.codprod
JOIN 
    clientes ON pedidos.codcli = clientes.codcli
WHERE
    produtos.preco > 50
GROUP BY 
    pedidos.numped, clientes.nome, produtos.descr
WITH ROLLUP;



