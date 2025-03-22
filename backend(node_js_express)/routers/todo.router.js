const router = require("express").Router();
const ToDoController = require('../controllers/todo.controller');


//router.post("/createToDo",ToDoController.createToDo);

router.post('/getUserTodoList',ToDoController.getToDoList)


router.post("/deleteTodo",ToDoController.deleteToDo)


router.post("/storeToDo",ToDoController.createToDo);

module.exports = router;