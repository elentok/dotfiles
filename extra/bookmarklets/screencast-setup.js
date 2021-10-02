function screencastSetup() {
  const oldItems = localStorage.getItem("screencast-items") || "";
  var newItems = prompt('Enter items separated by "||"', oldItems);
  if (newItems != null) {
    localStorage.setItem("screencast-items", newItems);
  }
}

screencastSetup();
