import * as Oni from "oni-api";
import * as path from "path";
import * as React from "react";

// const HOME: string = process.env.HOME;

export const activate = (oni: Oni.Plugin.Api) => {
  console.info("Oni config activated");

  oni.input.bind("<c-enter>", () => console.info("Control+Enter was pressed"));
  oni.input.bind(["<enter>", "<tab>"], "contextMenu.select");

  // Remove default bindings:
  // oni.input.unbind("<c-p>")
};

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.info("Oni config deactivated");
};

export const configuration = {
  "editor.fontFamily": "mononokiNerdFontCM-Regular",
  "editor.fontSize": "15px",
  "editor.renderer": "webgl",
  "environment.additionalPaths": [
    "$HOME/.dotfiles/scripts",
    "$HOME/.dotlocal/bin",
    "$HOME/.n/bin",
    "$HOME/bin",
    // path.resolve(HOME, ".dotfiles", "scripts"),
    // path.resolve(HOME, ".dotlocal", "bin"),
    // path.resolve(HOME, ".yarn", "bin"),
    // path.resolve(HOME, ".n", "bin"),
    // path.resolve(HOME, "bin"),
    "/usr/local/bin",
    "/usr/bin"
  ],
  "oni.useDefaultConfig": false, // the default configs clash with my own
  "sidebar.default.open": false,
  "ui.colorscheme": "nord",
  "ui.fontSize": "15px",
  "tabs.mode": "spaces"
};
