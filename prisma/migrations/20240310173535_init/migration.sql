-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "employee";

-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "media";

-- CreateEnum
CREATE TYPE "employee"."FileType" AS ENUM ('employee', 'order');

-- CreateEnum
CREATE TYPE "employee"."OrderType" AS ENUM ('manual', 'import');

-- CreateEnum
CREATE TYPE "employee"."OrderStatus" AS ENUM ('new', 'paid', 'released', 'canceled', 'inconsistent');

-- CreateEnum
CREATE TYPE "employee"."PaymentMode" AS ENUM ('billet', 'pix');

-- CreateEnum
CREATE TYPE "employee"."Gender" AS ENUM ('male', 'female', 'other');

-- CreateTable
CREATE TABLE "employee"."EmpCompany" (
    "id" SERIAL NOT NULL,
    "document" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "contactName" TEXT,
    "contactPhoneNbr" TEXT,
    "logoImagePath" TEXT,
    "addrZipCode" TEXT NOT NULL,
    "addrStreet" TEXT NOT NULL,
    "addrNbr" TEXT NOT NULL,
    "addrComplement" TEXT,
    "addrDistrict" TEXT NOT NULL,
    "addrCity" TEXT NOT NULL,
    "addrState" TEXT NOT NULL,
    "addrCountry" TEXT NOT NULL,
    "toSysCode" INTEGER,
    "externalId" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpCompany_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpCompanyCredential" (
    "id" SERIAL NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "document" TEXT NOT NULL,
    "photoPath" TEXT,
    "cognitoClientId" TEXT NOT NULL,
    "isAdmin" BOOLEAN NOT NULL,
    "lastLoginDate" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpCompanyCredential_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpEmployeeGroup" (
    "id" SERIAL NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "longDescription" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpEmployeeGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpEmployee" (
    "id" SERIAL NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "document" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "birthDate" TIMESTAMP(3) NOT NULL,
    "hrID" TEXT,
    "motherName" TEXT,
    "dailyValue" INTEGER,
    "empEmployeeGroupId" INTEGER,
    "cardNumber" TEXT,
    "gender" "employee"."Gender",
    "email" TEXT,
    "phone" TEXT,
    "addrZipCode" TEXT NOT NULL,
    "addrStreet" TEXT NOT NULL,
    "addrNbr" TEXT NOT NULL,
    "addrComplement" TEXT,
    "addrDistrict" TEXT NOT NULL,
    "addrCity" TEXT NOT NULL,
    "addrState" TEXT,
    "addrCountry" TEXT,
    "toSysCode" INTEGER,
    "externalId" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpEmployee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpImportFile" (
    "id" SERIAL NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileType" "employee"."FileType" NOT NULL,
    "isProcessed" BOOLEAN NOT NULL,
    "isSuccess" BOOLEAN NOT NULL,
    "errorMessage" TEXT,
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpImportFile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpImportFileLine" (
    "id" SERIAL NOT NULL,
    "empImportFileId" INTEGER NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "lineNumber" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "isProcessed" BOOLEAN NOT NULL,
    "isSuccess" BOOLEAN NOT NULL,
    "errorMsg" TEXT,
    "processDate" TIMESTAMP(3),
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpImportFileLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpOrder" (
    "id" SERIAL NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "totalValue" INTEGER NOT NULL,
    "adminTax" INTEGER NOT NULL,
    "isPaid" BOOLEAN NOT NULL,
    "paymentDate" TIMESTAMP(3),
    "isReleased" BOOLEAN NOT NULL,
    "releaseDate" TIMESTAMP(3),
    "cancelDate" TIMESTAMP(3),
    "cancelUser" TEXT,
    "isActive" BOOLEAN NOT NULL,
    "orderType" "employee"."OrderType" NOT NULL,
    "empImportFileId" INTEGER,
    "billetFilePath" TEXT,
    "paymentTransferCode" TEXT,
    "status" "employee"."OrderStatus" NOT NULL DEFAULT 'new',
    "paymentMode" "employee"."PaymentMode",
    "isProcessed" BOOLEAN NOT NULL DEFAULT false,
    "processMessage" TEXT,
    "toSysCode" INTEGER,
    "externalId" INTEGER,
    "blameUser" TEXT,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmpOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee"."EmpOrderItem" (
    "id" SERIAL NOT NULL,
    "empOrderId" INTEGER NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "empEmployeeId" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "cardNumber" TEXT,

    CONSTRAINT "EmpOrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "EmpCompany_document_key" ON "employee"."EmpCompany"("document");

-- CreateIndex
CREATE UNIQUE INDEX "EmpCompanyCredential_email_key" ON "employee"."EmpCompanyCredential"("email");

-- CreateIndex
CREATE INDEX "EmpCompanyCredential_document_idx" ON "employee"."EmpCompanyCredential"("document");

-- CreateIndex
CREATE UNIQUE INDEX "EmpCompanyCredential_empCompanyId_document_key" ON "employee"."EmpCompanyCredential"("empCompanyId", "document");

-- CreateIndex
CREATE UNIQUE INDEX "EmpEmployee_empCompanyId_document_key" ON "employee"."EmpEmployee"("empCompanyId", "document");

-- CreateIndex
CREATE UNIQUE INDEX "EmpOrder_empImportFileId_key" ON "employee"."EmpOrder"("empImportFileId");

-- AddForeignKey
ALTER TABLE "employee"."EmpCompanyCredential" ADD CONSTRAINT "EmpCompanyCredential_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpEmployeeGroup" ADD CONSTRAINT "EmpEmployeeGroup_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpEmployee" ADD CONSTRAINT "EmpEmployee_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpEmployee" ADD CONSTRAINT "EmpEmployee_empEmployeeGroupId_fkey" FOREIGN KEY ("empEmployeeGroupId") REFERENCES "employee"."EmpEmployeeGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpImportFile" ADD CONSTRAINT "EmpImportFile_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpImportFileLine" ADD CONSTRAINT "EmpImportFileLine_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpImportFileLine" ADD CONSTRAINT "EmpImportFileLine_empImportFileId_fkey" FOREIGN KEY ("empImportFileId") REFERENCES "employee"."EmpImportFile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpOrder" ADD CONSTRAINT "EmpOrder_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpOrder" ADD CONSTRAINT "EmpOrder_empImportFileId_fkey" FOREIGN KEY ("empImportFileId") REFERENCES "employee"."EmpImportFile"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpOrderItem" ADD CONSTRAINT "EmpOrderItem_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpOrderItem" ADD CONSTRAINT "EmpOrderItem_empOrderId_fkey" FOREIGN KEY ("empOrderId") REFERENCES "employee"."EmpOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee"."EmpOrderItem" ADD CONSTRAINT "EmpOrderItem_empEmployeeId_fkey" FOREIGN KEY ("empEmployeeId") REFERENCES "employee"."EmpEmployee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
