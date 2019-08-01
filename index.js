const express = require("express");
const _ = require("lodash");
const app = express();
const PORT = 3000;

app.get("/", function(req, res) {
  const who = _.without(["test", "world"], ["test"]);
  res.send(`Hello ${who[0]}!`);
});

app.listen(PORT, function() {
  console.log(`App is listening on port ${PORT}`);
});
