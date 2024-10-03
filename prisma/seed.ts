import prisma from "../src/config/database.js";
import { faker } from "@faker-js/faker";

const INSTITUICAO_QTD = 3000; // Ajuste conforme necessário
const CLIENTE_QTD = 3000; // Número total de clientes a serem criados
const CONTA_QTD = 3000; // Número total de contas a serem criadas
const TRANSAÇÃO_QTD = 3000; // Número total de transações a serem criadas

async function main() {
    // Criar instituições e localidades
    for (let i = 0; i < INSTITUICAO_QTD; i++) {
        console.log(`Criando instituição ${i + 1} / ${INSTITUICAO_QTD}`);

        const instituicao = await prisma.instituicao.create({
            data: {
                nome_instituicao: faker.company.name(),
            }
        });

        const localidade = await prisma.localidade.create({
            data: {
                
                cidade: faker.location.city(),
                estado: faker.location.state(),
                pais: faker.location.country(),
                cep: faker.location.zipCode(),
                bairro: faker.location.streetAddress(),
                logradouro: faker.location.street(),
            }
        });

        const agencia = await prisma.agencia.create({
            data: {
                nome_agencia: faker.company.name(),
                numero_agencia: faker.number.int(),
                id_instituicao: instituicao.id_instituicao,
                id_localidade: localidade.id_localidade,
            }
        });

       // Criar clientes para cada instituição
    for (let j = 0; j < CLIENTE_QTD / INSTITUICAO_QTD; j++) {
            // Criar o cliente no banco de dados
            const clienteData =  {
                    tipo_cliente: 'PF',
                    cpf: faker.string.numeric(11),
                    nome: faker.person.firstName() ,
                    sobrenome: faker.person.lastName(),
                    sexo: faker.helpers.arrayElement(['F', 'M']),
                    localidade: {
                        connect: { id_localidade: localidade.id_localidade }
                    },
                }
                const cliente = await prisma.cliente.create({
                    data: clienteData
                });

            console.log(`Cliente criado: ${cliente}`);

            // Criar contas para cada cliente
            for (let k = 0; k < CONTA_QTD / CLIENTE_QTD; k++) {
                await prisma.conta.create({
                    data: {
                        numero_conta: faker.string.numeric(8),
                        digito: faker.string.numeric(1),
                        data_abertura: faker.date.past(),
                        id_agencia: agencia.id_agencia,
                        id_cliente: cliente.id_cliente,
                    }
                });
            }

            // Criar transações para cada conta
            const contas = await prisma.conta.findMany({
                where: { id_cliente: cliente.id_cliente },
            });

            for (let l = 0; l < TRANSAÇÃO_QTD / CONTA_QTD; l++) {
                await prisma.transacao.create({
                    data: {
                        data_transacao: faker.date.recent(),
                        tipo_transacao: faker.helpers.arrayElement(['Depósito', 'Saque']),
                        valor: faker.number.int({ min: 1, max: 1000 }),
                        descricao: faker.lorem.sentence(),
                        id_conta: contas[faker.number.int({ min: 0, max: contas.length - 1 })].id_conta,
                    }
                });
            }
        }
    }
}


main().then(async() => {
    await prisma.$disconnect();
}).catch(async (e)=> {
    console.log(e);
    await prisma.$disconnect();
    process.exit(1);
})


