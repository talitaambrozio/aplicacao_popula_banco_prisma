# Aplicação para Popular Banco de Dados 📊

Esta aplicação foi desenvolvida para facilitar a população de um banco de dados utilizando dados fictícios. É uma ferramenta útil para testar e validar o funcionamento de sistemas que dependem de informações em um banco de dados.

## Tecnologias Utilizadas ⚙️

Esta aplicação utiliza as seguintes tecnologias:

- **Node.js**: Ambiente de execução JavaScript do lado do servidor.
- **Prisma**: ORM para facilitar a interação com o banco de dados.
- **Faker.js**: Biblioteca para gerar dados fictícios.
- **TypeScript**: Superconjunto do JavaScript que adiciona tipagem estática.
- **MySQL**: Sistema de gerenciamento de banco de dados relacional.

## Começando a Utilizar ▶️

### Variáveis de Ambiente ⚙️

Antes de executar a aplicação, configure suas variáveis de ambiente. Certifique-se de definir a variável `DATABASE_URL` que contém a URL de conexão ao seu banco de dados MySQL. A variável deve ter o seguinte formato:

**DATABASE_URL="mysql://usuario@localhost:3306/nome_do_banco"**


### Executando a Aplicação ▶️

Siga os passos abaixo para executar a aplicação:

1. **Gerar o Cliente Prisma**: 
   Gere o cliente Prisma com base no esquema definido no arquivo `schema.prisma`. Execute o seguinte comando:

   ```bash
   npx prisma generate

2. **Aplicar as Migrações**: Aplique as migrações do banco de dados para o ambiente de desenvolvimento. Execute o seguinte comando:

    ```bash 
    npx prisma migrate dev

3. **Executar o Script de Semeadura**: Execute o script para popular o banco de dados com dados fictícios. Utilize o comando abaixo:

    ```bash 
    npx tsx prisma/seed.ts

## Contribuição 🤝    
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.
