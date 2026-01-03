/*
  Warnings:

  - You are about to drop the `bookings` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `trips` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `users` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "CostIndex" AS ENUM ('LOW', 'MEDIUM', 'HIGH');

-- CreateEnum
CREATE TYPE "ActivityType" AS ENUM ('FREE', 'PAID');

-- DropForeignKey
ALTER TABLE "bookings" DROP CONSTRAINT "bookings_tripId_fkey";

-- DropForeignKey
ALTER TABLE "bookings" DROP CONSTRAINT "bookings_userId_fkey";

-- DropForeignKey
ALTER TABLE "trips" DROP CONSTRAINT "trips_userId_fkey";

-- DropTable
DROP TABLE "bookings";

-- DropTable
DROP TABLE "trips";

-- DropTable
DROP TABLE "users";

-- CreateTable
CREATE TABLE "city_master" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "countryCode" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "costIndex" "CostIndex" NOT NULL,
    "popularityScore" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "city_master_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "activity_category_master" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "activity_category_master_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "activity_master" (
    "id" TEXT NOT NULL,
    "cityId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "averageCost" DOUBLE PRECISION,
    "durationInHours" DOUBLE PRECISION,
    "activityType" "ActivityType" NOT NULL,
    "popularityScore" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "activity_master_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cost_reference_master" (
    "id" TEXT NOT NULL,
    "cityId" TEXT NOT NULL,
    "accommodationCostPerNight" DOUBLE PRECISION NOT NULL,
    "foodCostPerDay" DOUBLE PRECISION NOT NULL,
    "localTransportCostPerDay" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "cost_reference_master_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "currency_master" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "symbol" TEXT NOT NULL,
    "exchangeRateToUSD" DOUBLE PRECISION NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "currency_master_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "city_master_name_idx" ON "city_master"("name");

-- CreateIndex
CREATE INDEX "city_master_country_idx" ON "city_master"("country");

-- CreateIndex
CREATE INDEX "city_master_popularityScore_idx" ON "city_master"("popularityScore");

-- CreateIndex
CREATE INDEX "city_master_isActive_idx" ON "city_master"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "activity_category_master_name_key" ON "activity_category_master"("name");

-- CreateIndex
CREATE INDEX "activity_category_master_name_idx" ON "activity_category_master"("name");

-- CreateIndex
CREATE INDEX "activity_master_name_idx" ON "activity_master"("name");

-- CreateIndex
CREATE INDEX "activity_master_cityId_idx" ON "activity_master"("cityId");

-- CreateIndex
CREATE INDEX "activity_master_categoryId_idx" ON "activity_master"("categoryId");

-- CreateIndex
CREATE INDEX "activity_master_activityType_idx" ON "activity_master"("activityType");

-- CreateIndex
CREATE INDEX "activity_master_popularityScore_idx" ON "activity_master"("popularityScore");

-- CreateIndex
CREATE INDEX "activity_master_isActive_idx" ON "activity_master"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "cost_reference_master_cityId_key" ON "cost_reference_master"("cityId");

-- CreateIndex
CREATE INDEX "cost_reference_master_cityId_idx" ON "cost_reference_master"("cityId");

-- CreateIndex
CREATE UNIQUE INDEX "currency_master_code_key" ON "currency_master"("code");

-- CreateIndex
CREATE INDEX "currency_master_code_idx" ON "currency_master"("code");

-- CreateIndex
CREATE INDEX "currency_master_isActive_idx" ON "currency_master"("isActive");

-- AddForeignKey
ALTER TABLE "activity_master" ADD CONSTRAINT "activity_master_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "city_master"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_master" ADD CONSTRAINT "activity_master_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "activity_category_master"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cost_reference_master" ADD CONSTRAINT "cost_reference_master_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "city_master"("id") ON DELETE CASCADE ON UPDATE CASCADE;
