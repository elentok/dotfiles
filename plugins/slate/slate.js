/* File: slate.example.js
 * Author: lunixbochs (Ryan Hileman)
 * Project: http://github.com/lunixbochs/reslate
 */

S.src('~/.dotfiles/slate/reslate.js')
// enable to see debug messages in Console.app
// $.debug = true;

slate.alias('hyper', 'ctrl;alt;cmd')

// begin config
slate.configAll({
  defaultToCurrentScreen: true,
  nudgePercentOf: 'screenSize',
  resizePercentOf: 'screenSize',
  undoOps: [
    'active-snapshot',
    'chain',
    'grid',
    'layout',
    'move',
    'resize',
    'sequence',
    'shell',
    'push'
  ]
})

// bindings
slate.bindAll({
  cmd: {
    f1: $.focus('iTerm'),
    f2: $.focus('Google Chrome')
  },
  hyper: {
    // bars
    h: [$('barResize', 'left', 2), $('barResize', 'left', 1.5)],
    j: $('barResize', 'bottom', 2),
    k: $('barResize', 'top', 2),
    l: [$('barResize', 'right', 2), $('barResize', 'right', 1.5)],

    // corners
    y: [$('corner', 'top-left'), $('corner', 'top-left', 1.5)],
    i: [$('corner', 'top-right'), $('corner', 'top-right', 1.5)],
    b: [$('corner', 'bottom-left'), $('corner', 'bottom-left', 1.5)],
    m: [$('corner', 'bottom-right'), $('corner', 'bottom-right', 1.5)],
    // centers
    u: $('center', 'top'),
    n: $('center', 'bottom'),

    //
    c: [
      $('center', 'center', 1.1, 1.1),
      $('center', 'center', 1.2, 1.2),
      $('center', 'center', 1.5, 1.5)
    ],

    //'return': $('center', 'center'),
    // throw to monitor
    return: ['throw 0 resize', 'throw 1 resize'],
    '1': $('toss', '0', 'resize'),
    '2': $('toss', '1', 'resize'),
    '3': $('toss', '2', 'resize'),
    // direct focus
    a: $.focus('Adium'),
    g: $.focus('Google Chrome'),
    t: $.focus('iTerm'),
    f: $.focus('Finder'),
    p: $.focus('Spotify'),
    // utility functions
    f1: 'relaunch',
    z: 'undo',
    tab: 'hint'
  }
})
