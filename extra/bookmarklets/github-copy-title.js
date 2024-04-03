function copyTitle() {
  const ticketAndTitle = document.querySelector(".js-issue-title").innerText
  const prId = window.location.pathname.split("/").reverse()[0]

  const title = `saas#${prId} ${ticketAndTitle}`
  copyToClipboard(title)
  alert(`Copied '${title}' to clipboard)`)
}

function copyToClipboard(text) {
  const textarea = document.createElement("textarea")
  textarea.value = text
  document.body.appendChild(textarea)

  textarea.select()
  document.execCommand("copy")
  textarea.remove()
}

copyTitle()
