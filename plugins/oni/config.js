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
    // the default configs clash with my own
    'oni.useDefaultConfig': false,
    //"oni.bookmarks": ["~/Documents"],
    'editor.fontSize': '15px',
    'ui.fontSize': '15px',
    'editor.fontFamily': 'mononokiNerdFontCM-Regular',
    'editor.renderer': 'webgl',
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
