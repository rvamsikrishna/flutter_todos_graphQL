const Todo = require("../models/todo");
const { User } = require("../models/user");

function checkAuthorization(req) {
  if (!req.isAuth) {
    throw new Error("Not authorized.");
  }
}

module.exports = {
  todos: async (args, req) => {
    // checkAuthorization(req);
    try {
      const todos = await Todo.find({
        creator: args.creatorId
      }).populate("creator", "_id name email");
      return todos.map(todo => {
        todo.p;
        return { ...todo._doc, _id: todo.id };
      });
    } catch (error) {
      throw error;
    }
  },
  createTodo: async (args, req) => {
    checkAuthorization(req);

    const todo = new Todo({
      title: args.todo.title,
      body: args.todo.body,
      completed: args.todo.completed || false,
      createdOn: Date.now(),
      creator: args.todo.userId
    });

    try {
      const res = await todo.save();
      const creator = await User.findById(args.todo.userId);

      return {
        ...res._doc,
        _id: res.id,
        creator: { ...creator._doc, password: null, _id: creator.id }
      };
    } catch (error) {
      throw error;
    }
  },
  updateTodo: async (args, req) => {
    checkAuthorization(req);

    const todo = await Todo.findByIdAndUpdate(args.id, args.updatedTodo, {
      new: true
    });

    if (!todo) throw new Error("Does not exists anymore");
    return todo;
  },
  deleteTodo: async (args, req) => {
    checkAuthorization(req);

    const todo = await Todo.findByIdAndRemove(args.id);
    if (!todo) throw new Error("No todo found");
    return args.id;
  }
};
