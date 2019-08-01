const express = require("express");
const app = express();
const PORT = 3000;

app.get("/", function(req, res) {
  res.send("Hello world!");
});

app.listen(PORT, function() {
  console.log(`App is listening on port ${PORT}`);
});
