-- CreateTable
CREATE TABLE "media"."Cards" (
    "id" SERIAL NOT NULL,
    "empCompanyId" INTEGER NOT NULL,
    "cardNumber" TEXT,

    CONSTRAINT "Cards_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "media"."Cards" ADD CONSTRAINT "Cards_empCompanyId_fkey" FOREIGN KEY ("empCompanyId") REFERENCES "employee"."EmpCompany"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
