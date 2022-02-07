/* 
1) Fazer uma consulta para mostrar quantos doadores são do tipo sanguíneo A, AB ou O.
*/
SELECT 
	COUNT(*) 'Doadores do tipo A, AB ou O'
FROM doador doad
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
WHERE tipoSanguineo.dscTpSang IN ('A', 'AB', 'B');

/* 
2) Fazer uma consulta para mostrar a quantidade de vezes que doaram sangue os doadores de sangue
Rh positivo do estado de São Paulo, Espírito Santo ou Minas Gerais.
*/
SELECT 
	COUNT(*) 'Quantidade de vezes doada'
FROM doacao doac
JOIN doador doad ON (doac.codDoador = doad.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
WHERE tipoSanguineo.RhTpSang = '+'
AND cidad.idUF IN ('SP', 'ES', 'MG');

/*
3) Listar a soma da quantidade de sangue doada por doador. Não listar os doadores que tenham (na
soma) doado menos de 350 ml nem que tenha doado antes de 2012.
*/
SELECT 
	doad.nomDoador 'Doador',
	SUM(doac.qtdSanDoacao) 'Total de sangue doado'
FROM doacao doac
JOIN doador doad ON (doad.codDoador = doac.codDoador)
WHERE EXTRACT(year FROM doac.datDoacao) >= 2012
GROUP BY doad.nomDoador HAVING(SUM(doac.qtdSanDoacao) >= 350);

/* 
4) Listar a quantidade de sangue doada por estado e por doador, para os doadores de Rh negativo.
*/
SELECT 
    cidad.idUF 'Estado', 
    doad.nomDoador 'Doador',
    SUM(doac.qtdSanDoacao) 'Total de sangue doado'
FROM doacao doac
JOIN doador doad ON (doac.codDoador = doad.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
WHERE tipoSanguineo.RhTpSang = '-'
GROUP BY cidad.idUF, doad.nomDoador;

/*
5) Listar a quantidade de doadores que doaram sangue entre 2015 e 2021, agrupados por cidade, que
sejam do tipo Sanguíneo A, B ou O.
*/
SELECT
	cidad.idUF 'Estado',
    COUNT(*) 'Quantidade de doadores entre 2015 e 2021 de tipo sanguíneo A, B ou O' 
FROM doador doad
JOIN doacao doac ON (doad.codDoador = doac.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
WHERE (EXTRACT(year FROM doac.datDoacao) BETWEEN 2015 AND 2021)
AND tipoSanguineo.dscTpSang IN ('A', 'B', 'O') 
GROUP BY cidad.idUF;

/*
6) Listar a média de sangue doado por Rh e por Tipo Sanguíneo, para os doadores de cidades que
tenham a letra ‘s’ no nome. Ordenar em ordem alfabética de cidade. Não listar médias menores ou
iguais a 300 ml.
*/
SELECT 
	tipoSanguineo.dscTpSang 'Tipo sanguíneo',
    tipoSanguineo.RhTpSang 'RH',
	AVG(doac.qtdSanDoacao) 'Média de sangue doado'
FROM doador doad
JOIN doacao doac ON (doad.codDoador = doac.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
JOIN UF uff ON (cidad.idUF = uff.idUF)
WHERE dscUF LIKE '%s%'
GROUP BY tipoSanguineo.dscTpSang, tipoSanguineo.RhTpSang HAVING(AVG(doac.qtdSanDoacao) > 300);

/*
7) Listar a média da quantidade de sangue doada por estado, mas somente os doadores de Rh
negativo.
*/
SELECT 
    cidad.idUF 'Estado', 
    AVG(doac.qtdSanDoacao) 'Média de sangue doada'
FROM doacao doac
JOIN doador doad ON (doac.codDoador = doad.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
WHERE tipoSanguineo.RhTpSang = '-'
GROUP BY cidad.idUF;

/*
8) Listar os dados de todos os doadores que doaram sangue nos meses de janeiro, fevereiro, novembro
e dezembro, cuja soma da quantidade doada tenha sido maior que 300 ml.
*/
SELECT 
	doad.codDoador 'ID',
	doad.nomDoador 'Nome',
	doad.idTipo 'ID do tipo sanguíneo',
	doad.idBairro 'ID do bairro'
FROM doacao doac
JOIN doador doad ON (doac.codDoador = doad.codDoador)
WHERE (EXTRACT(month FROM doac.datDoacao) IN (1, 12))
GROUP BY doad.codDoador, doad.nomDoador, doad.idTipo, doad.idBairro HAVING(SUM(doac.qtdSanDoacao) < 300);

/* 9) Listar a maior quantidade e menor quantidade de sangue doada por cidade. */
SELECT
	cidad.dscCidade 'Cidade',
	MIN(doac.qtdSanDoacao) 'Menor quantidade de sangue doada',
	MAX(doac.qtdSanDoacao) 'Maior quantidade de sangue doada'
FROM doacao doac
JOIN doador doad ON (doac.codDoador = doad.codDoador)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
GROUP BY cidad.dscCidade;

/* 
10) Listar a média da quantidade de sangue doada por tipo sanguíneo. Não listar as médias menores
que 300 ml.
*/
SELECT 
    tipoSanguineo.dscTpSang 'Tipo',
    AVG(doac.qtdSanDoacao) 'Média'
FROM doacao doac
JOIN doador doad ON (doac.codDoador = doad.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
WHERE tipoSanguineo.RhTpSang = '-'
GROUP BY tipoSanguineo.dscTpSang HAVING(AVG(doac.qtdSanDoacao) >= 300);