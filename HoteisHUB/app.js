/*
    Projeto de Banco de Dados feito por Brenda Castro da Silva e Flávia Alessandra S. de Jesus.

    Para iniciar o npm use este comando no terminal na pasta do seu projeto: npm init -y
    Para instalar as dependências nescessárias use o comando no terminal na pasta em que seu projeto está: npm install express ejs mysql
    Para executar esse codigo digite no terminal o comando: node app.js
    Para ver o resultado, vá no seu navegador e entre no link: http://localhost:3000
    Para finalizar clique em ctrl + c no terminal
*/

//Define configurações iniciais
const express = require("express");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
const { render } = require("ejs");
const e = require("express");
const app = express();
const port = 3000; //Porta que será usada

let clienteEmail = null; //Variavel que guarda o email do cliente que está usando a conta
let clienteCPF = null; //Guarda o CPF do cliente
let clienteSenha = null; //Guarda a senha do cliente

//Configura o banco de dados MySQL
const connection = mysql.createConnection({
    host: "localhost", //Nome do servidor
    user: "root", //Usuario do servidor
    password: "senia", //Senha do servidor(No caso essa é a minha senha, você precisa colocar a senha que você configurou)
    database: "reserva_hoteis", //Nome do banco de dados
});//Fim

//Avisa se a conexão foi bem sucedida
connection.connect((err) => {
    if(err){
        console.log("Erro ao conectar ao MySQL: " + err.stack); //Isso será impresso no console no caso de erro
        return;
    }

    console.log("Conectado ao MySQL com ID " + connection.threadId); //Isso será ipresso no console no caso de sucesso
});//Fim

//Configura o express
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static("public"));
//Fim

//Rotas
//Rota principal chama index.ejs
app.get('/', (req, res) => {
    res.render('index'); //Rederiza a pagina index.ejs no navegador
});//Fim

//Rota para a pagina de login
app.get("/loginPage", (req, res) => {
    res.render("login.ejs"); //Renderiza a pagina login.ejs no navegador
});//Fim

//Rota para a pagina de opções
app.get("/options", (req, res) => {
    res.render("options.ejs"); //Renderiza a pagina options.ejs no navegador
});

//Rota para a pagina de cadastro
app.post('/cadastro', (req, res) => {
    const { nome_completo, email, senha, cpf, user_name, idade } = req.body; //Esses dados vão vir do formulário que o usuario digitou
  
    //Verificar se o email, CPF ou nome de usuario já estão em uso
    connection.query('SELECT * FROM CLIENTE_CONTA WHERE user_name = ? OR email = ? OR cpf = ?', [user_name, email, cpf], (err, results) => {
        if(err) throw err;
  
        if(results.length > 0){
            //Se email, usuario ou CPF já está em uso, exibe mensagem de erro(vou adicionar uma pagina de erro aqui)
            res.send('Usuário já cadastrado. Por favor, escolha outro usuário.');
        }else{
            //Email não está em uso, então o cadastro pode ser feito
            const usuario = { nome_completo, email, senha, cpf, user_name, idade };

            //Comando insert para colocar os dados do usuario no banco de dados
            //No lugar da interrogação ficará as variaveis que estão dentro das chaves
            connection.query('INSERT INTO CLIENTE_CONTA SET ?', {nome_completo, email, senha, cpf, user_name, idade}, (err, results) => {
                if(err) throw err;
                res.redirect('/loginPage'); //Vai renderizar a pagina de login onde o usuario pode entrar na conta
            });
        }
    });
});//Fim

//Rota para a pagina de fazer login
app.post('/login', (req, res) => {
    const { email, senha } = req.body; //Traz do formulario o email e a senha do usuario
    clienteEmail = email; //Salva o email do usuario
    clienteSenha = senha;

    //Comando select para saber se as informações que o usuario digitou estão no banco de dados
    connection.query(
        'SELECT * FROM CLIENTE_CONTA WHERE email = ? AND senha = ?', [email, senha],
        (err, results) => {
            if(err) throw err;
  
            //Se estiver certo sera redirecionado para a pagina que mostra a lista de pacotes de viagem
            if(results.length > 0){
                res.redirect('/options');
            }else{
                res.send('Credenciais inválidas!');
            }
        }
    );
});//Fim
  
//Rota para a pagina de mostrar a lista de pacotes disponiveis
app.get('/lista', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT	PACOTE_VIAGEM.id_pacote, PACOTE_VIAGEM.detalhes_pacote, PACOTE_VIAGEM.destino, PACOTE_VIAGEM.preco, PACOTE_VIAGEM.nome_pacote, PACOTE_VIAGEM.data_viagem, IFNULL(PROMOCAO.nome_promocao, "Sem Promoção") AS NomePromocao, IFNULL(PROMOCAO.descricao_promocao, "Sem Promoção") AS DescricaoPromocao, IFNULL(PROMOCAO.valor_desconto, "Sem Promoção") AS ValorDesconto, IFNULL(PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto, "Sem Promoção") AS ValorComDesconto,
    GROUP_CONCAT(FORNECEDOR.nome_fornecedor) as Fornecedores,
    GROUP_CONCAT(FORNECEDOR.contato_fornecedor) as ContatoFornecedor,
    GROUP_CONCAT(FORNECEDOR.servico_fornecido) as Servio
    FROM PACOTE_VIAGEM
    JOIN PARCERIA ON PACOTE_VIAGEM.id_pacote = PARCERIA.id_pacote_fk
    JOIN FORNECEDOR ON PARCERIA.id_fornecedor_fk = FORNECEDOR.id_fornecedor
    LEFT JOIN TEM ON PACOTE_VIAGEM.id_pacote = TEM.id_pacote_fk
    LEFT JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
    GROUP BY PACOTE_VIAGEM.id_pacote, PACOTE_VIAGEM.detalhes_pacote,
     PACOTE_VIAGEM.destino,
     PACOTE_VIAGEM.preco,
     PACOTE_VIAGEM.nome_pacote,
     PACOTE_VIAGEM.data_viagem,
     PROMOCAO.nome_promocao,
     PROMOCAO.descricao_promocao,
     PROMOCAO.valor_desconto;`, (err, results) => {
        if(err) throw err;
        res.render('lista', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a pagina de mostrar a lista de pacotes disponiveis
app.get('/qtdpacotes', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT IFNULL(PACOTE_VIAGEM.nome_pacote, "Total") AS Nome,  COUNT(PACOTE_VIAGEM.id_pacote) AS Contagem FROM PACOTE_VIAGEM GROUP BY PACOTE_VIAGEM.nome_pacote WITH ROLLUP;`, (err, results) => {
        if(err) throw err;
        res.render('contagem', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a pagina de mostrar a lista de pacotes disponiveis que são menores que 2000
app.get('/menordoismil', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT	PACOTE_VIAGEM.id_pacote, PACOTE_VIAGEM.detalhes_pacote, PACOTE_VIAGEM.destino, PACOTE_VIAGEM.preco, PACOTE_VIAGEM.nome_pacote, PACOTE_VIAGEM.data_viagem, PROMOCAO.nome_promocao, PROMOCAO.descricao_promocao, PROMOCAO.valor_desconto, PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto AS ValorComDesconto,
    GROUP_CONCAT(FORNECEDOR.nome_fornecedor) as Fornecedores,
    GROUP_CONCAT(FORNECEDOR.contato_fornecedor) as ContatoFornecedor,
    GROUP_CONCAT(FORNECEDOR.servico_fornecido) as Servio
FROM PACOTE_VIAGEM
JOIN PARCERIA ON PACOTE_VIAGEM.id_pacote = PARCERIA.id_pacote_fk
JOIN FORNECEDOR ON PARCERIA.id_fornecedor_fk = FORNECEDOR.id_fornecedor
JOIN TEM ON PACOTE_VIAGEM.id_pacote = TEM.id_pacote_fk
JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
GROUP BY PACOTE_VIAGEM.id_pacote, PACOTE_VIAGEM.detalhes_pacote,
     PACOTE_VIAGEM.destino,
     PACOTE_VIAGEM.preco,
     PACOTE_VIAGEM.nome_pacote,
     PACOTE_VIAGEM.data_viagem,
     PROMOCAO.nome_promocao,
     PROMOCAO.descricao_promocao,
     PROMOCAO.valor_desconto
HAVING PACOTE_VIAGEM.preco < 2000;`, (err, results) => {
        if(err) throw err;
        res.render('lista', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a pagina de mostrar a lista de pacotes disponiveis ordenados do menor para o maior
app.get('/menormaior', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT
    PACOTE_VIAGEM.id_pacote,
    PACOTE_VIAGEM.detalhes_pacote,
    PACOTE_VIAGEM.destino,
    PACOTE_VIAGEM.preco,
    PACOTE_VIAGEM.nome_pacote,
    PACOTE_VIAGEM.data_viagem,
    IFNULL(PROMOCAO.nome_promocao, "Sem Promoção") AS NomePromocao,
    IFNULL(PROMOCAO.descricao_promocao, "Sem Promoção") AS DescricaoPromocao,
    IFNULL(PROMOCAO.valor_desconto, "Sem Promoção") AS ValorDesconto,
    IFNULL(PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto, "Sem Promoção") AS ValorComDesconto,
    GROUP_CONCAT(FORNECEDOR.nome_fornecedor) as Fornecedores,
    GROUP_CONCAT(FORNECEDOR.contato_fornecedor) as ContatoFornecedor,
    GROUP_CONCAT(FORNECEDOR.servico_fornecido) as Servico
FROM
    PACOTE_VIAGEM
    JOIN PARCERIA ON PACOTE_VIAGEM.id_pacote = PARCERIA.id_pacote_fk
    JOIN FORNECEDOR ON PARCERIA.id_fornecedor_fk = FORNECEDOR.id_fornecedor
    LEFT JOIN TEM ON PACOTE_VIAGEM.id_pacote = TEM.id_pacote_fk
    LEFT JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
GROUP BY
    PACOTE_VIAGEM.id_pacote,
    PACOTE_VIAGEM.detalhes_pacote,
    PACOTE_VIAGEM.destino,
    PACOTE_VIAGEM.preco,
    PACOTE_VIAGEM.nome_pacote,
    PACOTE_VIAGEM.data_viagem,
    PROMOCAO.nome_promocao,
    PROMOCAO.descricao_promocao,
    PROMOCAO.valor_desconto
ORDER BY
    PACOTE_VIAGEM.preco ASC;`, (err, results) => {
        if(err) throw err;
        res.render('lista', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a pagina de mostrar a lista de pacotes disponiveis mostrando o pacote de menor preço
app.get('/min', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT
    PACOTE_VIAGEM.id_pacote,
    PACOTE_VIAGEM.detalhes_pacote,
    PACOTE_VIAGEM.destino,
    PACOTE_VIAGEM.preco,
    PACOTE_VIAGEM.nome_pacote,
    PACOTE_VIAGEM.data_viagem,
    IFNULL(PROMOCAO.nome_promocao, "Sem Promoção") AS NomePromocao,
    IFNULL(PROMOCAO.descricao_promocao, "Sem Promoção") AS DescricaoPromocao,
    IFNULL(PROMOCAO.valor_desconto, "Sem Promoção") AS ValorDesconto,
    IFNULL(PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto, "Sem Promoção") AS ValorComDesconto,
    GROUP_CONCAT(FORNECEDOR.nome_fornecedor) as Fornecedores,
    GROUP_CONCAT(FORNECEDOR.contato_fornecedor) as ContatoFornecedor,
    GROUP_CONCAT(FORNECEDOR.servico_fornecido) as Servico
FROM
    PACOTE_VIAGEM
    JOIN PARCERIA ON PACOTE_VIAGEM.id_pacote = PARCERIA.id_pacote_fk
    JOIN FORNECEDOR ON PARCERIA.id_fornecedor_fk = FORNECEDOR.id_fornecedor
    LEFT JOIN TEM ON PACOTE_VIAGEM.id_pacote = TEM.id_pacote_fk
    LEFT JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
GROUP BY
    PACOTE_VIAGEM.id_pacote,
    PACOTE_VIAGEM.detalhes_pacote,
    PACOTE_VIAGEM.destino,
    PACOTE_VIAGEM.nome_pacote,
    PACOTE_VIAGEM.data_viagem,
    PROMOCAO.nome_promocao,
    PROMOCAO.descricao_promocao,
    PROMOCAO.valor_desconto
HAVING
    PACOTE_VIAGEM.preco = (SELECT MIN(preco) FROM PACOTE_VIAGEM);`, (err, results) => {
        if(err) throw err;
        res.render('lista', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a pagina de mostrar a lista de pacotes disponiveis mostrando o pacote de maior preço
app.get('/max', (req, res) => {
    //Comando select com join para trazer as informações dos pacotes de viagens
    connection.query(`SELECT
    PACOTE_VIAGEM.id_pacote,
    PACOTE_VIAGEM.detalhes_pacote,
    PACOTE_VIAGEM.destino,
    PACOTE_VIAGEM.preco,
    PACOTE_VIAGEM.nome_pacote,
    PACOTE_VIAGEM.data_viagem,
    IFNULL(PROMOCAO.nome_promocao, "Sem Promoção") AS NomePromocao,
    IFNULL(PROMOCAO.descricao_promocao, "Sem Promoção") AS DescricaoPromocao,
    IFNULL(PROMOCAO.valor_desconto, "Sem Promoção") AS ValorDesconto,
    IFNULL(PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto, "Sem Promoção") AS ValorComDesconto,
    GROUP_CONCAT(FORNECEDOR.nome_fornecedor) as Fornecedores,
    GROUP_CONCAT(FORNECEDOR.contato_fornecedor) as ContatoFornecedor,
    GROUP_CONCAT(FORNECEDOR.servico_fornecido) as Servico
FROM
    PACOTE_VIAGEM
    JOIN PARCERIA ON PACOTE_VIAGEM.id_pacote = PARCERIA.id_pacote_fk
    JOIN FORNECEDOR ON PARCERIA.id_fornecedor_fk = FORNECEDOR.id_fornecedor
    LEFT JOIN TEM ON PACOTE_VIAGEM.id_pacote = TEM.id_pacote_fk
    LEFT JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
GROUP BY
    PACOTE_VIAGEM.id_pacote,
    PACOTE_VIAGEM.detalhes_pacote,
    PACOTE_VIAGEM.destino,
    PACOTE_VIAGEM.nome_pacote,
    PACOTE_VIAGEM.data_viagem,
    PROMOCAO.nome_promocao,
    PROMOCAO.descricao_promocao,
    PROMOCAO.valor_desconto
HAVING
    PACOTE_VIAGEM.preco = (SELECT MAX(preco) FROM PACOTE_VIAGEM);`, (err, results) => {
        if(err) throw err;
        res.render('lista', { pacotes: results }); //Vai renderizar a pagina de pacotes de viagem, os dados estão na variavel pacotes
    });
});//Fim

//Rota para a opção compra
app.post('/compra', (req, res) => {
    const { id_pacote } = req.body;

    console.log(id_pacote);
  
    //Verificar se o usuário está logado
    if(!clienteEmail){
        res.send('Você precisa estar logado para comprar um pacote de viagem.');
        return;
    }

    // Consultar o banco de dados para obter as informações do usuário pelo email
    connection.query(`SELECT cpf, user_name FROM CLIENTE_CONTA WHERE email = ?`, [clienteEmail], (err, results) => {
        if(err) throw err;

        if(results.length === 0){
            res.send('Usuário não encontrado.');
            return;
        }

        const {cpf, user_name } = results[0];

        //Faz insert na tabela compra
        connection.query('INSERT INTO COMPRA SET ?', { id_pacote_fk: id_pacote, cpf_fk: cpf, user_name_fk: user_name }, (err, results) => {
            if(err) throw err;
            res.send(`Compra realizada com sucesso!<a href="/lista">Voltar</a>`); //Exibe manssagem e coloca um link para o usuario voltar a pagina de lista de pacotes
        });
    });
});//Fim

//Rota para ir para a pagina de comentários
//A sintaxe abaixo significa que a rota é /comentarios e dentro da URL passamos id_pacote para usarmos dentro da rota
app.get("/comentarios/:id_pacote", (req, res) => {
    const id_pacote = req.params.id_pacote; //Pega o valor de id pacote assado por parametro na URL

    console.log(id_pacote);

    //Select no banco de dados
    connection.query(
        `SELECT CLIENTE_CONTA.user_name, FEEDBACK_CLIENTE.data_comentario, FEEDBACK_CLIENTE.comentario, PACOTE_VIAGEM.nome_pacote
        FROM CLIENTE_CONTA
        JOIN POSTA ON CLIENTE_CONTA.cpf = POSTA.cpf_fk AND CLIENTE_CONTA.user_name = POSTA.user_name_fk
        JOIN FEEDBACK_CLIENTE ON POSTA.id_feedback_fk = FEEDBACK_CLIENTE.id_feedback
        JOIN PACOTE_VIAGEM ON FEEDBACK_CLIENTE.id_pacote_fk = PACOTE_VIAGEM.id_pacote
        WHERE PACOTE_VIAGEM.id_pacote = ?
        ORDER BY FEEDBACK_CLIENTE.data_comentario;`, [id_pacote],
        (err, results) => {
            if(err) throw err;
            console.log(results);
            res.render("comentarios", { comentarios: results, id_pacote }); //Renderiza a pagina comentarios.ejs com os dados do select
        }
    );
});//Fim

//Rota para postar comentario(ainda preciso consertar)
//Recebe id_pacote pelo paramentro da URL
app.post("/postar_comentario/:id_pacote", (req, res) => {
    const {comentario} = req.body;

    //Faz insert no banco de dados
    connection.query('INSERT INTO FEEDBACK_CLIENTE SET data_comentario = NOW(), comentario = ?, id_pacote_fk = ?', [comentario, req.params.id_pacote], (err1, results1) => {
        if(err1) throw err1;

        //Faz um slect para pegar informações
        connection.query(`SELECT id_feedback, comentario FROM FEEDBACK_CLIENTE WHERE id_pacote_fk = ?`, [req.params.id_pacote], (err2, results2) => {
            if(err2) throw err2;

            //Faz outro select para pegar informações
            connection.query(`SELECT user_name, cpf FROM CLIENTE_CONTA WHERE email = ?`, [clienteEmail], (err3, results3) => {
                if(err3) throw err3;

                const {user_name, cpf} = results3[0];

                connection.query(`INSERT INTO POSTA SET ?`, {cpf_fk: cpf, user_name_fk: user_name, id_feedback_fk: results2[results2.length - 1].id_feedback});

                res.redirect("/comentarios/" + req.params.id_pacote); //Redireciona a pagina para comentarios.ejs
            });
        });
    });
});//Fim

//Rota para pegar os dados de PACOTE_VIAGEM para mostrar na tela renderizando a pagina historico.ejs
app.get("/historicoCompras", (req, res) => {
    //Faz o select das compras que o cliente fez
    //Para isso fazemos o join das tabelas relacionadas as compras
    connection.query(`SELECT PACOTE_VIAGEM.nome_pacote, PACOTE_VIAGEM.destino, PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto AS promocao
    FROM PACOTE_VIAGEM
    JOIN COMPRA ON PACOTE_VIAGEM.id_pacote = COMPRA.id_pacote_fk
    JOIN CLIENTE_CONTA ON CLIENTE_CONTA.user_name =  COMPRA.user_name_fk
    JOIN TEM ON TEM.id_pacote_fk = PACOTE_VIAGEM.id_pacote
    JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
    WHERE CLIENTE_CONTA.email = "${clienteEmail}";`, (err, results) => {
        if(err) throw err;

        //Faz o select para pegar somente o somatorio do preço das compras
        connection.query(`SELECT SUM(PACOTE_VIAGEM.preco - PROMOCAO.valor_desconto) AS Total
        FROM PACOTE_VIAGEM
        JOIN COMPRA ON PACOTE_VIAGEM.id_pacote = COMPRA.id_pacote_fk
        JOIN CLIENTE_CONTA ON CLIENTE_CONTA.user_name =  COMPRA.user_name_fk
        JOIN TEM ON TEM.id_pacote_fk = PACOTE_VIAGEM.id_pacote
        JOIN PROMOCAO ON PROMOCAO.id_promocao = TEM.id_promocao_fk
        WHERE CLIENTE_CONTA.email = "${clienteEmail}";`, (err2, results2) => {
            if(err2) throw err2;
            console.log(results2);
            res.render('historico', { compras: results, results2 }); //Renderiza a pagina historico.ejs
        });
    });
});//Fim

//Rota para renderizar a pagina atualizar.ejs
app.get("/atualizar", (req, res) => {
    res.render("atualizar.ejs"); //Renderiza a pagina atualizar.ejs
});//Fim

//Rota para fazer a atualização dos dados do usuario
app.post("/atualizarnome", (req, res) => {
    const { nome_completo, user_name, senha, idade } = req.body; //Pega os dados inseridos na pagina atualizar.ejs

    //Faz o update dos dados
    connection.query(`UPDATE CLIENTE_CONTA SET nome_completo = "${nome_completo}", senha = "${senha}", idade = "${idade}" WHERE user_name = "${user_name}"`, (err, results) => {
        if(err) throw err;

        res.render("login"); //Depois de atualizar os dados o usuario é redirecionado para a pagina de login
    });
});//Fim

//Rota para renderizar a pagina de confirmar dados para deletar conta
app.get("/deletar", (req, res) => {
    res.render("deletar.ejs"); //Renderiza pagina deletar.ejs
});//Fim

//Rota para deletar a conta de um usuario
app.post("/deletarconta", (req, res) => {
    const { user_name, senha } = req.body; //Paga os dados inseridos da pagina deletar.ejs

    console.log(user_name);
    console.log(senha);

    //Deleta as compras feitas pelo usuario
    connection.query('DELETE FROM COMPRA WHERE user_name_fk = ?', [user_name], (err, result) => {
        if(err) throw err;

        //Verifica se senha é realmente a senha do usuario
        if(result.affectedRows > 0 || senha === clienteSenha){
            //Deleta a postagens do usuario
            connection.query('DELETE FROM POSTA WHERE user_name_fk = ?', [user_name], (errPosta, resultPosta) => {
                if(errPosta) throw errPosta;

                //Deleta a conta do cliente
                connection.query('DELETE FROM CLIENTE_CONTA WHERE user_name = ? AND senha = ?', [user_name, senha], (errCompra, resultCompra) => {
                    if (errCompra) throw errCompra;

                    res.render("index");
                });
            });
        }else{
            res.send('Credenciais inválidas ou a conta não foi encontrada.'); //Envia uma aviso de que algun dado está invalido
        }
    });
});//Fim

//Inicia o servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});//Fim