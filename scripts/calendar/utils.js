/* globals document */

function div(className, content = null) {
  const el = document.createElement('div')
  el.className = className
  if (content != null) {
    add(el, content)
  }
  return el
}

function add(parent, children) {
  if (children == null) {
    return
  }
  if (children.forEach) {
    children.forEach(child => addSingle(parent, child))
  } else {
    addSingle(parent, children)
  }
}

function addSingle(parent, child) {
  if (child == null) {
    return
  }

  if (typeof child === 'string') {
    child = document.createTextNode(child)
  }

  parent.appendChild(child)
}
