const express = require('express');
const app = express();
const path = require('path');
var bodyParser = require('body-parser');
const server = require('http').createServer(app);
const io = require('socket.io')(server);

server.listen(3100, () => {
  console.log('app is runing');
});

var bodyParser = require('body-parser');
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

let userLists = [{ "UserId": 1, "userName": "user1", "password": 12345 }, { "UserId": 2, "userName": "user2", "password": 12345 }, { "UserId": 3, "userName": "user3", "password": 12345 }, { "UserId": 4, "userName": "user4", "password": 12345 }, { "UserId": 5, "userName": "user5", "password": 12345 }, { "UserId": 6, "userName": "user6", "password": 12345 }];

app.post('/login', function (req, res) {
  if (req.body.userName) {
    let userPresent = userLists.filter((user) => {
      return user.userName == req.body.userName.trim();
    });
    if (userPresent.length > 0) {
      console.log('succes')
      return res.json(userPresent);
    } else {
      return res.json([]);
    }
  }
})

app.get('/test', function (req, res) {
  return res.json(
    [{
      userId: 1,
      socketId: 'sdfgvbn',
      name: 1
    }, {
      userId: 2,
      socketId: 'sdfvfhjdfgvbn',
      name: 2
    }]);

});

const users = {};

io.on('connection', socket => {
  var user = {}
  user['userId'] = parseInt(socket.handshake.query.userId);
  user['socketId'] = socket.id;
  user['name'] = user['userId'];
  users[user['userId']] = user;

  socket.on('checkIfOnline', (friends) => {
    friends = JSON.parse(friends);
    friends.map(friend => {
      if (users.hasOwnProperty(friend.userId)) {
        friend.socketId = users[friend.userId].socketId
      } else {
        friend.socketId = null;
      }
    });
  });

  console.log(users);
  io.emit('userConnected', users);

  socket.on('privateMessage', message => {
    message = JSON.parse(message);
    io.to(message.to).emit('privateMessage', JSON.stringify(message));
  });

  socket.on('groupMessage', message => {
    console.log(message);
  });

  socket.on('disconnect', () => {
    let keys = Object.keys(users);
    console.log(socket.id);
    for (let i = 0; i < keys.length; i++) {
      if (users[keys[i]].socketId === socket.id) {
        delete users[keys[i]];
        break;
      }
    }
    io.emit('disConnected', users);

  });
  
})






