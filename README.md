
# Jogo de Adivinhação com Flask

Este é um simples jogo de adivinhação desenvolvido utilizando o framework Flask. O jogador deve adivinhar uma senha criada aleatoriamente, e o sistema fornecerá feedback sobre o número de letras corretas e suas respectivas posições.

## Design

A aplicação executa inteiramente em containers Docker, orquestrados utilizando o Docker Compose.

Há um arquivo docker-compose.yml na pasta raiz, que descreve como a aplicação deve ser provisionada. Nele estão descritos três serviços: nginx, backend e db. Há ainda o provisonamento de uma rede para que os containers se comuniquem entre si e um volume para o container de banco de dados, que armazena os dados do PostgreSQL na máquina host, impedindo a perda de dados caso o container do banco de dados seja destruído.

O container nginx executa o servidor HTTP/proxy reverso Nginx. O Nginx fornece os arquivos estáticos da aplicação React (arquivos JS, CSS e HTML). Há um arquivo dockerfile em frontend/frontend.dockerfile que descreve o procedimento de build desse container. Esse build é *multistage*, ou seja, cria um container para efetuar o build da aplicação React (que é descartado após o fim do build) e outro que efetivamente contém a aplicação buildada. Isso é uma funcionalidade muito útil do Docker, pois permite a criação de uma imagem de container menor, pois não há todas as dependências que são necessárias para o build no container que fornece a aplicação frontend (esse container tem apenas o Nginx, sem as ferramentas de build, como o NPM). Além disso, o Nginx desse container atua como *proxy* reverso, redirecionando as requisições HTTP para a API.

O container backend executa a aplicação Python que fornece a API da aplicação. Ele executa um servidor Gunicorn. Seu dockerfile está na raiz do projeto e se chama backend.dockerfile. Nesse caso se preferiu não utilizar *multistage* pois essa aplicação é escrita em Python, que é uma linguagem interpretada, portanto não há build. Esse container contém apenas o Gunicorn e as dependências da API. Há replicação de instâncias da API feita pelo Docker Compose, para garantir maior disponibilidade. Variáveis de ambiente são carregadas via um *dotfile* (.env).

Por fim, há um container que hospeda o banco de dados PostgreSQL. Nele há um volume mapeando a pasta de dados do PostgreSQL para o diretório postgres-data, o que garante que não haverá perda de dados caso esse container seja excluído.

## Instalação

Como a aplicação está orquestrada utilizando Docker Compose, basta rodar o seguinte comando para iniciá-la:

* ```docker compose up --build```

Variáveis de ambiente são passada por um arquivo .env na raiz do projeto. Há um exemplo de arquivo também na raiz, chamado .env.example. Ele contém as seguintes variáveis:

* FLASK_APP: Nome do arquivo inicial da aplicação Flask. Padrão é run.py.

Há variáveis que guardam os dados de conexão da API com o banco de dados:

* FLASK_DB_TYPE: Tipo de banco de dados a ser utilizado. Padrão é postgres. Pode se usar o sqlite também;
FLASK_DB_USER: Nome de usuário do banco de dados PostgreSQL;
FLASK_DB_NAME: Nome do banco de dados;
FLASK_DB_HOST: Hostname do banco de dados;
FLASK_DB_PASSWORD: Senha do banco de dados;
FLASK_DB_PORT: Porta TCP do PostgreSQL. Padrão é 5432.

E a seguir, as variáveis para configuração do PostgreSQL

POSTGRES_USER: Usuário do PostgreSQL;
POSTGRES_PASSWORD: Senha do PostgreSQL;
POSTGRES_DB: Nome do *schema* do PostgreSQL.
