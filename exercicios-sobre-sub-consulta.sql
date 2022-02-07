/*
1) Listar o nome e valor do filme mais barato para compra, que seja da Categoria
Ouro ou Prata.
*/
SELECT
	filme.Nome_Filme 'Nome',
	filme.Vl_Filme 'Valor'
FROM Filmes filme
WHERE filme.Vl_Filme = (
	SELECT MIN(filme1.Vl_Filme)
	FROM Filmes filme1
	JOIN Categoria categoria ON (filme1.Cod_Categoria = categoria.Cod_Categoria)
	WHERE categoria.Dsc_Categoria IN ('Ouro', "Prata")
);

/* 2) Listar o código e nome dos filmes que nunca foram locados (cláusula in/not in) */
SELECT
	filme.Cod_Filme 'ID',
	filme.Nome_Filme 'Nome'
FROM Filmes filme
WHERE filme.Cod_Filme NOT IN (
	SELECT filme1.Cod_Filme
	FROM Filmes filme1
	JOIN Locacao locacao ON (locacao.Cod_Filme = filme1.Cod_Filme)
);

/*
3) Listar o código, nome e valor dos filmes que são mais caros do que qualquer filme
locado pelo cliente José de Arimatéia.
*/
SELECT 
	filme.Cod_Filme 'ID',
	filme.Nome_Filme 'Nome',
	filme.Vl_Filme 'Valor'
FROM Filmes filme
WHERE filme.Vl_Filme > ANY(
	SELECT filme1.Vl_Filme
	FROM Filmes filme1
	JOIN Locacao locacao ON (filme1.Cod_Filme = locacao.Cod_Filme)
	JOIN Clientes cliente ON (locacao.Cod_Cliente = cliente.Cod_Cliente)
	WHERE cliente.Nome_Cliente = 'José de Arimatéia'
);

/*
4) Listar os códigos, nomes e data de nascimento dos clientes que locaram mais
filmes estrangeiros do que o cliente José de Arimatéia.
*/
SELECT
	cliente.Cod_Cliente 'ID',
	cliente.Nome_Cliente 'Nome',
	cliente.Dat_Nascimento 'Data de nascimento'
FROM Clientes cliente
JOIN Locacao locacao ON (locacao.Cod_Cliente = cliente.Cod_Cliente)
JOIN Filmes filme ON (locacao.Cod_Filme = filme.Cod_Filme)
WHERE filme.Ind_Pais = 2
GROUP BY cliente.Cod_Cliente HAVING(COUNT(*) > (
	SELECT COUNT(*)
	FROM Clientes cliente1
	JOIN Locacao locacao1 ON (locacao1.Cod_Cliente = cliente1.Cod_Cliente)
	JOIN Filmes filme1 ON (locacao1.Cod_Filme = filme1.Cod_Filme)
	WHERE filme1.Ind_Pais = 2 AND cliente1.Nome_Cliente = 'José de Arimatéia'
));

/*
5) Listar o código e data de locação (início e fim), nome do filme e nome dos clientes
que locaram mais filme do que todos os clientes que nasceram antes de 1980.

ERRADA E INCOMPLETA!! AINDA TENHO MUITA DÚVIDA SOBRE ESSA DAQUI!!!!!!!!
*/
SELECT 
	cliente.Nome_Cliente
FROM Locacao locacao
JOIN Clientes cliente ON (locacao.Cod_Cliente = cliente.Cod_Cliente)
JOIN Filmes filme ON (locacao.Cod_Filme = filme.Cod_Filme)
GROUP BY cliente.Nome_Cliente HAVING(COUNT(*) > ALL(
	SELECT COUNT(*)
	FROM Clientes cliente1
	JOIN Locacao locacao1 ON (locacao1.Cod_Cliente = cliente1.Cod_Cliente)
	JOIN Filmes filme1 ON (locacao1.Cod_Filme = filme1.Cod_Filme)
	WHERE EXTRACT(year FROM cliente1.Dat_Nascimento) < 1980
	GROUP BY cliente1.Cod_Cliente
));

/*
6) Fazer uma consulta para mostrar o código e nome dos filmes cujo preços são
maiores do que a média da sua categoria (cláusula correlacionada).
*/
SELECT
	filme.Cod_Filme 'ID',
	filme.Nome_Filme 'Nome'
FROM Filmes filme
WHERE filme.Vl_Filme > (
	SELECT AVG(filme1.Vl_Filme)
	FROM Filmes filme1
	JOIN Categoria categoria ON (filme1.Cod_Categoria = categoria.Cod_Categoria)
    WHERE filme.Cod_Categoria = filme1.Cod_Categoria
);

/*
7) Listar o código, nome e sexo dos clientes que nunca locaram filmes estrangeiros
(cláusula exists/not exists).
*/
SELECT
	cliente.Cod_Cliente 'ID',
	cliente.Nome_Cliente 'Nome',
	cliente.Sexo 'Sexo'
FROM Clientes cliente
WHERE NOT EXISTS (
	SELECT 
		cliente.Cod_Cliente 'ID',
		cliente.Nome_Cliente 'Nome',
		cliente.Sexo 'Sexo'
	FROM Clientes cliente1
	JOIN Locacao locacao ON (locacao.Cod_Cliente = cliente1.Cod_Cliente)
	JOIN Filmes filme ON (locacao.Cod_Filme = filme.Cod_Filme)
	WHERE filme.Ind_Pais = 2
);

/*
8) Listar os clientes que já locaram filmes brasileiros (cláusula exists/not exists).
*/
SELECT *
FROM Clientes
WHERE EXISTS (
	SELECT *
	FROM Clientes cliente1
	JOIN Locacao locacao ON (locacao.Cod_Cliente = cliente1.Cod_Cliente)
	JOIN Filmes filme ON (locacao.Cod_Filme = filme.Cod_Filme)
	WHERE filme.Ind_Pais = 1
);

/*
9) Listar o código e nome dos clientes que nasceram antes do cliente Cláudio de
Souza. 
*/
SELECT *
FROM Clientes cliente
WHERE cliente.Dat_Nascimento < (
	SELECT cliente1.Dat_Nascimento
	FROM Clientes cliente1
	WHERE cliente1.Nome_Cliente = 'Cláudio de Souza'
);