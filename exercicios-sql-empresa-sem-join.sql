/* 1. Mostre a matrícula (idEmprg), nome e CPF dos empregados que foram admitidos antes de 2015
(utilizar função extract). */
SELECT 
	idEmprg 'Matricula',
	nomEmprg 'Nome',
	numCPFEmprg 'CPF'
FROM Empregado
WHERE EXTRACT(year FROM datAdmsEmprg) < 2015;

/* 2. Mostre a matrícula (idEmprg), nome e código de departamento dos empregados que foram
admitidos entre 2016 e 2020 e que recebem salário maior que R$ 4.000,00. */
SELECT 
	idEmprg 'Matricula',
	nomEmprg 'Nome',
	idDepto 'ID do Departamento'
FROM Empregado
WHERE EXTRACT(year FROM datAdmsEmprg) IN (2016, 2020)
AND valSalEmprg > 4000;

/* 3. Mostre a matrícula (idEmprg), nome e data de admissão dos empregados que recebem salário desde
a data de admissão (Verificar se a data de admissão é igual a data início de salário). Ordenar em ordem
crescente de data de admissão.  */
SELECT 
	idEmprg 'Matricula',
	nomEmprg 'Nome',
	datAdmsEmprg 'Data de admissão'
FROM Empregado
WHERE datAdmsEmprg = datIniSalEmprg
ORDER BY datIniSalEmprg;	

/* 4. Selecionar a matrícula, data início de salário e salário de todos os empregados que tem histórico de
salário anteriores a ‘01/05/2017’ (verificar data início de salário da tabela HistoricoSalario). */
SELECT DISTINCT 
	Empregado.idEmprg 'Matricula',
    Empregado.DatIniSalEmprg 'Data inicial de salário',
    Empregado.valSalEmprg 'Salário'
FROM Empregado, HistoricoSalario
WHERE Empregado.idEmprg = HistoricoSalario.idEmprg
AND HistoricoSalario.DatIniHistSal < '2017/05/01';

/* 5. Mostre a matrícula do empregado, o nome dos dependentes que têm mais de 8 anos (Subtrair o ano
atual do ano de nascimento). Ordenar por matrícula do empregado - utilizar current_date() e função
extract */
SELECT 
	idEmprg 'Matricula do titular',
	nomDepend 'Dependente'
FROM Dependente
WHERE 
(EXTRACT(year FROM current_date()) - EXTRACT(year FROM datNascDepend)) > 8;

/* 6. Mostre a matrícula, o nome e o salário de todos os empregados que ganham menos de R$ 3000,00.
Ordenar em ordem decrescente de salário. */
SELECT 
	idEmprg 'Matricula',
	nomEmprg 'Nome',
	valSalEmprg 'Salário'
FROM Empregado
WHERE valSalEmprg < 3000
ORDER BY salario DESC;

/* 7. Mostre a matrícula do empregado, o código e nome dos dependentes do sexo masculino que
nasceram antes de 2010 ou após 2013. */
SELECT 
	idEmprg 'Matricula do titular',
	idDepend 'ID do Dependente',
	nomDepend 'Dependente'
FROM Dependente
WHERE indSexoDepend = 'M'
AND 
	EXTRACT(year FROM datNascDepend) < 2010 or
	EXTRACT(year FROM datNascDepend) > 2013;

/* 8. Liste o código e nome de todas as localizações que contém a letra ‘p’. */
SELECT 
	idLocal 'ID local',
	dscLocal 'Local'
FROM Localizacao
WHERE dscLocal LIKE '%p%';

/* 9. Listar a matrícula do empregado, o código e nome de todos os dependentes do sexo feminino que
começam com vogal e cujo código da dependência está entre 1 e 3. */
SELECT 
	idEmprg 'Matricula',
	idDepend 'ID do Dependente',
	nomDepend 'Dependente'
FROM Dependente
WHERE
	(indSexoDepend = 'F' AND 
	idDepdc IN (1, 3)) AND
	(nomDepend LIKE 'a%' OR
	nomDepend LIKE 'e%' OR
	nomDepend LIKE 'i%' OR
	nomDepend LIKE 'o%' OR
	nomDepend LIKE 'u%');

/* 10. Liste o nome e ano de nascimento dos dependentes que nasceram em meses pares e anos ímpares. */
SELECT 
	nomDepend 'Dependente',
EXTRACT(year FROM datNascDepend)
FROM Dependente
WHERE 
	EXTRACT(month FROM datNascDepend) % 2 = 0 AND 
	EXTRACT(year FROM datNascDepend) % 2 != 0;
    
/* 11. Liste o número, o nome dos projetos e matrícula dos empregados que têm mais de 50 horas de
projeto. Ordenar em ordem crescente de matrícula do empregado. */
SELECT
	EmprProjeto.idProj 'Número do projeto',
	Projeto.dscProj 'Projeto',
    EmprProjeto.idEmprg 'Matrícula do empregado'
FROM EmprProjeto, Projeto
WHERE EmprProjeto.qtdHorasEmprProj > 50
ORDER BY EmprProjeto.idEmprg;

/* 12. Listar todos os dados da tabela departamento que tem gerente. */
SELECT *
FROM Departamento
WHERE idGerEmprg IS NOT NULL;

/* 13. Listar a matrícula, o nome e data de admissão dos empregados que não tem supervisor. Ordenar
em ordem decrescente de data de admissão. */
SELECT 
	idEmprg 'Matricula',
	nomEmprg 'Nome',
	datAdmsEmprg 'Data de admissão'
FROM Empregado
WHERE idSupervEmprg IS NULL
ORDER BY datAdmsEmprg;

/* 14. Listar os dados dos departamentos que estão relacionados aos projetos 10, 40 ou 50. */
SELECT Departamento.*
FROM Departamento, DeptoProjeto
WHERE DeptoProjeto.idDepto = Departamento.idDepto AND DeptoProjeto.idProj IN (10, 40, 50);

/* 15. Listar o nome, data de nascimento e sexo dos dependentes que tem a letra ‘a’ na segunda posição
do nome. */
SELECT 
	nomDepend 'Dependente', 
	datNascDepend 'Data de nascimento', 
	indSexoDepend 'Sexo'
FROM Dependente
WHERE nomDepend LIKE '_a%';