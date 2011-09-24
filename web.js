var express =  require('express');
var datetime =  require('datetime');

var app = express.createServer(express.logger());
var io = require('socket.io').listen(app)

//TODO: not web scale :)
var front=0;
var back=9;
var turn=4;

app.get('/',function(req,resp){
  resp.sendfile(__dirname + '/index.html');

});

io.sockets.on('connection', function (socket) {
  socket.emit('angles:changed',{front:front, back:back, turn:turn});
  socket.on('angles:change',function(data){
    front=data['front'];
    back=data['back'];
    turn=data['turn'];
    //this will be received by everyone
    io.sockets.emit('angles:changed',{front:front, back:back, turn:turn});
  });
  socket.on('dance',function(data){
    console.log('dance!!');
    io.sockets.emit('dance',{front:front, back:back, turn:turn});
  });
});


var port = process.env.PORT || 3000;
app.listen(port,function(){
  console.log("listening on "+port);
});
