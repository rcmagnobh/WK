# WK
Prova WK


Avaliação Técnica - Delphi  •  Desenvolver uma tela de pedidos de venda;  •  O operador deverá informar o cliente (Não precisa desenvolver o cadastro), e os produtos (Não precisa desenvolver o cadastro);  •  Campos da tabela de clientes: (código, nome, cidade, uf);  •  Campos da tabela de produtos: (código, descrição, preço de venda);  •  As tabelas de clientes e produtos devem ser criadas no banco de dados e alimentadas com 20 registros ou mais, para teste. As tabelas serão avaliadas no teste (PK, FK, índices, etc.);  •  Para informar o produto na tela do pedido de vendas, o operador deve digitar: código do produto, quantidade e valor unitário;  •  À medida que o operador digita os produtos e confirma, eles devem ir entrando em um grid para visualização. Deve existir um botão para inserir o produto no grid;  •  O grid deve apresentar: código do produto, descrição do produto, quantidade, vlr. unitário e vlr. total;  •  Deve ser possível navegar pelo grid com seta para cima seta pra baixo;  •  Estando navegando pelo grid, deve ser possível acionar ENTER sobre um produto para alterá-lo. Poderá ser alterado quantidade e vlr. unitário. Utilizar o mesmo botão de inserir para confirmar e atualizar o grid com as alterações feiras pelo operador;  •  Estando navegando pelo grid, deve ser possível acionar DEL sobre um produto para apagá-lo. Perguntar ao operador se realmente deseja apagá-lo;  •  Permitir produtos repetidos no grid;  •  Exibir no rodapé da tela o valor total do pedido;  •  Incluir botão GRAVAR PEDIDO. Quando acionado, o sistema deve gravar 2 tabelas (dados gerais do pedido e produtos do pedido);  •  Campos da tabela de pedidos dados gerais: (número pedido, data emissão, código cliente, valor total);  •  Campos da tabela de pedidos produtos: (autoincrem, número pedido, código produto, quantidade, vlr. unitário e vlr. total);  •  Utilizar transação e tratar possíveis erros;  •  O pedido deve possuir número sequencial crescente;  •  A chave primaria da tabela de dados gerais do pedido deve ser (Número pedido), não podendo haver duplicidade entre os registros gravados;  •  A chave primaria da tabela de produtos deve ser (autoincrem.), pois pode existir repetição de produtos;  •  Criar FKs necessárias para ligar a tabela de produtos do pedido e tabela de dados gerais do pedido;  •  Criar índices necessários nas tabelas de dados gerais do pedido e produtos do pedido;  •  Criar botão na tela de pedidos, que deve ficar visível quando o código do cliente estiver em branco, para carregar pedidos já gravados. Solicitar (número do pedido) e carregar o cliente e os produtos;  •  Criar botão na tela de pedidos, que deve ficar visível quando o código do cliente estiver em branco, para cancelar um pedido. Solicitar (número do pedido) e apagar 2 duas tabelas.  Critérios do Teste  •  Utilizar MySQL para o teste;  •  Envie junto o script pra criação do banco completo e seus dados; •  Não utilize componente de terceiros. Apenas componentes nativos do Delphi; •  Priorize o uso do SQL, mesmo em inserções e atualizações, pois, estamos avaliando seus conhecimentos em SQL;  •  Capriche na escrita do seu código, pois, a formatação do mesmo está sendo avaliada;  •  Utilize conceitos de orientação a objetos, criando classes por exemplo; •  Suba para o GIT e responda esse teste com o link.
