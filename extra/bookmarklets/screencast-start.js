function screencastStart() {
  class Screencast {
    constructor() {
      this.items = this.loadItems();
      this.el = this.createEl();
      this.goto(0);
    }

    loadItems() {
      const items = (localStorage.getItem("screencast-items") || "").split("||");
      if (items.length === 0) {
        alert("No items");
        throw new Error("No items");
      }
      return items;
    }

    goto(index) {
      this.currentIndex = index;
      this.setText(this.items[index]);
    }

    setText(text) {
      this.el.innerText = text;
      this.setVisible(true);
    }

    next() {
      if (this.isVisible()) {
        this.setVisible(false);
      } else {
        const nextIndex = this.currentIndex + 1;
        if (nextIndex < this.items.length) {
          this.goto(nextIndex);
        } else {
          this.setText("THE END");
        }
      }
    }

    isVisible() {
      return this.el.style.visibility !== "hidden";
    }

    setVisible(visible) {
      this.el.style.visibility = visible ? "visible" : "hidden";
    }

    createEl() {
      let el = document.getElementById("my-screencast");
      if (el != null) {
        el.remove();
      }

      const width = 400;
      const height = 300;

      el = document.createElement("div");
      el.id = "my-screencast";
      el.style.position = "fixed";
      el.style.width = `${width}px`;
      el.style.left = "50%";
      el.style.marginLeft = `-${width / 2}px`;
      el.style.height = `${height}px`;
      el.style.top = "50%";
      el.style.marginTop = `-${height / 2}px`;
      el.style.zIndex = 99999;
      el.style.backgroundColor = "rgba(0, 0, 0, 0.8)";
      el.style.borderRadius = "20px";
      el.style.display = "flex";
      el.style.alignItems = "center";
      el.style.justifyContent = "center";
      el.style.fontSize = "40px";
      el.style.fontFamily = "sans-serif";
      el.style.textAlign = "center";
      el.style.color = "white";
      document.body.appendChild(el);
      return el;
    }
  }

  window.screencast = new Screencast();
}

screencastStart();
