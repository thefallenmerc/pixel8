// Import the necessary modules
const http = require('http');
const { Server } = require('socket.io');

// Create an HTTP server
const server = http.createServer((req, res) => {
    if (req.method === 'POST' && req.url === '/emit-event') {
        handleRequest(req, res);
    } else {
        // Handle other routes
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Socket.IO server is running');
    }
});

/**
 * Handle POST Request
 * @param {*} req 
 * @param {*} res 
 */
function handleRequest(req, res) {
    let body = '';

    // Gather the incoming data
    req.on('data', chunk => {
        body += chunk.toString();
    });

    // When all data is received
    req.on('end', () => {
        try {
            const { eventName, data } = JSON.parse(body);

            // Ensure both eventName and data are present
            if (!eventName || !data) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                return res.end(JSON.stringify({ error: 'eventName and data are required' }));
            }

            // Emit the event to all connected clients
            io.emit(eventName, data);

            // Send a success response
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ success: true, eventName, data }));
        } catch (error) {
            // Handle parsing or other errors
            res.writeHead(400, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Invalid JSON format' }));
        }
    });
}

// Create a Socket.IO server and attach it to the HTTP server
const io = new Server(server, {
    cors: {
        origin: '*', // Allow the React client to connect
        methods: ['GET', 'POST'], // Allow specific methods
    }
});

// Listen for new connections
io.on('connection', (socket) => {
    console.log('A user connected');

    // Listen for a custom event
    socket.on('message', (msg) => {
        console.log('Message received: ', msg);

        // Broadcast the message to other connected clients
        socket.broadcast.emit('message', msg);
    });

    // Handle disconnection
    socket.on('disconnect', () => {
        console.log('A user disconnected');
    });
});

// Start the HTTP server
server.listen(5000, "0.0.0.0", () => {
    console.log('Server is running on port 5000');
});
