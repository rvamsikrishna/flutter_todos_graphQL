const mongoose = require("mongoose");

const todoSchema = new mongoose.Schema({
  title: String,
  body: {
    type: String,
    required: true
  },
  completed: {
    type: Boolean,
    default: false
  },
  createdOn: {
    type: String,
    required: true
  },
  creator: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  }
});

const Todo = mongoose.model("Todo", todoSchema);
module.exports = Todo;
