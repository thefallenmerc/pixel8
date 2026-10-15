-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "idToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "refreshTokenExpiresAt" TIMESTAMP(3),
    "scope" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verification" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),

    CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "App" (
    "id" UUID NOT NULL,
    "ownerId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "App_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Asset" (
    "id" UUID NOT NULL,
    "appId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "sizeBytes" BIGINT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'uploading',
    "sourceKey" TEXT,
    "sourceSha256" TEXT,
    "thumbnailKey" TEXT,
    "width" INTEGER,
    "height" INTEGER,
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Upload" (
    "id" UUID NOT NULL,
    "assetId" UUID NOT NULL,
    "objectKey" TEXT NOT NULL,
    "multipartId" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Upload_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Campaign" (
    "id" UUID NOT NULL,
    "appId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "revision" INTEGER NOT NULL DEFAULT 1,
    "currentRevision" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'preparing',
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Campaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CampaignRevision" (
    "id" UUID NOT NULL,
    "campaignId" UUID NOT NULL,
    "revision" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'preparing',
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CampaignRevision_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CampaignItem" (
    "id" UUID NOT NULL,
    "revisionId" UUID NOT NULL,
    "assetId" UUID NOT NULL,
    "ordinal" INTEGER NOT NULL,
    "durationSeconds" INTEGER NOT NULL,
    "fit" TEXT NOT NULL,

    CONSTRAINT "CampaignItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rendition" (
    "id" UUID NOT NULL,
    "assetId" UUID NOT NULL,
    "profile" TEXT NOT NULL,
    "cacheKey" TEXT NOT NULL,
    "fit" TEXT NOT NULL,
    "durationSeconds" DOUBLE PRECISION NOT NULL,
    "orientation" INTEGER NOT NULL,
    "objectKey" TEXT NOT NULL,
    "sha256" TEXT NOT NULL,
    "sizeBytes" BIGINT NOT NULL,
    "mimeType" TEXT NOT NULL DEFAULT 'video/mp4',
    "width" INTEGER NOT NULL,
    "height" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Rendition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CampaignItemVariant" (
    "id" UUID NOT NULL,
    "itemId" UUID NOT NULL,
    "renditionId" UUID NOT NULL,
    "profile" TEXT NOT NULL,
    "orientation" INTEGER NOT NULL,

    CONSTRAINT "CampaignItemVariant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Screen" (
    "id" UUID NOT NULL,
    "ownerId" TEXT NOT NULL,
    "appId" UUID,
    "name" TEXT NOT NULL,
    "campaignId" UUID,
    "orientation" INTEGER NOT NULL DEFAULT 0,
    "muted" BOOLEAN NOT NULL DEFAULT true,
    "volume" INTEGER NOT NULL DEFAULT 50,
    "desiredVersion" INTEGER NOT NULL DEFAULT 1,
    "playingVersion" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'offline',
    "lastSeenAt" TIMESTAMP(3),
    "error" TEXT,
    "deviceTokenHash" TEXT,
    "deviceTokenCiphertext" TEXT,
    "deviceId" TEXT,
    "capabilities" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Screen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pairing" (
    "id" UUID NOT NULL,
    "deviceId" TEXT NOT NULL,
    "codeHash" TEXT NOT NULL,
    "pollTokenHash" TEXT NOT NULL,
    "capabilities" JSONB NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "claimedAt" TIMESTAMP(3),
    "screenId" UUID,
    "encryptedDeviceToken" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Pairing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Telemetry" (
    "id" UUID NOT NULL,
    "screenId" UUID NOT NULL,
    "sampledAt" TIMESTAMP(3) NOT NULL,
    "payload" JSONB NOT NULL,
    "dedupeKey" TEXT NOT NULL,

    CONSTRAINT "Telemetry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ManifestRecord" (
    "id" UUID NOT NULL,
    "screenId" UUID NOT NULL,
    "version" INTEGER NOT NULL,
    "body" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ManifestRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DesiredState" (
    "id" UUID NOT NULL,
    "screenId" UUID NOT NULL,
    "version" INTEGER NOT NULL,
    "campaignId" UUID,
    "campaignRevision" INTEGER,
    "orientation" INTEGER NOT NULL,
    "muted" BOOLEAN NOT NULL,
    "volume" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DesiredState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Job" (
    "id" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" TIMESTAMP(3),
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "error" TEXT,

    CONSTRAINT "Job_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "session"("token");

-- CreateIndex
CREATE INDEX "session_userId_idx" ON "session"("userId");

-- CreateIndex
CREATE INDEX "account_userId_idx" ON "account"("userId");

-- CreateIndex
CREATE INDEX "verification_identifier_idx" ON "verification"("identifier");

-- CreateIndex
CREATE INDEX "App_ownerId_idx" ON "App"("ownerId");

-- CreateIndex
CREATE UNIQUE INDEX "Asset_sourceKey_key" ON "Asset"("sourceKey");

-- CreateIndex
CREATE INDEX "Asset_appId_status_idx" ON "Asset"("appId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "Upload_assetId_key" ON "Upload"("assetId");

-- CreateIndex
CREATE UNIQUE INDEX "Upload_objectKey_key" ON "Upload"("objectKey");

-- CreateIndex
CREATE INDEX "Campaign_appId_idx" ON "Campaign"("appId");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignRevision_campaignId_revision_key" ON "CampaignRevision"("campaignId", "revision");

-- CreateIndex
CREATE INDEX "CampaignItem_assetId_idx" ON "CampaignItem"("assetId");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignItem_revisionId_ordinal_key" ON "CampaignItem"("revisionId", "ordinal");

-- CreateIndex
CREATE UNIQUE INDEX "Rendition_cacheKey_key" ON "Rendition"("cacheKey");

-- CreateIndex
CREATE UNIQUE INDEX "Rendition_objectKey_key" ON "Rendition"("objectKey");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignItemVariant_itemId_profile_orientation_key" ON "CampaignItemVariant"("itemId", "profile", "orientation");

-- CreateIndex
CREATE UNIQUE INDEX "Screen_deviceTokenHash_key" ON "Screen"("deviceTokenHash");

-- CreateIndex
CREATE INDEX "Screen_ownerId_idx" ON "Screen"("ownerId");

-- CreateIndex
CREATE INDEX "Screen_campaignId_idx" ON "Screen"("campaignId");

-- CreateIndex
CREATE UNIQUE INDEX "Pairing_codeHash_key" ON "Pairing"("codeHash");

-- CreateIndex
CREATE UNIQUE INDEX "Pairing_screenId_key" ON "Pairing"("screenId");

-- CreateIndex
CREATE INDEX "Telemetry_screenId_sampledAt_idx" ON "Telemetry"("screenId", "sampledAt");

-- CreateIndex
CREATE UNIQUE INDEX "Telemetry_screenId_dedupeKey_key" ON "Telemetry"("screenId", "dedupeKey");

-- CreateIndex
CREATE INDEX "ManifestRecord_screenId_createdAt_idx" ON "ManifestRecord"("screenId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "ManifestRecord_screenId_version_key" ON "ManifestRecord"("screenId", "version");

-- CreateIndex
CREATE UNIQUE INDEX "DesiredState_screenId_version_key" ON "DesiredState"("screenId", "version");

-- CreateIndex
CREATE INDEX "Job_processedAt_createdAt_idx" ON "Job"("processedAt", "createdAt");

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "App" ADD CONSTRAINT "App_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_appId_fkey" FOREIGN KEY ("appId") REFERENCES "App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Upload" ADD CONSTRAINT "Upload_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "Asset"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_appId_fkey" FOREIGN KEY ("appId") REFERENCES "App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignRevision" ADD CONSTRAINT "CampaignRevision_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignItem" ADD CONSTRAINT "CampaignItem_revisionId_fkey" FOREIGN KEY ("revisionId") REFERENCES "CampaignRevision"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignItem" ADD CONSTRAINT "CampaignItem_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "Asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rendition" ADD CONSTRAINT "Rendition_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "Asset"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignItemVariant" ADD CONSTRAINT "CampaignItemVariant_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "CampaignItem"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignItemVariant" ADD CONSTRAINT "CampaignItemVariant_renditionId_fkey" FOREIGN KEY ("renditionId") REFERENCES "Rendition"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Screen" ADD CONSTRAINT "Screen_appId_fkey" FOREIGN KEY ("appId") REFERENCES "App"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Screen" ADD CONSTRAINT "Screen_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pairing" ADD CONSTRAINT "Pairing_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES "Screen"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Telemetry" ADD CONSTRAINT "Telemetry_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES "Screen"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ManifestRecord" ADD CONSTRAINT "ManifestRecord_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES "Screen"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DesiredState" ADD CONSTRAINT "DesiredState_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES "Screen"("id") ON DELETE CASCADE ON UPDATE CASCADE;

