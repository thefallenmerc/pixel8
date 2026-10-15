#!/bin/sh
set -eu
awslocal s3api create-bucket --bucket pixel8
awslocal s3api put-bucket-cors --bucket pixel8 --cors-configuration '{"CORSRules":[{"AllowedHeaders":["*"],"AllowedMethods":["GET","PUT","HEAD","POST","DELETE"],"AllowedOrigins":["http://localhost:3000","http://127.0.0.1:3000"],"ExposeHeaders":["ETag"],"MaxAgeSeconds":3600}]}'
