"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const program = require("commander");
const renameable_1 = require("./renameable");
const utils_1 = require("./utils");
function main() {
    program
        .arguments('<pattern> <replacement> <file...>')
        .option('-y, --yes', "Don't ask for confirmation")
        .action((pattern, replacement, files, args) => __awaiter(this, void 0, void 0, function* () {
        const renameables = renameable_1.findRenameables(pattern, replacement, files);
        if (renameables.length === 0) {
            console.info('No files to rename');
            return;
        }
        renameables.forEach(r => r.print('   '));
        if (args.yes || (yield utils_1.confirm('Rename?'))) {
            renameables.forEach(r => {
                r.print('Renaming ');
                r.rename();
            });
        }
    }));
    program.parse(process.argv);
}
main();
//# sourceMappingURL=rename-cli.js.map