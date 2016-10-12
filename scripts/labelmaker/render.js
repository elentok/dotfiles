/* globals window document */

function render(labels) {
  const root = document.querySelector(".root")
  labels.forEach(label => {
    const body = div("label__body", [
      div(`label__icon fa fa-${label.icon}`),
      div("label__title", label.title)
    ])

    if (label.subtitle != null) {
      add(body, div("label__subtitle", label.subtitle))
    }

    add(root, div("label", body))
  })
}

function div(className, content) {
  const el = document.createElement("div")
  el.className = className
  add(el, content)
  return el
}

function add(parent, children) {
  if (children == null) { return }
  if (children.forEach) {
    children.forEach(child => addSingle(parent, child))
  } else {
    addSingle(parent, children)
  }
}

function addSingle(parent, child) {
  if (child == null) { return }

  if (typeof child === "string") {
    child = document.createTextNode(child)
  }

  parent.appendChild(child)
}

render(window.labels)
