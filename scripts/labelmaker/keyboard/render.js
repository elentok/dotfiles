/* globals window document */

function render(keys) {
  const root = document.querySelector('.root')
  keys.forEach(key => {
    // const body = div('key__body')

    // if (key.primaryIcon) add(body, div('key__primary-icon', h('i', key.primaryIcon)))
    // if (key.primary) add(body, div('key__primary', key.primary))
    // if (key.shift) add(body, div('key__shift', key.shift))

    const html = key.replace(/\{([^}]+)\}/, (_, className) => `<i class="${className}" />`)
    const el = div('key')
    el.innerHTML = html

    add(root, el)
  })
}

function div(className, content) {
  return h('div', className, content)
}

function h(tagName, className, content) {
  const el = document.createElement(tagName)
  el.className = className
  add(el, content)
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

render(window.keys)
