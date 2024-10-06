import prisma from "../src/config/database.js";
import { faker } from "@faker-js/faker";

let totalContasCriadas = 0;
const INSTITUICAO_QTD = 1000;
const CLIENTE_QTD = 10000;
const CONTA_QTD = 10000;
const TRANSACAO_QTD = 50000;
const BATCH_SIZE = 500; // Inserção em blocos de 100 registros

async function main() {
  // Criar instituições e localidades em blocos

  for (let i = 0; i < INSTITUICAO_QTD; i += BATCH_SIZE) {
    const instituicaoBatch = [];
    const localidadeBatch = [];
    const qtd_instituicao = await prisma.instituicao.count();

    for (let j = 0; j < BATCH_SIZE && qtd_instituicao + j < INSTITUICAO_QTD; j++) {
      console.log(`Criando instituição ${i + j + 1} de ${INSTITUICAO_QTD}`);
      instituicaoBatch.push({
        nome_instituicao: faker.company.name(),
      });

      console.log(`Criando localidade para instituição ${i + j + 1}`);
      localidadeBatch.push({
        cidade: faker.location.city(),
        estado: faker.location.state(),
        pais: faker.location.country(),
        cep: faker.location.zipCode(),
        bairro: faker.location.streetAddress(),
        logradouro: faker.location.street(),
      });
    }

    // Inserção em massa de instituições e localidades
    await prisma.instituicao.createMany({ data: instituicaoBatch });
    await prisma.localidade.createMany({ data: localidadeBatch });

    // Buscar as instituições e localidades recém-criadas
    const instituicoes = await prisma.instituicao.findMany({
      skip: i,
      take: BATCH_SIZE,
    });

    const localidades = await prisma.localidade.findMany({
      skip: i,
      take: BATCH_SIZE,
    });

    const agenciaBatch = [];

    // Criar agências vinculadas às instituições e localidades criadas
    for (let j = 0; j < instituicoes.length; j++) {
      console.log(`Criando agência para instituição ${i + j + 1}`);
      agenciaBatch.push({
        nome_agencia: faker.company.name(),
        numero_agencia: faker.number.int({ min: 1000, max: 9999 }),
        id_instituicao: instituicoes[j].id_instituicao,
        id_localidade: localidades[j].id_localidade,
      });
    }

    // Inserção em massa das agências
    await prisma.agencia.createMany({ data: agenciaBatch });

    // Buscar as agências recém-criadas
    const agencias = await prisma.agencia.findMany({
      skip: i,
      take: BATCH_SIZE,
    });

    // Criar clientes em blocos
    for (let j = 0; j < CLIENTE_QTD; j += BATCH_SIZE) {
      const clienteBatch = [];
      const clienteContasBatch = [];
      const transacaoBatch = [];
      const qtd_cliente = await prisma.cliente.count();  // Otimização para contar fora dos loops

      for (let k = 0; k < BATCH_SIZE && qtd_cliente + k < CLIENTE_QTD; k++) {
        console.log(`Criando cliente ${j + k + 1} de ${CLIENTE_QTD}`);
        clienteBatch.push({
          tipo_cliente: 'PF',
          cpf: faker.string.numeric(11),
          nome: faker.person.firstName(),
          sobrenome: faker.person.lastName(),
          sexo: faker.helpers.arrayElement(['F', 'M']),
          id_localidade: localidades[faker.number.int({ min: 0, max: localidades.length - 1 })].id_localidade,
        });
      }

      // Inserção em massa de clientes
      await prisma.cliente.createMany({ data: clienteBatch });

      // Buscar os clientes recém-criados
      const clientes = await prisma.cliente.findMany({
        skip: j,
        take: BATCH_SIZE,
      });

      // Criar uma conta única para cada cliente, garantindo o limite de contas
      for (let idx = 0; idx < clientes.length && totalContasCriadas < CONTA_QTD; idx++) {
        // Verifica se o limite de contas já foi atingido
        if (totalContasCriadas >= CONTA_QTD) break;

        // Criar uma conta única para cada cliente, garantindo o limite de contas
          console.log(`Criando conta única para cliente ${idx + 1}`);
          clienteContasBatch.push({
            numero_conta: faker.string.numeric(8),
            digito: faker.string.numeric(1),
            data_abertura: faker.date.past(),
            id_agencia: agencias[faker.number.int({ min: 0, max: agencias.length - 1 })].id_agencia,
            id_cliente: clientes[idx].id_cliente,
          });
          totalContasCriadas++; // Incrementar a contagem de contas criadas
      }

      // Inserção em massa de contas
      if (clienteContasBatch.length > 0) {
        await prisma.conta.createMany({ data: clienteContasBatch });
      }

      // Buscar as contas recém-criadas
      const contas = await prisma.conta.findMany({
        skip: j,
        take: BATCH_SIZE,
      });

      const qtd_transacao = await prisma.transacao.count();  // Otimização para contar fora dos loops
      // Criar transações vinculadas às contas
      contas.forEach((conta, idx) => {
        for (let l = 0; l < TRANSACAO_QTD / CONTA_QTD && qtd_transacao + l < TRANSACAO_QTD; l++) {
          console.log(`Criando transação ${l + 1} para conta ${idx + 1}`);
          transacaoBatch.push({
            data_transacao: faker.date.recent(),
            tipo_transacao: faker.helpers.arrayElement(['Depósito', 'Saque']),
            valor: faker.number.int({ min: 1, max: 1000 }),
            descricao: faker.lorem.sentence(),
            id_conta: conta.id_conta,
          });
        }
      });

      // Inserção em massa de transações
      await prisma.transacao.createMany({ data: transacaoBatch });
    }
  }

  console.log("Inserção de dados completa.");
}

// Executar a função
main()
  .catch(error => {
    console.error(error);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
