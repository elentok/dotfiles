"use strict";
exports.__esModule = true;
var path = require("path");
var HOME = process.env.HOME;
exports.activate = function (oni) {
    console.log('config activated');
    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind('<c-enter>', function () { return console.log('Control+Enter was pressed'); });
    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")
};
exports.deactivate = function (oni) {
    console.log('config deactivated');
};
exports.configuration = {
    //add custom config here, such as
    'ui.colorscheme': 'nord',
    //"oni.useDefaultConfig": true,
    //"oni.bookmarks": ["~/Documents"],
    'editor.fontSize': '16px',
    'ui.fontSize': '16px',
    //"editor.fontFamily": "Monaco",
    // UI customizations
    // "ui.animations.enabled": true,
    // "ui.fontSmoothing": "auto",
    'environment.additionalPaths': [
        path.resolve(HOME, '.dotfiles', 'scripts'),
        path.resolve(HOME, '.dotlocal', 'bin'),
        path.resolve(HOME, '.yarn', 'bin'),
        path.resolve(HOME, '.n', 'bin'),
        path.resolve(HOME, 'bin'),
        '/usr/local/bin',
        '/usr/bin'
    ]
};
