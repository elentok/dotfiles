const path = require("path");
const express = require("express");
const app = express();
const OrderRepo = require("./order-repo");

app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));

app.get("/", (req, res) => {
  res.render("index", {
    orders: OrderRepo.load()
  });
});

app.listen(9999, () => {
  console.info("Packages server listening at port 9999");
});
