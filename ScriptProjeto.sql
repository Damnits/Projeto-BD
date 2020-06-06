CREATE TABLE FUNCIONARIO(
	registro INT identity PRIMARY KEY,
	cpf CHAR(11) UNIQUE NOT NULL,
	nome VARCHAR(100) NOT NULL,
	cidade VARCHAR(50) NOT NULL,
	bairro VARCHAR(50) NOT NULL,
	rua VARCHAR(50) NOT NULL,
	numero INT NOT NULL,
	CONSTRAINT CK_funcionario_cpf 
	CHECK(cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

CREATE TABLE PRODUTO(
	registroprod INT identity PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	valorunitario FLOAT NOT NULL 
)

CREATE TABLE CLIENTE(
	codcliente INT identity PRIMARY KEY,
	cpf CHAR(11) UNIQUE NOT NULL,
	nome VARCHAR(100) NOT NULL,
	cidade VARCHAR(50) NOT NULL,
	bairro VARCHAR(50) NOT NULL,
	rua VARCHAR(50) NOT NULL,
	numero INT NOT NULL,
	CONSTRAINT CK_cliente_cpf 
	CHECK(cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)
CREATE TABLE EMPRESA_TERCEIRIZADA(
	CNPJ CHAR(14) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	CONSTRAINT CK_empresaterc_CNPJ
	CHECK(CNPJ LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)
CREATE TABLE EMPRESA_MATRIZ(
	CNPJ CHAR(14) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	cidade VARCHAR(50) NOT NULL,
	bairro VARCHAR(50) NOT NULL,
	rua VARCHAR(50) NOT NULL,
	numero INT NOT NULL,
	CONSTRAINT CK_empresamatr_CNPJ
	CHECK(CNPJ LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)
CREATE TABLE CONTRATO(
	cod_contrato Int identity Primary key,
	data date not null,
	valorcontrato int not null
)
CREATE TABLE DEPENDENTE(
	cpf CHAR(11) PRIMARY KEY,
	nome varchar(100) not null,
	registro int not null,
	foreign key (registro) references FUNCIONARIO(registro),
	CONSTRAINT CK_dependente_cpf 
	CHECK(cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),

)
CREATE TABLE FUNCIONARIO_DE_SERVICO(
	registro INT primary key,
	registro_gerencia INT null,
	CNPJ_empresa CHAR(14),
	datacontrata DATE not null,
	datagerencia DATE null,
	foreign key (registro) references FUNCIONARIO(registro),
	foreign key (registro_gerencia) references FUNCIONARIO_DE_SERVICO(registro),
	foreign key (CNPJ_empresa) references EMPRESA_TERCEIRIZADA(CNPJ)
)



CREATE TABLE FUNCIONARIO_DE_LOJA(
	registro INT PRIMARY KEY,
	cod_filial_fk INT null,
	funcao varchar(40) not null,
	datacontrata date not null,
	FOREIGN KEY (registro) references FUNCIONARIO(registro),
	FOREIGN KEY(cod_filial_fk) references LOJA(cod_filial)

)
CREATE TABLE LOJA(
	cod_filial int identity PRIMARY KEY,
	nome varchar(40) NOT NULL UNIQUE,
	CNPJ CHAR(14) not null unique,
	registro_gerente INT null,
	datainicio DATE null,
	datafim DATE null,
	CONSTRAINT CK_loja_CNPJ
	CHECK(CNPJ LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT FK_loja
		FOREIGN KEY(registro_gerente) REFERENCES FUNCIONARIO_DE_LOJA(registro)
)



CREATE TABLE ALUGUEL(
	CNPJ_empresa_matriz CHAR(14) NOT NULL,
	loja_cod_filial INT not null ,
	CONTRATO_cod_contrato INT not null,
	duracao smallint not null,
	CONSTRAINT PK_aluguel PRIMARY KEY(CNPJ_empresa_matriz,loja_cod_filial,CONTRATO_cod_contrato),
	CONSTRAINT FK_CNPJ_empresa_matriz FOREIGN KEY (CNPJ_empresa_matriz) REFERENCES EMPRESA_MATRIZ(CNPJ),
	CONSTRAINT FK_cod_filial_LOJA FOREIGN KEY (loja_cod_filial) REFERENCES LOJA(cod_filial),
	CONSTRAINT FK_contrato_cod_contrato FOREIGN KEY(CONTRATO_cod_contrato) REFERENCES CONTRATO(cod_contrato)
	)
CREATE TABLE ATENDE(
	FUNCIONARIO_DE_LOJA_registro int not null,
	CLIENTE_codcliente int not null,
	datahora DATETIME not null,
	CONSTRAINT PK_atende PRIMARY KEY (FUNCIONARIO_DE_LOJA_registro, CLIENTE_codcliente, datahora),
	CONSTRAINT FK_codcliente FOREIGN KEY (CLIENTE_codcliente) REFERENCES CLIENTE(codcliente),
	CONSTRAINT FK_FUNCIONARIO_DE_LOJA FOREIGN KEY (FUNCIONARIO_DE_LOJA_registro) REFERENCES FUNCIONARIO_DE_LOJA(registro)
)
CREATE TABLE VENDE(
	PRODUTO_registroprod int not null,
	ATENDE_datahora DATETIME not null,
	ATENDE_registro_funcionario int not null,
	ATENDE_codcliente int not null,
	quantprodu INT not null,
	valortotal FLOAT null,
)
ALTER TABLE VENDE ADD CONSTRAINT PK_VENDE PRIMARY KEY(PRODUTO_registroprod, ATENDE_datahora, ATENDE_registro_funcionario, ATENDE_codcliente)
ALTER TABLE VENDE ADD CONSTRAINT FK_PRODUTO FOREIGN KEY (PRODUTO_registroprod) REFERENCES PRODUTO(registroprod)
ALTER TABLE VENDE ADD CONSTRAINT FK_ATENDE_1 FOREIGN KEY (ATENDE_registro_funcionario) REFERENCES ATENDE(FUNCIONARIO_DE_LOJA_registro)
ALTER TABLE VENDE ADD CONSTRAINT FK_ATENDE_2 FOREIGN KEY (ATENDE_codcliente) REFERENCES ATENDE(CLIENTE_codcliente)
ALTER TABLE VENDE ADD CONSTRAINT FK_ATENDE_3 FOREIGN KEY (ATENDE_datahora) REFERENCES ATENDE(datahora)

ALTER TABLE VENDE DROP CONSTRAINT FK_PRODUTO

CREATE TABLE PRODUTO(
	registroprod INT identity PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	valorunitario FLOAT NOT NULL
	CONSTRAINT CK_valor_unitario
	CHECK(valorunitario > 0)
)
CREATE TABLE TELEFONE_EMPRESA_TERCEIRIZADA(
	telefone CHAR(13) ,
	EMPRESA_TERCEIRIZADA_CNPJ CHAR(14),
	CONSTRAINT PK_telefone_emp_terc PRIMARY KEY (telefone, EMPRESA_TERCEIRIZADA_CNPJ),
	CONSTRAINT FK_telefone_emp_terc FOREIGN KEY(EMPRESA_TERCEIRIZADA_CNPJ) references EMPRESA_TERCEIRIZADA(CNPJ)
)
CREATE TABLE TELEFONE_EMPRESA_MATRIZ(
	telefone CHAR(13) ,
	EMPRESA_MATRIZ_CNPJ CHAR(14),
	CONSTRAINT PK_telefone_emp_matriz PRIMARY KEY (telefone, EMPRESA_MATRIZ_CNPJ),
	CONSTRAINT FK_telefone_emp_matriz FOREIGN KEY(EMPRESA_MATRIZ_CNPJ) references EMPRESA_MATRIZ(CNPJ)
)
CREATE TABLE TELEFONE_FUNCIONARIO(
	telefone CHAR(13) ,
	FUNCIONARIO_registro INT,
	CONSTRAINT PK_telefone_funcionario PRIMARY KEY (telefone, FUNCIONARIO_registro),
	CONSTRAINT FK_telefone_funcionario FOREIGN KEY(FUNCIONARIO_registro) references FUNCIONARIO(registro)
)
CREATE TABLE TELEFONE_CLIENTE(
	telefone CHAR(13) ,
	CLIENTE_codcliente INT,
	CONSTRAINT PK_telefone_cliente  PRIMARY KEY (telefone, CLIENTE_codcliente),
	CONSTRAINT FK_telefone_cliente FOREIGN KEY(CLIENTE_codcliente) references CLIENTE(codcliente)
)
CREATE TABLE TELEFONE_LOJA(
	telefone CHAR(13) ,
	LOJA_cod_filial INT,
	CONSTRAINT PK_telefone_loja PRIMARY KEY (telefone, LOJA_cod_filial),
	CONSTRAINT FK_telefone_loja FOREIGN KEY(LOJA_cod_filial) references LOJA(cod_filial)
)



-- Funcionarios de loja
INSERT INTO FUNCIONARIO VALUES('11122233399','Pablo','Joao Pessoa','torre','general osorio',256)
INSERT INTO FUNCIONARIO VALUES('55522233399','Joao','Recife','Mangabeira','Jacinto Pinto',155)
INSERT INTO FUNCIONARIO VALUES('65122233399','Maria','Joao Pessoa','Bessa','Tchurus Bango',1234)
INSERT INTO FUNCIONARIO VALUES('11339951454','Jose','Sape','Centro','Renato ribeiro',543)
INSERT INTO FUNCIONARIO VALUES('11125415619','Messias','Mari','Centro','Principal',65)
--Funcionarios de servi�o
INSERT INTO FUNCIONARIO VALUES('65465456412','Bruno','Riachao','Caixa','azul�o',402)
INSERT INTO FUNCIONARIO VALUES('56416515664','Carlos','Joao Pessoa','Mangabeira','Josefa Taveira',2115)
INSERT INTO FUNCIONARIO VALUES('56146516545','Italo','Sousa','Manaira','Guarabira',254)
INSERT INTO FUNCIONARIO VALUES('56564654512','Bill','Cajazeiras','Centro','Duque de Caxias',87)
INSERT INTO FUNCIONARIO VALUES('03454815189','Claudia','Sape','Augusto dos Anjos','Marcos Francisco',95)
--Loja 
INSERT INTO LOJA VALUES('15154845451234', null,'Bobs','02/11/2019','08/11/2020')
INSERT INTO LOJA VALUES('52415051054205', null, 'Habibs','02/11/2019','08/11/2020')
INSERT INTO LOJA VALUES('65695069595230', null, 'McDonalds','02/11/2019','08/11/2020')
INSERT INTO LOJA VALUES('15421054520524', null, 'Burguer King','02/11/2019','08/11/2020')
INSERT INTO LOJA VALUES('64567567454667', null, 'Subway', '02/11/2019','08/11/2020')

-- Inserindo funcionario de loja
INSERT INTO FUNCIONARIO_DE_LOJA VALUES(1,2, 'Vendedor','02/11/2015')
INSERT INTO FUNCIONARIO_DE_LOJA VALUES(2,9, 'Atendente','02/11/2015')
INSERT INTO FUNCIONARIO_DE_LOJA VALUES(3,9, 'Entregador','02/11/2015')
INSERT INTO FUNCIONARIO_DE_LOJA VALUES(4,10, 'Vendedor','02/11/2015')
INSERT INTO FUNCIONARIO_DE_LOJA VALUES(5,10, 'Fiscal','02/11/2015')

--Inserindo Funcionario de servi�o

INSERT INTO FUNCIONARIO_DE_SERVICO VALUES(6, null, '64567567454647','02/05/2016','08/11/2015')
INSERT INTO FUNCIONARIO_DE_SERVICO VALUES(7, null, '64567567454647','02/05/2013',NULL)
INSERT INTO FUNCIONARIO_DE_SERVICO VALUES(8, null, '64567567454647','02/05/2014',NULL)
INSERT INTO FUNCIONARIO_DE_SERVICO VALUES(9, null, '64567567454647','02/05/2012',NULL)
INSERT INTO FUNCIONARIO_DE_SERVICO VALUES(10, null, '64567567454647','02/05/2011',NULL)

--Inserindo Empresa Terceirizada
INSERT INTO EMPRESA_TERCEIRIZADA VALUES('64567567454647','Marquise')
INSERT INTO EMPRESA_TERCEIRIZADA VALUES('54555415140145','Manutencao elevador')
INSERT INTO EMPRESA_TERCEIRIZADA VALUES('10654516579945','Seguran�a JP')
INSERT INTO EMPRESA_TERCEIRIZADA VALUES('32434345456463','Ar cond. Manun')
INSERT INTO EMPRESA_TERCEIRIZADA VALUES('64212514014144','Construtora&Reformas')

--Inserindo Empresa Matriz

INSERT INTO EMPRESA_MATRIZ VALUES('64212514012344', 'Bobs','Campo Grande','Monte Castelo','Rua da Imprensa', 654)
INSERT INTO EMPRESA_MATRIZ VALUES('23243345354334', 'Habibs','Ji-Paran�','Centro','Travessa da CDL', 14)
INSERT INTO EMPRESA_MATRIZ VALUES('12553567434567', 'Subway','S�o Paulo','Vila Ol�mpia','Rua das Fiandeiras', 254)
INSERT INTO EMPRESA_MATRIZ VALUES('05489854863141', 'McDonalds','Rio de Janeiro','Centro','Avenida Rio Branco', 32)
INSERT INTO EMPRESA_MATRIZ VALUES('78202145024503', 'Burguer King','Campos dos Goytacazes','Centro','Rua Tenente-Coronel Cardoso', 985)

-- Inserindo Contrato
INSERT INTO CONTRATO VALUES('02/02/2010',15000)
INSERT INTO CONTRATO VALUES('02/03/2012',25000)
INSERT INTO CONTRATO VALUES('01/05/2015',300000)
INSERT INTO CONTRATO VALUES('02/10/2012',500000)
INSERT INTO CONTRATO VALUES('02/02/2016',90000)

--Inserindo Aluguel

INSERT INTO ALUGUEL VALUES('12553567434567', 2, 1, 5)
INSERT INTO ALUGUEL VALUES('12553567434567', 2, 2, 3)
INSERT INTO ALUGUEL VALUES('05489854863141', 2, 3, 3)
INSERT INTO ALUGUEL VALUES('78202145024503', 9, 4, 3)
INSERT INTO ALUGUEL VALUES('78202145024503', 9, 5, 3)

--Inserindo Cliente

INSERT INTO CLIENTE VALUES('15486154254','Tiago Pereira Correia','S�o Paulo','Vila Ol�mpia','Rua das Fiandeiras',54)
INSERT INTO CLIENTE VALUES('90137096305','Julian Santos Melo','S�o Paulo','Rep�blica','Pra�a da Rep�blica',134)
INSERT INTO CLIENTE VALUES('31291273646','Alex Souza Ribeiro','Cotia','Lageadinho','Rodovia Raposo Tavares',354)
INSERT INTO CLIENTE VALUES('45754604351','Guilherme Ferreira Pinto','Belo Horizonte','Centro','Rua dos Carij�s',205)
INSERT INTO CLIENTE VALUES('17848592812','Eduardo Fernandes Pinto','Bras�lia','Guar� I','QE 11 �rea Especial C',512)

-- Inserindo Produto

INSERT INTO PRODUTO VALUES('Perfume',20)
INSERT INTO PRODUTO VALUES('Whisky Red Label',78.6)
INSERT INTO PRODUTO VALUES('Rel�gio ROLEX', 1999.90)
INSERT INTO PRODUTO VALUES('Desodorante', 15.90)
INSERT INTO PRODUTO VALUES('Coxinha', 1.99)

-- Inserindo Atende
select * from CLIENTE
select * from FUNCIONARIO_DE_LOJA
SELECT * FROM ATENDE
select * from PRODUTO
SELECT * FROM VENDE
INSERT INTO ATENDE VALUES(1, 1,'20/12/2015 11:00')
INSERT INTO ATENDE VALUES(1, 1,'20/12/2015 12:00')
INSERT INTO ATENDE VALUES(1, 1,'20/12/2015 13:00')
INSERT INTO ATENDE VALUES(4, 5,'20/12/2015 16:00')
INSERT INTO ATENDE VALUES(2, 3,'20/12/2015 14:00')
INSERT INTO ATENDE VALUES(2, 3,'20/12/2015 16:00')
-- Inserindo em venda

INSERT INTO VENDE VALUES(5, '20/12/2015 16:00', 2, 3, 4, NULL)
INSERT INTO VENDE VALUES(5, '20/12/2015 13:00', 2, 3, 2, NULL)
INSERT INTO VENDE VALUES(1, '20/12/2015 11:00', 1, 1, 2, null)
INSERT INTO VENDE VALUES(1, '20/12/2015 12:00', 1, 1, 2, NULL)
INSERT INTO VENDE VALUES(3, '20/12/2015 16:00', 4, 5, 1, NULL)
-- Inserindo dependente 
INSERT INTO DEPENDENTE VALUES('46314273021', 'Carlos Machado Gomes',1) 
INSERT INTO DEPENDENTE VALUES('71944209026', 'Carlos Teixeira Amaral',3)
INSERT INTO DEPENDENTE VALUES('68188837024','Hadassa Heloisa Andrea Souza',1)
INSERT INTO DEPENDENTE VALUES('29931809086','Sebasti�o Edson Geraldo Souza',5)
INSERT INTO DEPENDENTE VALUES('26349380398','Ester Mariah Amanda', 10)
-- Inserindo telefone cliente

 
INSERT INTO TELEFONE_CLIENTE VALUES('8394488488555',1)
INSERT INTO TELEFONE_CLIENTE VALUES('8398845188555',2)
INSERT INTO TELEFONE_CLIENTE VALUES('8394188488555',3)
INSERT INTO TELEFONE_CLIENTE VALUES('8391314854255',4)
INSERT INTO TELEFONE_CLIENTE VALUES('8399956554122',5)

-- Inserindo telefone empresa matriz

 
INSERT INTO TELEFONE_EMPRESA_MATRIZ VALUES('8394488488555','05489854863141')
INSERT INTO TELEFONE_EMPRESA_MATRIZ VALUES('8398845188555','12553567434567')
INSERT INTO TELEFONE_EMPRESA_MATRIZ VALUES('8398845188555','23243345354334')
INSERT INTO TELEFONE_EMPRESA_MATRIZ VALUES('8398845156455','23243345354334')
INSERT INTO TELEFONE_EMPRESA_MATRIZ VALUES('8398845188555','64212514012344')
INSERT INTO TELEFONE_EMPRESA_MATRIZ VALUES('8398845188555','78202145024503')

-- Inserindo telefone empresa terceirizada


INSERT INTO TELEFONE_EMPRESA_TERCEIRIZADA VALUES('8398821208555','10654516579945')
INSERT INTO TELEFONE_EMPRESA_TERCEIRIZADA VALUES('8398845165441','32434345456463')
INSERT INTO TELEFONE_EMPRESA_TERCEIRIZADA VALUES('8398845141644','54555415140145')
INSERT INTO TELEFONE_EMPRESA_TERCEIRIZADA VALUES('8398845194741','64212514014144')
INSERT INTO TELEFONE_EMPRESA_TERCEIRIZADA VALUES('8398547845215','64567567454647')

-- Inserindo telefone funcionario



INSERT INTO TELEFONE_FUNCIONARIO VALUES('8398547840205',1)
INSERT INTO TELEFONE_FUNCIONARIO VALUES('8398514215125',2)
INSERT INTO TELEFONE_FUNCIONARIO VALUES('8391197845215',3)
INSERT INTO TELEFONE_FUNCIONARIO VALUES('8398544515412',4)
INSERT INTO TELEFONE_FUNCIONARIO VALUES('8398841541851',5)

-- Inserindo Telefone loja




INSERT INTO TELEFONE_LOJA VALUES('8395151840512',2)
INSERT INTO TELEFONE_LOJA VALUES('8398549484798',9)
INSERT INTO TELEFONE_LOJA VALUES('8399888855414',10)
INSERT INTO TELEFONE_LOJA VALUES('8399521441410',11)
INSERT INTO TELEFONE_LOJA VALUES('8395123101510',12)

-- Update



UPDATE FUNCIONARIO_DE_SERVICO
SET registro_gerencia = 6
where datagerencia IS NULL

UPDATE FUNCIONARIO_DE_LOJA
SET cod_filial_fk = 2
where cod_filial_fk IS NULL and funcao = 'Vendedor'

UPDATE FUNCIONARIO_DE_LOJA
SET cod_filial_fk = 9
where cod_filial_fk IS Null

UPDATE LOJA 
SET registro_gerente = 1, datainicio = '08/11/2018', datafim = '08/11/2020' 
WHERE nome = 'Bobs'

select FUNCIONARIO.nome as [Nome Funcionario], DEPENDENTE.nome as [Nome dependente]
FROM FUNCIONARIO INNER JOIN DEPENDENTE
ON FUNCIONARIO.registro = DEPENDENTE.registro
ORDER BY FUNCIONARIO.registro