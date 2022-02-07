/* 1. Listar a matrícula e nome do responsável, o nome, a data de nascimento e sexo dos dependentes
cujos responsáveis ganham entre R$ 2.000,00 e R$ 5.000,00 e cujos dependentes sejam do sexo
masculino. Ordenar por nome do responsável. */
SELECT 
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado',
	depend.nomDepend 'Dependente',
	depend.datNascDepend 'Data de nascimento',
	depend.indSexoDepend 'Sexo do dependente'
FROM Empregado empr
JOIN Dependente depend ON (empr.idEmprg = depend.idEmprg)
WHERE 
	(empr.valSalEmprg BETWEEN 2000 AND 5000) AND (depend.indSexoDepend = 'M')
ORDER BY empr.nomEmprg;

/* 2. Listar a matrícula e nomes dos empregados, o nome do projeto cuja localização seja no Espírito
Santo ou São Paulo e que tenha mais de 80 horas de projeto. Ordenar em ordem decrescente de horas
de projeto. */
SELECT 
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado',
	proj.dscProj 'Projeto'
FROM Empregado empr
JOIN EmprProjeto emprProj ON (empr.idEmprg = emprProj.idEmprg)
JOIN Projeto proj ON (emprProj.idProj = proj.idProj)
JOIN Localizacao loc ON (loc.idLocal = proj.idLocal)
WHERE 
	(loc.idLocal IN (1, 4)) AND (emprProj.qtdHorasEmprProj > 80)
ORDER BY emprProj.qtdHorasEmprProj DESC;

/* 3. Listar a matrícula e nome dos empregados e quanto ganhavam os empregados em ‘05/05/2017’. */
SELECT 
	empr.idEmprg 'Matricula',
	empr.nomEmprg 'Empregado',
	histSal.valSalHistSal 'Salário'
FROM Empregado empr
JOIN HistoricoSalario histSal ON (empr.idEmprg = histSal.idEmprg)
WHERE '2017/05/05' BETWEEN histSal.DatIniHistSal AND histSal.DatFimHistSal;

/* 4. Listar a matrícula e nome do empregado e código e nome do departamento que trabalha, para os
departamentos que não tem gerentes. */
SELECT 
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado',
	depto.idDepto 'Código do departamento',
	depto.dscDepto 'Departamento'
FROM Empregado empr
JOIN Departamento depto ON (empr.idDepto = depto.idDepto)
WHERE depto.idGerEmprg IS NULL;

/* 5. Fazer uma consulta para listar os projetos com mais de 90 horas. Listar em ordem de código do
projeto. */
SELECT *
FROM Projeto proj
JOIN EmprProjeto emprProj ON (proj.idProj = emprProj.idProj)
WHERE emprProj.qtdHorasEmprProj > 90
ORDER BY emprProj.qtdHorasEmprProj;

# 6. Consultar as matrículas e nomes dos empregados que têm a letra ‘r’ no nome e cujo dependente
# seja do sexo masculino e que tenha nascido entre os anos de 2010 e 2020.
SELECT 
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado'
FROM Empregado empr
JOIN Dependente depend ON (empr.idEmprg = depend.idEmprg)
WHERE 
	(empr.nomEmprg LIKE '%r%') AND (depend.indSexoDepend = 'M' AND (EXTRACT(year FROM depend.datNascDepend) BETWEEN 2010 AND 2020));

/* 7. Listar o código, nome do departamento e nomes dos projetos localizados em Brasília, São Paulo
ou Espírito Santo. Ordenar por nome de departamento. */
SELECT
	depto.idDepto 'Código do departamento',
	depto.dscDepto 'Departamento',
	proj.dscProj 'Projeto'
FROM Departamento depto
JOIN DeptoProjeto deptoProj ON (depto.idDepto = deptoProj.idDepto)
JOIN Projeto proj ON (deptoProj.idProj = proj.idProj)
JOIN Localizacao loc ON (proj.idLocal = loc.idLocal)
WHERE loc.idLocal IN (1, 4, 5)
ORDER BY depto.dscDepto;

/* 8.
Listar os nomes dos empregados que tem dependentes. Não listar linhas repetidas. */
SELECT DISTINCT empr.nomEmprg
FROM Empregado empr
JOIN Dependente depend ON (empr.idEmprg = depend.idEmprg);

/* 9. Listar o número e nome dos departamentos e os nomes dos seus gerentes. Ordenar por nome de
departamento. */
SELECT
    depto.idDepto 'Código do departamento',
    depto.dscDepto 'Departamento',
    empr.nomEmprg 'Gerente'
FROM Departamento depto
JOIN Empregado empr ON (depto.idGerEmprg = empr.idEmprg)
WHERE idGerEmprg IS NOT NULL;

/* 10. Liste a matrícula, o nome dos empregados, a quantidade de horas e os nomes dos projetos dos
empregados que recebem acima de R$ 4.000,00 e que tem supervisor. Ordenar em ordem decrescente
de quantidade de horas. */
SELECT
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado',
	emprProj.qtdHorasEmprProj 'Quantidade de horas',
	proj.dscProj 'Projeto'
FROM Empregado empr
JOIN EmprProjeto emprProj ON (empr.idEmprg = emprProj.idEmprg)
JOIN Projeto proj ON (emprProj.idProj = proj.idProj)
WHERE
	empr.valSalEmprg > 4000 AND empr.idSupervEmprg IS NOT NULL;

/* 11. Listar os nomes dos empregados que envolvidos em projetos. Não listar linhas repetidas. */
SELECT DISTINCT empr.nomEmprg
FROM Empregado empr
JOIN EmprProjeto emprProj ON (empr.idEmprg = emprProj.idEmprg)
JOIN Projeto proj ON (emprProj.idProj = proj.idProj);

/* 12. Mostre os códigos e nomes dos projetos envolvidos com os departamentos de Contabilidade e de
Custos. Não listar linhas repetidas. */
SELECT DISTINCT
	proj.idProj 'Código do projeto',
	proj.dscProj 'Projeto'
FROM Departamento depto
JOIN DeptoProjeto deptoProj ON (depto.idDepto = deptoProj.idDepto)
JOIN Projeto proj ON (deptoProj.idProj = proj.idProj)
WHERE depto.idDepto IN (2, 3);

/* 13. Liste a matrícula e nome dos empregados dos departamentos ‘Recursos Humanos’, ‘Custos’ ou
‘Terraplanagem’. Ordenar em ordem crescente de matrícula. */
SELECT
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado'
FROM Empregado empr
JOIN Departamento depto ON (empr.idDepto = depto.idDepto)
WHERE depto.idDepto IN (1, 3, 4)
ORDER BY empr.idEmprg;

/* 14. Mostre o nome dos dependentes do sexo masculino dos empregados que trabalham no
departamento ‘Terraplanagem’, ‘Custos’ e ‘Oficina de Projetos’. */
SELECT depend.nomDepend 'Dependente'
FROM Dependente depend
JOIN Empregado empr ON (depend.idEmprg = empr.idEmprg)
JOIN Departamento depto ON (empr.idDepto = depto.idDepto)
WHERE depend.indSexoDepend = 'M' AND depto.idDepto IN (3, 4, 5);

/* 15. Liste os nomes dos dependentes, dos empregados e dos projetos dos empregados que ganham
acima de R$ 5.000,00 e que trabalham nos projetos ‘Desenvolvimento de Projetos de Venda’,
‘Levantamento de Dados Estatísticos’, ‘Montagem de Estruturas Pesadas’. */
SELECT
	depend.nomDepend 'Dependente',
	empr.nomEmprg 'Empregado',
	proj.dscProj 'Projeto'
FROM Dependente depend
JOIN Empregado empr ON (depend.idEmprg = empr.idEmprg)
JOIN EmprProjeto emprProj ON (empr.idEmprg = emprProj.idEmprg)
JOIN Projeto proj ON (emprProj.idProj = proj.idProj)
WHERE (empr.valSalEmprg > 5000) AND (proj.idProj IN (10, 40, 50));

/* 16. Liste a matrícula e nome dos empregados que tem dependentes do sexo feminino e cuja relação de
dependência seja ‘Filho(a)’ e ‘Mãe’. */
SELECT
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado'
FROM Empregado empr
JOIN Dependente depend ON (depend.idEmprg = empr.idEmprg)
WHERE depend.indSexoDepend = 'F' AND depend.idDepdc IN (1, 5);

/* 17. Liste os códigos e nomes dos departamentos e matrícula e nomes dos gerentes que ganham acima
de R$ 4.500,00. */
SELECT
	depto.idDepto 'Código do departamento',
	depto.dscDepto 'Departamento',
	empr.valSalEmprg 'Salario gerente'
FROM Departamento depto
JOIN Empregado empr ON (depto.idGerEmprg = empr.idEmprg)
WHERE empr.valSalEmprg > 4500;

/* 18. Liste os empregados cujos dependentes são filhos(as) do sexo masculino e cujos projetos em que
trabalham estejam localizados em São Paulo ou Brasília. */
SELECT empr.*
FROM Dependente depend
JOIN Empregado empr ON (depend.idEmprg = empr.idEmprg)
JOIN EmprProjeto emprProj ON (empr.idEmprg = emprProj.idEmprg)
JOIN Projeto proj ON (emprProj.idProj = proj.idProj)
WHERE (depend.indSexoDepend = 'M' AND depend.idDepdc = 1) AND (proj.idLocal IN (1, 5));

/* 19. Listar a matrícula, nome e salário atual dos empregados que tem histórico de salário há mais de 5
anos (tomar como base a data início de salário). */
SELECT DISTINCT
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado',
	empr.valSalEmprg 'Salário atual'
FROM Empregado empr
JOIN HistoricoSalario histSal ON (empr.idEmprg = histSal.idEmprg)
WHERE 
(EXTRACT(year FROM current_date()) - EXTRACT(year FROM DatIniHistSal)) > 5;

/* 20. Listar a matrícula e nome do empregado, o nome do dependente, a quantidade de horas em que o
empregado está envolvido nos projetos localizados em São Paulo, Brasília, Espírito Santo ou Rio de
Janeiro. */
SELECT DISTINCT
	empr.idEmprg 'Matrícula',
	empr.nomEmprg 'Empregado',
	depend.nomDepend 'Dependente',
	emprProj.qtdHorasEmprProj 'Quantidade de horas'
FROM Dependente depend
JOIN Empregado empr ON (depend.idEmprg = empr.idEmprg)
JOIN EmprProjeto emprProj ON (empr.idEmprg = emprProj.idEmprg)
JOIN Projeto proj ON (emprProj.idProj = proj.idProj)
JOIN Localizacao loc ON (proj.idLocal = loc.idLocal)
WHERE loc.idLocal IN (1, 3, 4, 5);