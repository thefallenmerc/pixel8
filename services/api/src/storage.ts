import {
  S3Client,
  CreateMultipartUploadCommand,
  UploadPartCommand,
  CompleteMultipartUploadCommand,
  AbortMultipartUploadCommand,
  HeadObjectCommand,
  GetObjectCommand,
} from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import { config } from "./config.js";
export const s3 = new S3Client({
  region: config.s3Region,
  endpoint: config.s3Endpoint,
  forcePathStyle: true,
  credentials: {
    accessKeyId: config.s3AccessKey,
    secretAccessKey: config.s3SecretKey,
  },
});
const signer = new S3Client({
  region: config.s3Region,
  endpoint: config.s3PublicEndpoint,
  forcePathStyle: true,
  credentials: {
    accessKeyId: config.s3AccessKey,
    secretAccessKey: config.s3SecretKey,
  },
});
export const startMultipart = async (key: string, mime: string) =>
  (
    await s3.send(
      new CreateMultipartUploadCommand({
        Bucket: config.bucket,
        Key: key,
        ContentType: mime,
      }),
    )
  ).UploadId!;
export const signPart = (key: string, uploadId: string, partNumber: number) =>
  getSignedUrl(
    signer,
    new UploadPartCommand({
      Bucket: config.bucket,
      Key: key,
      UploadId: uploadId,
      PartNumber: partNumber,
    }),
    { expiresIn: 900 },
  );
export const completeMultipart = (
  key: string,
  uploadId: string,
  parts: { partNumber: number; etag: string }[],
) =>
  s3.send(
    new CompleteMultipartUploadCommand({
      Bucket: config.bucket,
      Key: key,
      UploadId: uploadId,
      MultipartUpload: {
        Parts: parts.map((p) => ({ PartNumber: p.partNumber, ETag: p.etag })),
      },
    }),
  );
export const abortMultipart = (key: string, uploadId: string) =>
  s3.send(
    new AbortMultipartUploadCommand({
      Bucket: config.bucket,
      Key: key,
      UploadId: uploadId,
    }),
  );
export const headObject = (key: string) =>
  s3.send(new HeadObjectCommand({ Bucket: config.bucket, Key: key }));
export const signedObject = (key: string, seconds = 300) =>
  getSignedUrl(
    signer,
    new GetObjectCommand({ Bucket: config.bucket, Key: key }),
    { expiresIn: seconds },
  );
