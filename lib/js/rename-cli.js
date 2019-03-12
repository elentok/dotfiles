"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const program = require("commander");
const path = require("path");
const fs = require("fs");
const chalk_1 = require("chalk");
const child_process_1 = require("child_process");
function main() {
    program
        .arguments('<pattern> <replacement> <file...>')
        .option('-y, --yes', "Don't ask for confirmation")
        .action((pattern, replacement, files, args) => {
        const matches = findMatches(pattern, replacement, files);
        if (matches.length === 0) {
            console.info('No matches');
            return;
        }
    });
    program.parse(process.argv);
}
function findMatches(pattern, replacement, files) {
    const re = new RegExp(pattern, 'ig');
    const matches = [];
    files.forEach(filename => {
        const basename = path.basename(filename);
        const newBasename = basename.replace(re, replacement);
        if (basename !== newBasename)
            matches.push(new Match(filename, newBasename));
    });
    return matches;
}
class Match {
    constructor(fromFullpath, toBasename) {
        this.fromFullpath = fromFullpath;
        this.toBasename = toBasename;
        this.fromDirname = path.dirname(fromFullpath);
        this.fromBasename = path.basename(fromFullpath);
        this.toFullpath = path.join(this.fromDirname, toBasename);
    }
    print(prefix = '') {
        console.info(`${prefix}${chalk_1.default.gray(this.fromDirname)}/${this.fromBasename}`);
        console.info(`${this.indent(prefix)} => ${chalk_1.default.blue(this.toBasename)}`);
    }
    rename() {
        if (this.isInGitRepo()) {
            child_process_1.execSync(`git mv '${this.fromFullpath}' '${this.toFullpath}'`);
        }
        else {
            fs.renameSync(this.fromDirname, this.toFullpath);
        }
    }
    indent(prefix) {
        let text = '';
        const indentWidth = Math.max(prefix.length + this.fromDirname.length - 3, 0);
        while (text.length < indentWidth)
            text += ' ';
        return text;
    }
    isInGitRepo() {
        return child_process_1.execSync(`git ls-files --error-unmatch ${this.fromFullpath} > /dev/null 2>&1`);
    }
}
main();
