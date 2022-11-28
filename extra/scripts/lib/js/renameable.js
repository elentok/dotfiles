"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Renameable = exports.findRenameables = void 0;
const path = require("path");
const chalk = require("chalk");
const child_process_1 = require("child_process");
const shelljs_1 = require("shelljs");
function findRenameables(pattern, replacement, files) {
    const re = new RegExp(pattern, "ig");
    const matches = [];
    files.forEach((filename) => {
        const basename = path.basename(filename);
        const newBasename = basename.replace(re, replacement);
        if (basename !== newBasename)
            matches.push(new Renameable(filename, newBasename));
    });
    return matches;
}
exports.findRenameables = findRenameables;
class Renameable {
    constructor(fromFullpath, toBasename) {
        this.fromFullpath = fromFullpath;
        this.toBasename = toBasename;
        this.fromDirname = path.dirname(fromFullpath);
        this.fromBasename = path.basename(fromFullpath);
        this.toFullpath = path.join(this.fromDirname, toBasename);
    }
    print(prefix = "") {
        console.info(`${prefix}${chalk.gray(this.fromDirname)}/${this.fromBasename}`);
        console.info(`${this.indent(prefix)} => ${chalk.blue(this.toBasename)}`);
    }
    rename() {
        if (this.isInGitRepo()) {
            (0, child_process_1.execSync)(`git mv '${this.fromFullpath}' '${this.toFullpath}'`);
        }
        else {
            (0, shelljs_1.mv)(this.fromFullpath, this.toFullpath);
        }
    }
    indent(prefix) {
        let text = "";
        const indentWidth = Math.max(prefix.length + this.fromDirname.length - 3, 0);
        while (text.length < indentWidth)
            text += " ";
        return text;
    }
    isInGitRepo() {
        try {
            (0, child_process_1.execSync)(`git ls-files --error-unmatch ${this.fromFullpath} > /dev/null 2>&1`);
            return true;
        }
        catch (error) {
            return false;
        }
    }
}
exports.Renameable = Renameable;
//# sourceMappingURL=renameable.js.map