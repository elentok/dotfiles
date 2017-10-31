const path = require("path");
const express = require("express");
const app = express();
const OrderRepo = require("./order-repo");
const TrackingNumber = require("./tracking-number");

app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));

app.get("/", (req, res) => {
  res.render("index", {
    orders: OrderRepo.load()
  });
});

app.get("/track/:number", (req, res) => {
  const number = new TrackingNumber(req.params.number);
  if (number.canTrack()) {
    number.track().then(result => res.json(result));
  } else {
    res.status(401).json({ error: "Invalid tracking number" });
  }
});

app.listen(9999, () => {
  console.info("Packages server listening at port 9999");
});
