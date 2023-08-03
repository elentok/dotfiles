// Phoenix.set({
//   openAtLogin: true,
// });

const margin = 10;
const CMD_SHIFT = ["command", "shift"];
const CONTROL_SHIFT = ["ctrl", "shift"];
const CONTROL_ALT_SHIFT = ["ctrl", "alt", "shift"];

function screenSize(screen) {
  const frame = screen.flippedVisibleFrame();
  return {
    x: frame.x + margin,
    y: frame.y + margin,
    width: frame.width - margin * 2,
    height: frame.height - margin * 2,
  };
}

Key.on("f", CMD_SHIFT, () => {
  const window = Window.focused();
  if (window) {
    const screen = screenSize(window.screen());
    window.setTopLeft({
      x: screen.x,
      y: screen.y,
    });

    window.setSize({
      width: screen.width,
      height: screen.height,
    });
  }
});

Key.on("l", CMD_SHIFT, () => {
  const window = Window.focused();
  if (window) {
    const screen = screenSize(window.screen());
    window.setTopLeft({
      x: screen.x + screen.width / 2 + margin / 2,
      y: screen.y,
    });

    window.setSize({
      width: screen.width / 2 - margin / 2,
      height: screen.height,
    });
  }
});

Key.on("h", CMD_SHIFT, () => {
  const window = Window.focused();
  const screen = screenSize(window.screen());
  if (window) {
    window.setTopLeft({
      x: screen.x,
      y: screen.y,
    });

    window.setSize({
      width: screen.width / 2 - margin / 2,
      height: screen.height,
    });
  }
});

// Key.on("l", ["command", "ctrl"], () => {
//   const window = Window.focused();
//   if (window) {
//     // console.log("Neighbors", window.neighbours("east").length);
//     // const neighbor = window.neighbours("east").find((w) => w.isVisible());
//     // console.log("First visible neighbor", neighbor);
//     const neighbor = findNextVisibleNeighbor(window, "east");
//     if (neighbor) {
//       logWindow(neighbor);
//       neighbor.raise();
//       neighbor.focus();
//     }
//   }
// });

function countTime(label, callback) {
  const startTime = Date.now();
  const result = callback();
  const elapsed = Date.now() - startTime;
  console.log(`COUNT TIME [${label}]: ${elapsed.toFixed(2)}sec`);

  return result;
}

function findNextVisibleNeighbor(window, direction) {
  // console.time("Find next visible neighbor");
  // const neighbor = window.neighbours(direction).find((w) => w.isVisible());
  const neighbor = countTime("Find neighbor", () => {
    return window.neighbours(direction).find((w) => w.isVisible());
  });
  if (neighbor) {
    countTime("Log neighbor", () => {
      logWindow(neighbor);
    });
  }
  // console.timeEnd("Find next visible neighbor");
  return neighbor;
}
//
// Key.on("h", ["command", "ctrl"], () => {
//   const window = Window.focused();
//   if (window) {
//     const neighbor = findNextVisibleNeighbor(window, "west");
//     if (neighbor) {
//       neighbor.raise();
//       neighbor.focus();
//     }
//   }
// });

function logWindow(window) {
  console.log("========================================");
  if (window == null) {
    console.log("Window is ", window);
    return;
  }
  console.log("Window title:", window.title());
  console.log("Window isVisible:", window.isVisible());
  const app = window.app();
  if (app) {
    console.log("Window app name:", app.name());
  }
  console.log("========================================");
}
