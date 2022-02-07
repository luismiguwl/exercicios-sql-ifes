/*
1) Acrescentar 10 (dez) níveis (coluna nivel_cargo) aos empregados que são chefes de alguma
lotação e 8 (oito) níveis para os empregados que não são chefes (para verificar os chefes, verificar
a coluna matr_chefe na tabela Lotacao).

Obs.: Se ao acrescentar essa quantidade de níveis, ultrapassar o nível máximo do cargo
(nivel_maximo), não atualizar os dados desse empregado, independente se são ou não chefes.
*/
DROP TABLE IF EXISTS empregadosQueSaoChefes;
CREATE TABLE empregadosQueSaoChefes (
	SELECT MATRICULA
	FROM empregados
	JOIN lotacao ON MATRICULA = MATR_CHEFE
);

UPDATE empregados empregado
JOIN cargos cargo ON empregado.ID_CARGO = cargo.ID_CARGO
SET empregado.NIVEL_CARGO = empregado.NIVEL_CARGO + 10
WHERE MATRICULA IN (
	SELECT matricula FROM empregadosQueSaoChefes
) AND (empregado.NIVEL_CARGO + 10) <= cargo.NIVEL_MAXIMO;

UPDATE empregados empregado
JOIN cargos cargo ON empregado.ID_CARGO = cargo.ID_CARGO
SET empregado.NIVEL_CARGO = empregado.NIVEL_CARGO + 8
WHERE MATRICULA NOT IN (
	SELECT matricula FROM empregadosQueSaoChefes
) AND (empregado.NIVEL_CARGO + 8) <= cargo.NIVEL_MAXIMO;

DROP TABLE IF EXISTS empregadosQueSaoChefes;

/*
2) Incluir na tabela Cargos duas colunas, denominadas min_salario e max_salario, ambas do tipo
decimal (10,2) null, e preencher com os seguintes conteúdos, calculados do seguinte modo:
- min_salario = nivel_minimo * 7, se o cargo for de chefia (verificar na coluna descricao na tabela
cargos, se aparece o seguinte: diretor, gerente, chefe, presidente);
- min_salario = nivel_minimo * 5, se o cargo não for de chefia;
- max_salario = nivel_maximo * 8, se o cargo for de chefia (verificar na coluna descricao na tabela
cargos, se aparece o seguinte: diretor, gerente, chefe, presidente);
- max_salario = nivel_maximo * 6, se o cargo não for de chefia; 
*/
ALTER TABLE cargos
ADD MIN_SALARIO DECIMAL(10, 2) NULL,
ADD MAX_SALARIO DECIMAL(10, 2) NULL;

CREATE TABLE cargosDeChefia (
	SELECT DESCRICAO
	FROM cargos
	WHERE DESCRICAO LIKE '%Diretor%'
	OR DESCRICAO LIKE '%Gerente%'
	OR DESCRICAO LIKE '%Chefe%'
	OR DESCRICAO LIKE '%Presidente%'
);

UPDATE cargos
SET MIN_SALARIO = NIVEL_MINIMO * 7
WHERE DESCRICAO IN (
	SELECT * FROM cargosDeChefia
);

UPDATE cargos
SET MIN_SALARIO = NIVEL_MINIMO * 5
WHERE DESCRICAO NOT IN (
	SELECT * FROM cargosDeChefia
);

UPDATE cargos
SET MAX_SALARIO = NIVEL_MAXIMO * 8
WHERE DESCRICAO IN (
	SELECT * FROM cargosDeChefia
);

UPDATE cargos
SET MAX_SALARIO = NIVEL_MAXIMO * 6
WHERE DESCRICAO NOT IN (
	SELECT * FROM cargosDeChefia
);

DROP TABLE IF EXISTS cargosDeChefia;

/*
3) Incluir uma coluna na tabela Empregados, denominado salario, do tipo decimal (10,2) e incluir
nessa coluna o valor do salário, calculado da seguinte forma:
𝑠𝑎𝑙𝑎𝑟𝑖𝑜 = 𝑥𝑚𝑖𝑛 + (𝑥𝑚𝑎𝑥 − 𝑥𝑚𝑖𝑛) ∗ (𝑦𝑐 − 𝑦𝑚𝑖𝑛)/(𝑦𝑚𝑎𝑥 − 𝑦𝑚𝑖𝑛)
onde:
xmin – min_salario yc – nivel_cargo
xmax – max_salario ymin – nivel_minimo
ymax – nivel_maximo
Obs.: Empregados que tiverem o seu nível menor que o nível mínimo, o salário será calculado da
seguinte forma:
salario = xmin; 
*/

ALTER TABLE empregados
ADD SALARIO DECIMAL(10, 2);

UPDATE empregados empregado
JOIN cargos cargo ON cargo.ID_CARGO = empregado.ID_CARGO
SET empregado.SALARIO = cargo.MIN_SALARIO + (cargo.MAX_SALARIO - cargo.MIN_SALARIO) * (empregado.NIVEL_CARGO - cargo.NIVEL_MINIMO) / (cargo.NIVEL_MAXIMO - cargo.NIVEL_MINIMO)
WHERE empregado.NIVEL_CARGO >= cargo.NIVEL_MINIMO;

UPDATE empregados empregado
JOIN cargos cargo ON cargo.ID_CARGO = empregado.ID_CARGO
SET empregado.SALARIO = cargo.MIN_SALARIO
WHERE empregado.NIVEL_CARGO < cargo.NIVEL_MINIMO;

/*
4) Incluir uma coluna denominada total_empr do tipo integer na tabela Editoras, e preencher com a
quantidade de empregados que tem cada editora. 
*/

CREATE TABLE quantidadeDeFuncionariosPorEditora (
	SELECT
		editora.ID_EDITORA,
		COUNT(*) as QUANTIDADE
	FROM editoras editora
	JOIN empregados empregado ON empregado.ID_EDITORA = editora.ID_EDITORA
	GROUP BY editora.ID_EDITORA
);

ALTER TABLE editoras
ADD TOTAL_EMPR INT;

UPDATE editoras editora
JOIN quantidadeDeFuncionariosPorEditora qtd ON editora.ID_EDITORA = qtd.ID_EDITORA 
SET TOTAL_EMPR = qtd.QUANTIDADE;

DROP TABLE quantidadeDeFuncionariosPorEditora;

/*
5) Fazer uma consulta para mostrar quantos títulos não tem autores. Após a consulta, excluir todos
os títulos sem autor. 
*/
CREATE TABLE titulosSemAutores (
	SELECT titulo.TITULO_LIVRO, titulo.ID_TITULO
	FROM titulos titulo
	WHERE titulo.ID_TITULO NOT IN (
		SELECT autori.ID_TITULO
		FROM autoria autori
	)
);

DELETE titulo
FROM titulos titulo
WHERE titulo.ID_TITULO IN (
	SELECT titulo1.ID_TITULO
	FROM titulosSemAutores titulo1
);

DROP TABLE titulosSemAutores;

/*
6) Fazer uma consulta para mostrar quantos autores não tem títulos. Após a consulta, excluir todos
os autores sem títulos.
*/
CREATE TABLE autoresSemTitulos (
	SELECT autor.ID_AUTOR, autor.NOME
	FROM autores autor
	WHERE autor.ID_AUTOR NOT IN (
		SELECT autori.ID_AUTOR
		FROM autoria autori
	)
);

DELETE autor
FROM autores autor
WHERE autor.ID_AUTOR NOT IN (
	SELECT autori.ID_AUTOR
	FROM autoria autori
);

DROP TABLE autoresSemTitulos;

/*
7) Devido à pandemia, algumas editoras precisarão suspender o contrato de alguns empregados.
Criar uma coluna denominada datSuspContrato do tipo date null, na tabela Empregados. Atualizar
a coluna com atribuindo a data corrente (current_date()) a essa coluna, apenas para os empregados
cuja coluna nivel_cargo seja maior ou igual a 180. 
*/
ALTER TABLE empregados
ADD DAT_SUSP_CONTRATO DATE NULL;

UPDATE empregados empregado
JOIN cargos cargo ON cargo.ID_CARGO = empregado.ID_CARGO
SET DAT_SUSP_CONTRATO = CURRENT_DATE()
WHERE empregado.NIVEL_CARGO >= 180;

/*
8) A coluna royalty da tabela Titulos está relacionada à coluna royalty da tabela faixa_royalty com
o mesmo id_titulo, ou seja, na tabela Titulos está o royalty atual daquele título, enquanto na tabela
Faixa_royalty estão todos os possíveis royalties que um título pode receber. Por exemplo:
Tabela Titulos Tabela Faixa_royalty
id_titulo royalty id_titulo royalty
1032 10 1032 10
1035 16 1035 16
Observar que a tabela faixa_royalty contém diversas linhas para o mesmo título, no entanto, somente
uma linha tem o royalty igual ao da tabela Titulos. Assim, a partir das informações acima, excluir
todas as linhas da tabela faixa_royalty cujas colunas id_titulo são iguais, mas a coluna royalty sejam
diferentes. 
*/
DELETE faixa
FROM faixa_royalty faixa
JOIN titulos titulo ON faixa.ID_TITULO = titulo.ID_TITULO
WHERE faixa.ROYALTY != titulo.ROYALTY;