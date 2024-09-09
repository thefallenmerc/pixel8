import { io, Socket } from 'socket.io-client';

export function connectSocket(): Socket {
    return io('http://192.168.11.207:5000');
}