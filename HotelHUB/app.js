/*
    Projeto de Banco de Dados feito por Brenda Castro da Silva e Flavia Alessandra de Jesus.

    Para iniciar o npm use este comando no terminal na pasta do seu projeto: npm init -y
    Para instalar as dependências nescessárias use o comando no terminal na pasta em que seu projeto está: npm install express ejs mysql2
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
    password: "", //Senha do servidor
    database: "reserva_hotel", //Nome do banco de dados
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
    const { nome_completo, email, senha, cpf} = req.body; //Esses dados vão vir do formulário que o usuario digitou

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
    
     });//Fim

//Rota para a pagina de fazer login
app.post('/login', (req, res) => {
    const { email, senha } = req.body; //Traz do formulario o email e a senha do usuario
     clienteEmail = email; //Salva o email do usuario
     clienteSenha = senha;

     //Comando select para saber se as informações que o usuario digitou estão no banco de dados
     connection.query(
         'SELECT * FROM CLIENTE WHERE email = ? AND senha = ?', [email, senha],
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
//Inicia o servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});//Fim

