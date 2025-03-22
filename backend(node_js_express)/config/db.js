const mongoose = require('mongoose');


const connection = mongoose.createConnection('mongodb://localhost:27017/toDo').on('open',()=>{
    console.log('mongodb connected');
}).on('error',()=>{
    console.log("mongo db connection error");
});

module.exports = connection;