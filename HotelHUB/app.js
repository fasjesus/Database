/*
    Projeto de Banco de Dados feito por Brenda Castro da Silva e Flavia Alessandra de Jesus.

    Para iniciar o npm use este comando no terminal na pasta do seu projeto: npm init -y
    Para instalar as dependências necessárias use o comando no terminal na pasta em que seu projeto está: npm install express ejs mysql2 
                                                                                                          express-session body-parser
                                                                                                          npm install node-schedule
    Para executar esse código digite no terminal o comando: node app.js
    Para ver o resultado, vá no seu navegador e entre no link: http://localhost:3000
    Para finalizar clique em ctrl + c no terminal
*/

// Define configurações iniciais
const express = require("express");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
const session = require('express-session');
const app = express();
const port = 3000; // Porta que será usada
const schedule = require('node-schedule');


// Configura o banco de dados MySQL
const connection = mysql.createConnection({
    host: "localhost", // Nome do servidor
    user: "root", // Usuário do servidor
    password: "senia", // Senha do servidor
    database: "reserva_hotel", // Nome do banco de dados
});

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

// Configuração da sessão
app.use(session({
    secret: 'secreta', // Altere para uma chave secreta adequada
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Para desenvolvimento; use true com HTTPS em produção
}));

//INCLUIR PASTA PUBLIC o projeto
app.use(express.static('public'));

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
    if (req.session.nome) {
        res.render("options.ejs", { user_name: req.session.nome }); // Renderiza a página options.ejs passando o nome do usuário
    } else {
        res.redirect('/loginPage');
    }
});



// Rota para renderizar a página atualizar.ejs
app.get("/update", (req, res) => {
    if (!req.session.email) {
        return res.redirect('/loginPage'); // Redireciona para login se não autenticado
    }
    res.render("update.ejs"); // Renderiza a página atualizar.ejs
});

// Rota para fazer a atualização dos dados do usuário
app.post("/atualizarConta", (req, res) => {
    const { nome_completo, user_name, senha, idade } = req.body; // Pega os dados inseridos na página atualizar.ejs

    // Faz o update dos dados
    connection.query(
        'UPDATE CLIENTE SET nome_completo = ?, senha = ?, idade = ? WHERE user_name = ?',
        [nome_completo, senha, idade, user_name],
        (err, results) => {
            if (err) throw err;
            res.render("login.ejs"); // Depois de atualizar os dados o usuário é redirecionado para a página de login
        }
    );
});

// Rota para renderizar a página de deletar conta
app.get("/delete", (req, res) => {
    if (!req.session.email) {
        return res.redirect('/loginPage'); // Redireciona para login se não autenticado
    }
    res.render("delete.ejs"); // Renderiza a página deletar.ejs
});

// Rota para deletar conta
app.post("/deletarconta", (req, res) => {
    const { user_name, senha } = req.body;

    // Verifica se a senha é realmente a senha do usuário
    connection.query(
        'DELETE FROM CLIENTE WHERE user_name = ? AND senha = ?',
        [user_name, senha],
        (err, result) => {
            if (err) throw err;

            if (result.affectedRows > 0) {
                res.redirect('/'); // Redireciona para a página inicial após a exclusão
            } else {
                res.send('Credenciais inválidas ou a conta não foi encontrada.'); // Envia um aviso se algum dado está inválido
            }
        }
    );
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

    // Comando select para saber se as informações que o usuário digitou estão no banco de dados
    connection.query(
        'SELECT * FROM CLIENTE WHERE email = ? AND senha = ?',
        [email, senha],
        (err, results) => {
            if (err) throw err;

            // Se estiver certo será redirecionado para a página de opções
            if (results.length > 0) {
                req.session.email = email; // Armazenar o e-mail do cliente na sessão
                req.session.nome = results[0].nome_completo; // Opcional: armazenar o nome completo
                res.redirect('/options');
            } else {
                res.send('Credenciais inválidas!');
            }
        }
    );
});


// Rota para renderizar a página de lista de reservas
app.get("/reserveList", (req, res) => {
    const { status, tipo } = req.query;

    let query = `
        SELECT 
            QUARTO.NumeroQuarto, 
            QUARTO.TipoQuarto, 
            QUARTO.Status,
            QUARTO.Preco
        FROM 
            QUARTO
        LEFT JOIN 
            RESERVA ON QUARTO.Id_quarto = RESERVA.FK_Id_quarto
    `;
    let queryParams = [];

    if (status || tipo) {
        query += " WHERE";
        if (status) {
            query += " QUARTO.Status = ?";
            queryParams.push(status);
        }
        if (status && tipo) {
            query += " AND";
        }
        if (tipo) {
            query += " QUARTO.TipoQuarto = ?";
            queryParams.push(tipo);
        }
    }

    console.log('Query:', query); // Log da consulta SQL
    console.log('Query Params:', queryParams); // Log dos parâmetros da consulta

    connection.query(query, queryParams, (err, results) => {
        if (err) {
            console.error('Erro ao consultar reservas:', err);
            res.status(500).send('Erro ao consultar reservas');
            return;
        }

        console.log('Resultados da consulta:', results); // Log dos resultados da consulta

        res.render("reserveList", { quartos: results });
    });
});

// Rota para a página de pagamento
app.get('/payment', (req, res) => {
    const { NumeroQuarto, TipoQuarto } = req.query;

    console.log('Dados recebidos na rota /payment:', { NumeroQuarto, TipoQuarto }); // Log dos dados recebidos

    // Buscar o preço do quarto no banco de dados
    connection.query(
        'SELECT Preco FROM QUARTO WHERE NumeroQuarto = ? AND TipoQuarto = ?',
        [NumeroQuarto, TipoQuarto],
        (err, results) => {
            if (err) {
                console.error('Erro ao buscar preço do quarto:', err);
                res.status(500).send('Erro ao buscar preço do quarto');
                return;
            }

            console.log('Resultados da consulta de preço:', results); // Log dos resultados da consulta de preço

            if (results.length === 0) {
                res.status(400).send('Quarto não encontrado');
                return;
            }

            // Recupera o preço e remove símbolos e formata
            let Preco = results[0].Preco;
            if (Preco) {
                Preco = Preco.replace('R$', '').replace(',', '.');
                Preco = parseFloat(Preco);
            } else {
                Preco = 0;
            }

            console.log('Dados passados para a view payment:', { NumeroQuarto, TipoQuarto, Preco });
            res.render('payment', { NumeroQuarto, TipoQuarto, Preco });
        }
    );
});



// Rota para finalizar reserva
app.post('/finalizar-reserva', (req, res) => {
    const { NumeroQuarto, TipoQuarto, Preco, DataCheckIn, DataCheckOut, metodoPagamento } = req.body;

    console.log('Dados recebidos na rota /finalizar-reserva:', req.body);

    if (!NumeroQuarto || !TipoQuarto) {
        console.error('Dados do quarto não recebidos corretamente:', { NumeroQuarto, TipoQuarto });
        res.status(400).send('Dados do quarto não recebidos corretamente');
        return;
    }

    connection.query(
        'SELECT Id_quarto FROM QUARTO WHERE NumeroQuarto = ? AND TipoQuarto = ? AND Status = "Disponível"',
        [NumeroQuarto, TipoQuarto],
        (err, results) => {
            if (err) {
                console.error('Erro ao obter ID do quarto:', err);
                res.status(500).send('Erro ao finalizar a reserva');
                return;
            }

            if (results.length === 0) {
                console.error('Quarto não disponível:', { NumeroQuarto, TipoQuarto });
                res.status(400).send('Quarto não disponível');
                return;
            }

            const idQuarto = results[0].Id_quarto;
            console.log('ID do quarto encontrado:', idQuarto);

            // Atualizar o status do quarto para "Ocupado"
            connection.query(
                'UPDATE QUARTO SET Status = ? WHERE Id_quarto = ?',
                ['Ocupado', idQuarto],
                (err2) => {
                    if (err2) {
                        console.error('Erro ao atualizar o status do quarto:', err2);
                        res.status(500).send('Erro ao atualizar o status do quarto');
                        return;
                    }

                    // Inserir reserva
                    connection.query(
                        'INSERT INTO RESERVA (FK_Id_quarto, DataCheckIn, DataCheckOut, FK_Email, MetodoPagamento) VALUES (?, ?, ?, ?, ?)',
                        [idQuarto, DataCheckIn, DataCheckOut, req.session.email, metodoPagamento],
                        (err3) => {
                            if (err3) {
                                console.error('Erro ao inserir reserva:', err3);
                                res.status(500).send('Erro ao finalizar a reserva');
                                return;
                            }

                            res.status(200).send('Reserva finalizada com sucesso');

                            // Atualizar o status do quarto para "Disponível" após o checkout
                            const checkOutDate = new Date(DataCheckOut);
                            setTimeout(() => {
                                connection.query(
                                    'UPDATE QUARTO SET Status = ? WHERE Id_quarto = ?',
                                    ['Disponível', idQuarto],
                                    (err4) => {
                                        if (err4) {
                                            console.error('Erro ao atualizar o status do quarto na data de checkout:', err4);
                                        } else {
                                            console.log('Status do quarto atualizado para "Disponível" na data de checkout');
                                        }
                                    }
                                );
                            }, checkOutDate.getTime() - new Date().getTime());
                        }
                    );
                }
            );
        }
    );
});



// Rota para a página de histórico de reservas
app.get('/historic', (req, res) => {
    const clienteEmail = req.query.email; 

    // Faz o select das reservas que o cliente fez com ROLLUP para calcular o total gasto
    connection.query(`
        SELECT 
            quarto.NumeroQuarto, 
            quarto.TipoQuarto, 
            quarto.Preco, 
            reserva.DataCheckIn, 
            reserva.DataCheckOut,
            IFNULL(SUM(quarto.Preco), 0) AS totalGasto
        FROM 
            quarto
            JOIN reserva ON quarto.Id_quarto = reserva.FK_Id_quarto
            JOIN cliente ON cliente.email = reserva.FK_Email
        WHERE 
            cliente.email = ?
        GROUP BY 
            quarto.NumeroQuarto, quarto.TipoQuarto, quarto.Preco, reserva.DataCheckIn, reserva.DataCheckOut WITH ROLLUP
    `, [clienteEmail], (err, reservas) => {
        if (err) {
            console.error('Erro ao obter reservas:', err);
            res.status(500).send('Não existem reservas para serem exibidas');
            return;
        }

        // Extraindo o total gasto
        const totalGasto = reservas.find(reserva => reserva.NumeroQuarto === null)?.totalGasto || 0;
        const reservasList = reservas.filter(reserva => reserva.NumeroQuarto !== null);

        res.render('historic', { reservas: reservasList, totalGasto }); // Passa o totalGasto para a view
    });
});



// Inicia o servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});
