import { NextResponse } from "next/server"

export const response = {
    status200: (data: any) => NextResponse.json(data, { status: 200 }),
    status201: (data: any) => NextResponse.json(data, { status: 201 }),
    status204: (data: any) => NextResponse.json(data, { status: 204 }),
    status400: (data: any) => NextResponse.json(data, { status: 400 }),
    status401: (data: any) => NextResponse.json(data, { status: 401 }),
    status403: (data: any) => NextResponse.json(data, { status: 403 }),
    status404: (data: any) => NextResponse.json(data, { status: 404 }),
    status405: (data: any) => NextResponse.json(data, { status: 405 }),
    status409: (data: any) => NextResponse.json(data, { status: 409 }),
    status422: (data: any) => NextResponse.json(data, { status: 422 }),
    status429: (data: any) => NextResponse.json(data, { status: 429 }),
    status500: (data: any) => NextResponse.json(data, { status: 500 }),
    status503: (data: any) => NextResponse.json(data, { status: 503 }),
}
