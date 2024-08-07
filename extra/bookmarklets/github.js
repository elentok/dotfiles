function markAsViewed() {
  console.info("Mark as viewed")
  Array.from(document.querySelectorAll(".js-reviewed-toggle"))
    .find((el) => !el.classList.contains("js-reviewed-file"))
    .click()
}

document.addEventListener("keydown", (e) => {
  if (e.key === "V") {
    markAsViewed()
  }
})
