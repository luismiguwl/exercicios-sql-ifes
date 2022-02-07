/*
1) Criar uma view para mostrar a soma da quantidade de sangue doada por doador, para os
doadores do tipo A positivo.
*/
DROP VIEW quantidadeDeSangueAPositivoPorDoador;
CREATE VIEW quantidadeDeSangueAPositivoPorDoador (doador, quantidadeDoada) AS
SELECT 
	doad.nomDoador 'Doador',
	SUM(doac.qtdSanDoacao) 'Quantidade doada'
FROM doacao doac
JOIN doador doad ON (doad.codDoador = doac.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
WHERE tipoSanguineo.RhTpSang = '+' AND tipoSanguineo.dscTpSang = 'A'
GROUP BY doad.nomDoador;

/*
2) Criar uma view para selecionar o estado que menos doou sangue na soma da quantidade
de sangue doada (mas que tenha doado) do tipo A, AB ou B.
*/
DROP VIEW quantidadeDeDoacoesDoTipoAxABxBPorEstado;
CREATE VIEW quantidadeDeDoacoesDoTipoAxABxBPorEstado (uf, quantidadeDoada) AS
SELECT 
	cidad.idUF,
	SUM(doac.qtdSanDoacao)
FROM doacao doac
JOIN doador doad ON (doad.codDoador = doac.codDoador)
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
WHERE tipoSanguineo.dscTpSang IN ('A', 'AB', 'B')
GROUP BY cidad.idUF
ORDER BY SUM(doac.qtdSanDoacao);

DROP VIEW estadoQueMenosDoouSangueTipoAxABxB;
CREATE VIEW estadoQueMenosDoouSangueTipoAxABxB AS
SELECT cidad.idUF 'Estado que menos doou'
FROM doador doad
JOIN doacao doac ON (doad.codDoador = doac.codDoador)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
GROUP BY cidad.idUF HAVING(SUM(qtdSanDoacao) = (
	SELECT MIN(quantidadeDoada)
	FROM quantidadeDeDoacoesDoTipoAxABxBPorEstado
));

/*
3) Criar uma view para selecionar a quantidade de doadores por ano.
*/
DROP VIEW doadoresPorAno;
CREATE VIEW doadoresPorAno (ano, quantidade) AS
SELECT 
	EXTRACT(year FROM doac.datDoacao) 'Ano',
	COUNT(*) 'Doadores'
FROM doador doad
JOIN doacao doac ON (doad.codDoador = doac.codDoador)
GROUP BY EXTRACT(year FROM doac.datDoacao)
ORDER BY EXTRACT(year FROM doac.datDoacao);

/*
4) Criar uma view para listar a quantidade de doadores por Rh, para os doadores que não
sejam do estado de São Paulo ou Bahia.
*/
DROP VIEW doadoresPorRhQueNaoSaoDeSPOuBH;
CREATE VIEW doadoresPorRhQueNaoSaoDeSPOuBH (rh, quantidade) AS
SELECT
	tipoSanguineo.RhTpSang 'RH',
	COUNT(*) 'Doadores'
FROM doador doad
JOIN TpSang tipoSanguineo ON (doad.idTipo = tipoSanguineo.idTpSang)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
WHERE cidad.idUF NOT IN ('SP', 'BA')
GROUP BY tipoSanguineo.RhTpSang;

/*
5) Calcular os doadores que tenham doado menos sangue do que a média de doadores do
seu estado.

INCOMPLETA! AINDA TENHO DUVIDAS
*/
DROP VIEW mediaDeSangueDoadoPorEstado;
CREATE VIEW mediaDeSangueDoadoPorEstado (uf, quantidade) AS
SELECT
	cidad.idUF 'Estado',
	AVG(doac.qtdSanDoacao)
FROM doacao doac
JOIN doador doad ON (doad.codDoador = doac.codDoador)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
GROUP BY cidad.idUF
ORDER BY AVG(doac.qtdSanDoacao);

DROP VIEW doadoresQueDoaramMenosQueAMediaDoSeuEstado;
CREATE VIEW doadoresQueDoaramMenosQueAMediaDoSeuEstado (id, nome, quantidadeDoada) AS
SELECT DISTINCT
	doad.codDoador 'ID doador',
	doad.nomDoador 'Nome',
	doac.qtdSanDoacao 'Quantidade'
FROM doacao doac
JOIN doador doad ON (doad.codDoador = doac.codDoador)
JOIN Bairro bairr ON (doad.idBairro = bairr.idBairro)
JOIN Cidade cidad ON (bairr.idCidade = cidad.idCidade)
JOIN UF uff ON (cidad.idUF = uff.idUF)
WHERE doac.qtdSanDoacao < (
	SELECT quantidade
    FROM mediaDeSangueDoadoPorEstado
    WHERE uf = uff.idUF
);