function gotoJira() {
  const ticket = document.querySelector(".js-issue-title").innerText.split(" ")[0]
  window.open(`https://salto-io.atlassian.net/browse/${ticket}`, "_")
}

gotoJira()
