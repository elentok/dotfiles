"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.help = void 0;
const path = require("path");
const fs = require("fs");
const chalk = require("chalk");
const child_process_1 = require("child_process");
const fg = require("fast-glob");
const HELP_FILENAME = path.join(process.env.DOTF || '', 'docs', 'help.md');
const LOCAL_HELP_GLOB = path.join(process.env.DOTL || '', 'docs', '*.md');
function help() {
    const query = process.argv[2];
    if (query === 'e') {
        child_process_1.execSync(`nvim ${HELP_FILENAME}`, { stdio: 'inherit' });
    }
    else {
        console.info(findSections(HELP_FILENAME, query).join('\n'));
        fg.sync(LOCAL_HELP_GLOB).forEach((filename) => {
            console.info(findSections(filename, query).join('\n'));
        });
    }
}
exports.help = help;
function findSections(filename, query) {
    const sections = [];
    let sectionLines = [];
    fs.readFileSync(filename)
        .toString()
        .split('\n')
        .forEach((line) => {
        if (isBeginningOfSection(line)) {
            addSection(sections, sectionLines.join('\n'), query);
            sectionLines = [line];
        }
        else {
            sectionLines.push(line);
        }
    });
    addSection(sections, sectionLines.join('\n'), query);
    return sections;
}
function isBeginningOfSection(line) {
    return /^#/.test(line);
}
function addSection(sections, section, query) {
    if (/^\s*$/.test(section))
        return;
    if (query == null) {
        sections.push(section);
    }
    else if (isMatch(section, query)) {
        sections.push(highlightQuery(section, query));
    }
}
function isMatch(section, query) {
    return new RegExp(query, 'i').test(section);
}
function highlightQuery(section, query) {
    const highlight = chalk.bold.green(query);
    return section.replace(new RegExp(query, 'ig'), highlight);
}
//# sourceMappingURL=help.js.map