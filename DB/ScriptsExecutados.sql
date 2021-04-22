create database teste_wk;
use teste_wk;

create table clientes (
	codigo int unsigned not null auto_increment,
    nome varchar(80) not null,
    cidade varchar(40),
    uf varchar(2),
    primary key (codigo)	
);

create table produtos (
	codigo int unsigned not null auto_increment,
    descricao varchar(80),
    precovenda double not null default '0',
    primary key (codigo)
);

create table pedidos_dados_gerais (
	numero int unsigned not null auto_increment,
    codigo_cli int unsigned not null,
    emissao date,
    valortotal double default '0',
    primary key (numero),
    CONSTRAINT fk_pedidos_clientes foreign key (codigo_cli) references clientes (codigo)	
 );


create table pedidos_produtos (
	    id int unsigned not null auto_increment,
        numeropedido int unsigned not null,
        codigoproduto int unsigned not null,
        quantidade double default '0',
        valorunitario double default '0',
        valortotal double default '0',
        primary key (id),
        constraint fk_pedidosprodutosdados foreign key (numeropedido) references pedidos_dados_gerais (numero), 
        constraint fk_pedidosprodutosprodutos foreign key (codigoproduto) references produtos (codigo)
);

insert into clientes (nome, cidade, uf) values 
	('Jose', 'Guarulhos', 'SP'),
    ('Maria','Guarulhos','SP'),
	('João', 'São Paulo', 'SP'),
    ('Mario','São Paulo','SP'),
    ('Elias', 'São Paulo', 'SP'),
    ('Antonia', 'Santos', 'SP'),
    ('Priscila', 'São Paulo', 'SP'),
    ('Beatriz', 'São Paulo', 'SP'),
    ('Heloisa', 'Belo Horizonte', 'MG'),
    ('Ana Carolina', 'Maringa', 'PR'),
    ('Carolina', 'São Paulo', 'SP'),
    ('Ludimille', 'São Paulo', 'SP'),
    ('Carlos', 'São Paulo', 'SP'),
    ('Denilson', 'São Paulo', 'SP'),
    ('Fernando', 'São Paulo', 'SP'),
    ('Moisés', 'São Paulo', 'SP'),
    ('Antônio', 'São Paulo', 'SP'),
    ('Diego', 'São Paulo', 'SP'),
    ('Bruno', 'São Paulo', 'SP'),
    ('Fabio', 'São Paulo', 'SP');
    
    
insert into produtos (descricao, precovenda)  values
 ('Borracha branca pequena', 0.50),
 ('Borracha branca média', 0.75),
 ('Borracha branca grande', 1.30),
 ('Caneta Azul', 2.00),
 ('Caneta Preta', 2.00),
 ('Caneta Vermelha', 2.00),
 ('Régua Acrílico 20cm', 5.00),
 ('Régua Acrílico 30cm', 7.50),
 ('Papel A4 Branco 500 fls', 23.50),
 ('Papel A4 Branco 500 fls Marca', 25.50),
 ('Toner HP Univ Compatível 85A', 69.90),
 ('Toner Brother Compatível 450', 59.90),
 ('Toner Samsung Compatível D101', 89.00),
 ('Toner Brother Compatível 3472', 99.50),
 ('Photocondutor Brother Compatível DR3472', 120.00), 
 ('Photocondutor Brother Compatível DR450', 90.00),  
 ('Cola branca 100ml', 10.00),  
 ('Cola branca 1000ml', 23.00),  
 ('Caixa grampo', 5.90),
 ('Caixa Clips 5000 uni', 15.00),
 ('Caderno 200 fls 1 mat', 13.00);
 

create view VW_PEDIDO (
	NUMERO,
    EMISSAO,
    CLIENTE,
    NOMECLIENTE,
    CIDADE,
    UF,
    VALORTOTAL,
    PRODID,
    PRODCODIGO,
    PRODDESCRICAO,
    PRODUNITARIO,
    PRODQUANTIDADE,
    PRODTOTAL  
) AS
select a.numero, a.emissao, a.codigo_cli, d.nome, d.cidade, d.uf, a.valortotal,
       b.id,
       b.codigoproduto,
       c.descricao,
       b.quantidade,
	   b.valorunitario,
       b.valortotal       
       from pedidos_dados_gerais a
inner join pedidos_produtos b on (b.numeropedido = a.numero)
inner join produtos c on (c.codigo = b.codigoproduto)
inner join clientes d on (d.codigo = a.codigo_cli)
order by A.NUMERO, B.ID;

 
 explain select * from pedidos_dados_gerais where numero = 10 and codigo_cli = 5;
 
create index idx_pv on pedidos_dados_gerais(numero, codigo_cli);
create index idx_pv_prd on pedidos_dados_gerais(numero, codigo_cli);



    
    