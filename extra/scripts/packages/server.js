const path = require("path");
const express = require("express");
const app = express();
const OrderRepo = require("./order-repo");
const TrackingNumber = require("./tracking-number");
const { getImagesDir } = require("./utils");

app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));

app.use("/images", express.static(getImagesDir()));

app.get("/", (req, res) => {
  OrderRepo.reset();
  res.render("index", { orders: OrderRepo.all() });
});

app.get("/reset", (req, res) => {
  OrderRepo.reset();
  res.status(200).send("OK");
});

app.get("/track-all", (req, res) => {
  Promise.all(OrderRepo.getTrackable().map((o) => o.track())).then((results) => {
    OrderRepo.save();
    res.json(results.filter((r) => r.changed).map((r) => r.order));
  });
});

app.get("/track/:number", (req, res) => {
  const number = new TrackingNumber(req.params.number);
  if (number.canTrack()) {
    number.track().then((result) => res.json(result));
  } else {
    res.status(401).json({ error: "Invalid tracking number" });
  }
});

app.get("/orders/:id/archive", (req, res) => {
  const order = OrderRepo.findById(req.params.id);
  OrderRepo.archive(order);
  res.status(200).send("OK");
});

app.get("/orders/:id/addTracking/:number", (req, res) => {
  const order = OrderRepo.findById(req.params.id);
  order.addTracking(req.params.number);
  OrderRepo.save();
  res.status(200).send("OK");
});

if (process.argv.includes("--public")) {
  app.listen(9999, () => {
    console.info("Packages server listening at port 9999 (public)");
  });
} else {
  app.listen(9999, "127.0.0.1", () => {
    console.info("Packages server listening at port 9999 (internal)");
  });
}
