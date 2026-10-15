export async function aggregateExpiredTelemetry(tx: any, cutoff: Date) {
  await tx.$executeRaw`
    WITH expired AS (
      DELETE FROM "Telemetry"
      WHERE "sampledAt" < ${cutoff}
      RETURNING "screenId", "sampledAt", "payload"
    ), grouped AS (
      SELECT
        "screenId",
        date_trunc('hour', "sampledAt") AS hour,
        count(*)::int AS sample_count,
        avg(("payload"->>'cpuPercent')::double precision) AS cpu_average,
        max(("payload"->>'cpuPercent')::double precision) AS cpu_maximum,
        avg(("payload"->>'memoryUsedBytes')::double precision)::bigint AS memory_average,
        max(("payload"->>'memoryUsedBytes')::bigint) AS memory_maximum,
        count(*) FILTER (WHERE NULLIF("payload"->>'temperatureC', '') IS NOT NULL)::int AS temperature_count,
        avg(NULLIF("payload"->>'temperatureC', '')::double precision) AS temperature_average,
        count(*) FILTER (WHERE ("payload"->>'throttled')::boolean)::int AS throttled_samples,
        max(COALESCE(("payload"->>'droppedFrames')::int, 0)) AS dropped_frames_maximum
      FROM expired
      GROUP BY "screenId", date_trunc('hour', "sampledAt")
    )
    INSERT INTO "TelemetryAggregate" (
      "id", "screenId", "hour", "sampleCount", "cpuAverage", "cpuMaximum",
      "memoryAverageBytes", "memoryMaximumBytes", "temperatureSampleCount",
      "temperatureAverageC", "throttledSamples", "droppedFramesMaximum"
    )
    SELECT
      gen_random_uuid(), "screenId", hour, sample_count, cpu_average, cpu_maximum,
      memory_average, memory_maximum, temperature_count, temperature_average,
      throttled_samples, dropped_frames_maximum
    FROM grouped
    ON CONFLICT ("screenId", "hour") DO UPDATE SET
      "sampleCount" = "TelemetryAggregate"."sampleCount" + EXCLUDED."sampleCount",
      "cpuAverage" = (
        "TelemetryAggregate"."cpuAverage" * "TelemetryAggregate"."sampleCount" +
        EXCLUDED."cpuAverage" * EXCLUDED."sampleCount"
      ) / ("TelemetryAggregate"."sampleCount" + EXCLUDED."sampleCount"),
      "cpuMaximum" = GREATEST("TelemetryAggregate"."cpuMaximum", EXCLUDED."cpuMaximum"),
      "memoryAverageBytes" = (
        "TelemetryAggregate"."memoryAverageBytes" * "TelemetryAggregate"."sampleCount" +
        EXCLUDED."memoryAverageBytes" * EXCLUDED."sampleCount"
      ) / ("TelemetryAggregate"."sampleCount" + EXCLUDED."sampleCount"),
      "memoryMaximumBytes" = GREATEST("TelemetryAggregate"."memoryMaximumBytes", EXCLUDED."memoryMaximumBytes"),
      "temperatureAverageC" = CASE
        WHEN "TelemetryAggregate"."temperatureSampleCount" + EXCLUDED."temperatureSampleCount" = 0 THEN NULL
        ELSE (
          COALESCE("TelemetryAggregate"."temperatureAverageC", 0) * "TelemetryAggregate"."temperatureSampleCount" +
          COALESCE(EXCLUDED."temperatureAverageC", 0) * EXCLUDED."temperatureSampleCount"
        ) / ("TelemetryAggregate"."temperatureSampleCount" + EXCLUDED."temperatureSampleCount")
      END,
      "temperatureSampleCount" = "TelemetryAggregate"."temperatureSampleCount" + EXCLUDED."temperatureSampleCount",
      "throttledSamples" = "TelemetryAggregate"."throttledSamples" + EXCLUDED."throttledSamples",
      "droppedFramesMaximum" = GREATEST("TelemetryAggregate"."droppedFramesMaximum", EXCLUDED."droppedFramesMaximum")
  `;
}
