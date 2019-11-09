"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const chalk_1 = require("chalk");
const utils_1 = require("./utils");
const moment = require("moment");
const FRIDAY = 5;
const SATURDAY = 6;
const TODAY = moment();
function main() {
    const date = process.argv.length > 2 ? moment(process.argv[2]) : moment();
    const month = new Month(date);
    console.info();
    month.prev().print();
    month.print();
    month.next().print();
}
class Month {
    constructor(date) {
        this.weeks = [];
        this.start = date.clone().startOf('month');
        this.buildWeeks();
    }
    print() {
        console.info(chalk_1.default.green(utils_1.center(this.start.format('MMM YYYY'), 27)));
        console.info('Sun Mon Tue Wed Thu Fri Sat');
        this.weeks.forEach(week => console.info(week.pretty()));
        console.info();
    }
    next() {
        return new Month(this.start.clone().add(1, 'month'));
    }
    prev() {
        return new Month(this.start.clone().subtract(1, 'month'));
    }
    buildWeeks() {
        let week = new Week();
        const date = this.start.clone().startOf('week');
        while (date < this.start) {
            week.days.push(undefined);
            date.add(1, 'day');
        }
        while (date.month() === this.start.month()) {
            week.days.push(new Day(date));
            if (date.weekday() === SATURDAY) {
                this.weeks.push(week);
                week = new Week();
            }
            date.add(1, 'day');
        }
        if (week.days.length > 0) {
            this.weeks.push(week);
        }
    }
}
class Week {
    constructor() {
        this.days = [];
    }
    pretty() {
        return this.days
            .map(day => {
            if (day == null)
                return '   ';
            return day.pretty();
        })
            .join(' ');
    }
}
class Day {
    constructor(date) {
        this.date = date.clone();
    }
    pretty() {
        if (this.isToday()) {
            return chalk_1.default.red(this.text());
        }
        if (this.isWeekend()) {
            return chalk_1.default.gray(this.text());
        }
        return this.text();
    }
    isToday() {
        return this.date.isSame(TODAY, 'day');
    }
    isWeekend() {
        return this.date.weekday() >= FRIDAY;
    }
    text() {
        return utils_1.justifyLeft(this.date.date().toString(), 3);
    }
}
main();
//# sourceMappingURL=mycal.js.map