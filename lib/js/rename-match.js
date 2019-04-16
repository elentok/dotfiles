"use strict";
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
        console.info(`${prefix}${chalk.gray(this.fromDirname)}/${this.fromBasename}`);
        console.info(`${this.indent(prefix)} => ${chalk.blue(this.toBasename)}`);
    }
    rename() {
        if (this.isInGitRepo()) {
            execSync(`git mv '${this.fromFullpath}' '${this.toFullpath}'`);
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
        try {
            execSync(`git ls-files --error-unmatch ${this.fromFullpath} > /dev/null 2>&1`);
            return true;
        }
        catch (error) {
            return false;
        }
    }
}
