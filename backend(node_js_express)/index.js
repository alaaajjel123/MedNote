const app = require('./app');
const db = require('./config/db')

const UserModel = require('./model/user.model')
const TodoModel = require('./model/todo.model')

const port =3000;

app.get('/',(req,res)=>{
    res.send("hello marzou9 dhouha")
})

app.listen(port,()=>{
    console.log(`Server listening on port http://localhost:${port}`);
});