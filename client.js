var io = require('socket.io-client')

//var socket = io.connect('http://localhost:5000');
var socket = io.connect('http://betabot.herokuapp.com');
socket.on('angles:changed', function (data) {
  console.log('angles are ',data);
});
console.log('client is listening!')

