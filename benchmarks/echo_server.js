const net = require('net');
const { IP, PORT } = require('./common.js');

const server = net.createServer((socket) => {
  console.log('Client connected');

  socket.on('data', (data) => {
    console.log(`Received ${data.length} bytes`);
    socket.write(data);
  });

  socket.on('end', () => {
    console.log('Client disconnected');
  });
});

server.listen(PORT, IP, () => {
  console.log('Echo server listening on ${IP}:${PORT}');
});

