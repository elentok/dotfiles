function copyTitle() {
  const name = document.querySelector(
    '[data-testid="issue.views.issue-base.foundation.summary.heading"]'
  ).innerText

  const id = document.querySelector(
    '[data-testid="issue.views.issue-base.foundation.breadcrumbs.current-issue.item"]'
  ).innerText

  const title = `${id}: ${name}`
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
