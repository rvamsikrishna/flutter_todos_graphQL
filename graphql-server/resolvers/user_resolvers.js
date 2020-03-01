const bcrypt = require("bcrypt");
const { User, validate } = require("../models/user");

module.exports = {
  signup: async args => {
    const { error } = validate(args.input);
    if (error) throw new Error(error.details[0].message);

    try {
      let user = await User.findOne({ email: args.input.email });
      if (user) throw new Error("User already exists.");

      user = new User({
        name: args.input.name,
        email: args.input.email,
        password: args.input.password
      });

      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(user.password, salt);

      await user.save();

      const token = user.generateAuthToken();
      user.token = token;
      user.populate = null;
      return user;
    } catch (error) {
      throw error;
    }
  },
  login: async args => {
    const { error } = validate(args.input);
    if (error) throw new Error(error.details[0].message);

    let user;
    try {
      user = await User.findOne({ email: args.input.email });
      if (!user) throw new Error("Email address does not exists.");

      const passwordMatches = await bcrypt.compare(
        args.input.password,
        user.password
      );
      if (!passwordMatches) throw new Error("Password does not match");

      const token = user.generateAuthToken();
      user.token = token;
      user.password = null;

      return user;
    } catch (error) {
      throw error;
    }
  }
};
