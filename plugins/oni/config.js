"use strict";
exports.__esModule = true;
var path = require("path");
var HOME = process.env.HOME;
exports.activate = function (oni) {
    console.info('Oni config activated');
    oni.input.bind('<c-enter>', function () { return console.info('Control+Enter was pressed'); });
    oni.input.bind(['<enter>', '<tab>'], 'contextMenu.select');
    // Remove default bindings:
    // oni.input.unbind("<c-p>")
};
exports.deactivate = function (oni) {
    console.info('Oni config deactivated');
};
exports.configuration = {
    'editor.fontFamily': 'mononokiNerdFontCM-Regular',
    'editor.fontSize': '15px',
    'editor.renderer': 'webgl',
    'environment.additionalPaths': [
        path.resolve(HOME, '.dotfiles', 'scripts'),
        path.resolve(HOME, '.dotlocal', 'bin'),
        path.resolve(HOME, '.yarn', 'bin'),
        path.resolve(HOME, '.n', 'bin'),
        path.resolve(HOME, 'bin'),
        '/usr/local/bin',
        '/usr/bin'
    ],
    'oni.useDefaultConfig': false,
    'ui.colorscheme': 'nord',
    'ui.fontSize': '15px'
};
