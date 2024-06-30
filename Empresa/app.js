/*
    Projeto de Banco de Dados feito por Brenda Castro da Silva e Flavia Alessandra de Jesus.

    Para iniciar o npm use este comando no terminal na pasta do seu projeto: npm init -y
    Para instalar as dependências necessárias use o comando no terminal na pasta em que seu projeto está: npm install express ejs mysql2
    Para executar esse código digite no terminal o comando: node app.js
    Para ver o resultado, vá no seu navegador e entre no link: http://localhost:3000
    Para finalizar clique em ctrl + c no terminal
*/

// Define configurações iniciais
const express = require("express");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
const app = express();
const port = 3000; // Porta que será usada

let clienteEmail = null; // Variável que guarda o email do cliente que está usando a conta
let clienteCPF = null; // Guarda o CPF do cliente
let clienteSenha = null; // Guarda a senha do cliente
let clienteNome = null; // Guarda o nome do cliente

// Configura o banco de dados MySQL
const connection = mysql.createConnection({
    host: "localhost", //Nome do servidor
    user: "root", //Usuario do servidor
    password: "senia", //Senha do servidor
    database: "reserva_hotel", //Nome do banco de dados
});//Fim

// Avisa se a conexão foi bem-sucedida
connection.connect((err) => {
    if (err) {
        console.log("Erro ao conectar ao MySQL: " + err.stack); // Isso será impresso no console no caso de erro
        return;
    }
    console.log("Conectado ao MySQL com ID " + connection.threadId); // Isso será impresso no console no caso de sucesso
});

// Configura o express
app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

// Rotas
// Rota principal chama index.ejs
app.get('/', (req, res) => {
    res.render('index'); // Renderiza a página index.ejs no navegador
});

// Rota para a página de login
app.get("/loginPage", (req, res) => {
    res.render("login.ejs"); // Renderiza a página login.ejs no navegador
});

// Rota para a página de opções
app.get("/options", (req, res) => {
    if (clienteNome) {
        res.render("options.ejs", { user_name: clienteNome }); // Renderiza a página options.ejs passando o nome do usuário
    } else {
        res.redirect('/loginPage');
    }
});

// Rota para renderizar a página de lista de reservas
app.get("/reserveList", (req, res) => {
    const { status, tipo, message } = req.query;

    let query = "SELECT * FROM QUARTO";
    let queryParams = [];

    if (status || tipo) {
        query += " WHERE";
        if (status) {
            query += " Status = ?";
            queryParams.push(status);
        }
        if (status && tipo) {
            query += " AND";
        }
        if (tipo) {
            query += " TipoQuarto = ?";
            queryParams.push(tipo);
        }
    }

    connection.query(query, queryParams, (err, results) => {
        if (err) throw err;
        res.render("reserveList", { quartos: results });
    });
});


//Rota para renderizar a pagina atualizar.ejs
app.get("/update", (req, res) => {
    res.render("update.ejs"); //Renderiza a pagina atualizar.ejs
});//Fim

//Rota para fazer a atualização dos dados do usuario
app.post("/atualizarConta", (req, res) => {
    const { nome_completo, user_name, senha, idade } = req.body; //Pega os dados inseridos na pagina atualizar.ejs

    //Faz o update dos dados
    connection.query(`UPDATE CLIENTE SET nome_completo = "${nome_completo}", senha = "${senha}", idade = "${idade}" WHERE user_name = "${user_name}"`, (err, results) => {
        if(err) throw err;

        res.render("login"); //Depois de atualizar os dados o usuario é redirecionado para a pagina de login
    });
});//Fim

//Rota para renderizar a pagina de deletar conta
app.get("/delete", (req, res) =>{
    res.render("delete.ejs"); //renderiza a pagina deletar.ejs
});

//Rota para deletar conta
app.post("/deletarconta", (req, res) => {
    const { user_name, senha }  = req.body;

    console.log(user_name);
    console.log(senha);

        //Verifica se senha é realmente a senha do usuario
        if(result.affectedRows > 0 || senha === senhaenha){    
            //Deleta a conta do cliente
            connection.query('DELETE FROM CLIENTE_CONTA WHERE user_name = ? AND senha = ?', [user_name, senha], (errCompra, resultCompra) => {
                if (errCompra) throw errCompra;

                res.render("index");
            });
        }else{
            res.send('Credenciais inválidas ou a conta não foi encontrada.'); //Envia uma aviso de que algun dado está invalido
        }
    });

// Rota para a página de cadastro
app.post('/cadastro', (req, res) => {
    const { nome_completo, email, senha, cpf } = req.body; // Esses dados vão vir do formulário que o usuário digitou

    connection.query('SELECT * FROM CLIENTE WHERE email = ? OR cpf = ?', [email, cpf], (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Erro ao verificar usuário. Por favor, tente novamente.');
            return;
        }

        if (results.length > 0) {
            res.send('Email ou CPF já cadastrado. Por favor, escolha outro.');
        } else {
            const usuario = { nome_completo, email, senha, cpf };

            connection.query('INSERT INTO CLIENTE SET ?', usuario, (err, results) => {
                if (err) {
                    console.error(err);
                    res.status(500).send('Erro ao cadastrar usuário. Por favor, tente novamente.');
                    return;
                }
                res.redirect('/loginPage');
            });
        }
    });
});

// Rota para a página de fazer login
app.post('/login', (req, res) => {
    const { email, senha } = req.body; // Traz do formulário o email e a senha do usuário
    clienteEmail = email; // Salva o email do usuário
    clienteSenha = senha;

    // Comando select para saber se as informações que o usuário digitou estão no banco de dados
    connection.query(
        'SELECT * FROM CLIENTE WHERE email = ? AND senha = ?',
        [email, senha],
        (err, results) => {
            if (err) throw err;

            // Se estiver certo será redirecionado para a página de opções
            if (results.length > 0) {
                clienteNome = results[0].nome_completo; // Salva o nome do usuário
                res.redirect('/options');
            } else {
                res.send('Credenciais inválidas!');
            }
        }
    );
});

// Rota para a página de cadastrar quarto
app.get('/upRoom', (req, res) => {
    res.render('upRoom');
});

// Rota para tratar os dados do formulário de cadastro de quarto
app.post('/upRoom', (req, res) => {
    const { NumeroQuarto, TipoQuarto, Preco, Status } = req.body; // Extrai os dados do formulário

    // Define o objeto quarto com os dados do formulário
    const quarto = { NumeroQuarto, TipoQuarto, Preco, Status };

    // Insere os dados do quarto no banco de dados
    connection.query('INSERT INTO QUARTO SET ?', quarto, (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Erro ao cadastrar quarto. Por favor, tente novamente.');
            return;
        }
        res.redirect('/options'); // Redireciona para a página de opções após o cadastro bem-sucedido
    });
});


// Rota para a página de pagamento
app.get('/payment', (req, res) => {
    const { numeroQuarto, TipoQuarto, Preco } = req.query;
    console.log('Dados passados para a view payment:', { numeroQuarto, TipoQuarto, Preco });
    res.render('payment', { numeroQuarto, TipoQuarto, Preco });
});


// Rota para finalizar a reserva
app.post('/finalizar-reserva', (req, res) => {
    // Dados do formulário
    const { numeroQuarto, TipoQuarto, Preco, DataCheckIn, DataCheckOut, FK_Email, metodoPagamento } = req.body;

    // Verifica se Preço é um número válido
    const preco = parseFloat(Preco);
    if (isNaN(preco)) {
        console.error('Preço inválido:', Preco);
        res.status(400).send('Preço inválido');
        return;
    } 
    // Dados do quarto
    const quarto = {
        NumeroQuarto: numeroQuarto,
        TipoQuarto: TipoQuarto,
        Preco: Preco,
        Status: 'Ocupado'
    };

    // Dados da reserva
    const reserva = {
        FK_Id_quarto: null, // Será definido após a inserção do quarto
        FK_Email: FK_Email,
        DataCheckIn: DataCheckIn,
        DataCheckOut: DataCheckOut,
        MetodoPagamento: metodoPagamento // Adicione se for necessário
    };

    // Inserir dados na tabela 'quarto'
    connection.query('INSERT INTO quarto SET ?', quarto, (err, resultQuarto) => {
        if (err) {
            console.error('Erro ao inserir quarto:', err);
            res.status(500).send('Erro ao finalizar a reserva (quarto)');
            return;
        }

        // Obter o ID do quarto inserido
        const idQuartoInserido = resultQuarto.insertId;

        // Atualizar o ID do quarto na reserva
        reserva.FK_Id_quarto = idQuartoInserido;

        // Inserir dados na tabela 'reserva'
        connection.query('INSERT INTO reserva SET ?', reserva, (err, resultReserva) => {
            if (err) {
                console.error('Erro ao inserir reserva:', err);
                res.status(500).send('Erro ao finalizar a reserva (reserva)');
                return;
            }

            // Sucesso na inserção
            res.status(200).send('Reserva finalizada com sucesso');
        });
    });
});


// Rota para a página de histórico de reservas
app.get('/historic', (req, res) => {
    const clienteEmail = req.query.email; // Assumindo que o email vem da query string

    // Conexão com Banco de Dados
    // Faz o select das reservas que o cliente fez
    connection.query(`SELECT quarto.NumeroQuarto, quarto.TipoQuarto, quarto.Preco, reserva.DataCheckIn, reserva.DataCheckOut
                      FROM quarto
                      JOIN reserva ON quarto.Id_quarto = reserva.FK_Id_quarto
                      JOIN cliente ON cliente.email = reserva.FK_Email
                      WHERE cliente.email = ?`, [clienteEmail], (err2, total) => {
        if (err2) {
            console.error('Não contem reservas feitas:', err2);
            res.status(500).send('Não existem reservas para serem exibidas');
            return;
        }
        console.log(total);
        res.render('historic', { reservas: total }); // Renderiza a página historico.ejs com o nome correto da variável
    });
});



// Inicia o servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});