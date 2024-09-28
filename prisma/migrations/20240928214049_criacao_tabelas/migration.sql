-- CreateTable
CREATE TABLE `instituicao` (
    `id_instituicao` INTEGER NOT NULL AUTO_INCREMENT,
    `nome_instituicao` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id_instituicao`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `localidade` (
    `id_localidade` INTEGER NOT NULL AUTO_INCREMENT,
    `cidade` VARCHAR(191) NOT NULL,
    `estado` VARCHAR(191) NOT NULL,
    `pais` VARCHAR(191) NOT NULL,
    `cep` VARCHAR(191) NOT NULL,
    `bairro` VARCHAR(191) NOT NULL,
    `logradouro` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id_localidade`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `agencia` (
    `id_agencia` INTEGER NOT NULL AUTO_INCREMENT,
    `nome_agencia` VARCHAR(191) NOT NULL,
    `numero_agencia` INTEGER NOT NULL,
    `id_instituicao` INTEGER NOT NULL,
    `id_localidade` INTEGER NOT NULL,

    PRIMARY KEY (`id_agencia`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cliente` (
    `id_cliente` INTEGER NOT NULL AUTO_INCREMENT,
    `tipo_cliente` VARCHAR(191) NOT NULL,
    `cpf` VARCHAR(191) NOT NULL,
    `nome` VARCHAR(191) NOT NULL,
    `sobrenome` VARCHAR(191) NOT NULL,
    `sexo` VARCHAR(191) NOT NULL,
    `id_localidade` INTEGER NOT NULL,

    PRIMARY KEY (`id_cliente`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `conta` (
    `id_conta` INTEGER NOT NULL AUTO_INCREMENT,
    `numero_conta` VARCHAR(191) NOT NULL,
    `digito` VARCHAR(191) NOT NULL,
    `data_abertura` DATETIME(3) NOT NULL,
    `id_agencia` INTEGER NOT NULL,
    `id_cliente` INTEGER NOT NULL,

    PRIMARY KEY (`id_conta`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `transacao` (
    `id_transacao` INTEGER NOT NULL AUTO_INCREMENT,
    `data_transacao` DATETIME(3) NOT NULL,
    `tipo_transacao` VARCHAR(191) NOT NULL,
    `valor` INTEGER NOT NULL,
    `descricao` VARCHAR(191) NOT NULL,
    `id_conta` INTEGER NOT NULL,

    PRIMARY KEY (`id_transacao`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `agencia` ADD CONSTRAINT `agencia_id_instituicao_fkey` FOREIGN KEY (`id_instituicao`) REFERENCES `instituicao`(`id_instituicao`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `agencia` ADD CONSTRAINT `agencia_id_localidade_fkey` FOREIGN KEY (`id_localidade`) REFERENCES `localidade`(`id_localidade`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cliente` ADD CONSTRAINT `cliente_id_localidade_fkey` FOREIGN KEY (`id_localidade`) REFERENCES `localidade`(`id_localidade`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `conta` ADD CONSTRAINT `conta_id_agencia_fkey` FOREIGN KEY (`id_agencia`) REFERENCES `agencia`(`id_agencia`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `conta` ADD CONSTRAINT `conta_id_cliente_fkey` FOREIGN KEY (`id_cliente`) REFERENCES `cliente`(`id_cliente`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `transacao` ADD CONSTRAINT `transacao_id_conta_fkey` FOREIGN KEY (`id_conta`) REFERENCES `conta`(`id_conta`) ON DELETE RESTRICT ON UPDATE CASCADE;
