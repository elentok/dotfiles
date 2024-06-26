function copyTitle() {
  const title = getTitle()
  if (title == null) {
    alert("Title not found")
    return
  }

  copyToClipboard(title)
  alert(`Copied '${title}' to clipboard`)
}

function getTitle() {
  if (/atlassian.net/.test(window.location.host)) {
    return getJiraTitle()
  }

  if (/github.com/.test(window.location.host)) {
    return getGithubTitle()
  }
}

function getGithubTitle() {
  const ticketAndTitle = document.querySelector(".js-issue-title").innerText
  const prId = window.location.pathname.split("/").reverse()[0]

  return `saas#${prId} ${ticketAndTitle}`
}

function getJiraTitle() {
  const name = document.querySelector(
    '[data-testid="issue.views.issue-base.foundation.summary.heading"]'
  ).innerText

  const id = document.querySelector(
    '[data-testid="issue.views.issue-base.foundation.breadcrumbs.current-issue.item"]'
  ).innerText

  return `${id}: ${name}`
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
