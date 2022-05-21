#!/usr/bin/env python3

import sys
import datetime

SUNDAY = 6
DAY = datetime.timedelta(days=1)
SIX_DAYS = datetime.timedelta(days=6)


def main():
    if len(sys.argv) < 1:
        print("Usage: calendar-markdown.py <year>")
        sys.exit(1)

    generate(int(sys.argv[1]))


def closest_sunday(date: datetime.datetime) -> datetime.datetime:
    while date.weekday() != SUNDAY:
        date += DAY
    return date


def generate(year: int):
    d = closest_sunday(datetime.datetime(year, 1, 1))

    print(f"# Year: {year}")
    while d.year == year:
        month = d.month

        print(f"\n## {d.strftime('%B')}")
        while d.month == month:
            start_of_week = d.strftime("%b %d")
            end_of_week = (d + SIX_DAYS).strftime("%b %d")

            print(f"\n### Week: {start_of_week} - {end_of_week}\n")
            for _ in range(0, 7):
                day = d.strftime("%a (%b %d)")
                print(f"- **{day}**")
                d += DAY


if __name__ == "__main__":
    main()
