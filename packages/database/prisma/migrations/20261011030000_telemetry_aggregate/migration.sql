CREATE TABLE "TelemetryAggregate" (
    "id" UUID NOT NULL,
    "screenId" UUID NOT NULL,
    "hour" TIMESTAMP(3) NOT NULL,
    "sampleCount" INTEGER NOT NULL,
    "cpuAverage" DOUBLE PRECISION NOT NULL,
    "cpuMaximum" DOUBLE PRECISION NOT NULL,
    "memoryAverageBytes" BIGINT NOT NULL,
    "memoryMaximumBytes" BIGINT NOT NULL,
    "temperatureAverageC" DOUBLE PRECISION,
    "throttledSamples" INTEGER NOT NULL,
    "droppedFramesMaximum" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "TelemetryAggregate_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "TelemetryAggregate_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES "Screen"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "TelemetryAggregate_screenId_hour_key" ON "TelemetryAggregate"("screenId", "hour");
CREATE INDEX "TelemetryAggregate_screenId_hour_idx" ON "TelemetryAggregate"("screenId", "hour");
