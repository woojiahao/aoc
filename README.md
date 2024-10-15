# AOC

Advent of Code Done with Elixir 🤩

---

Wrote a bunch of utility and Mix tasks to speed up the process of working on AOC every year!

## Getting started

Clone the repository

```sh
git clone git@github.com:woojiahao/aoc.git
```

Install the dependencies

```sh
mix deps.get
```

Create a new year. The task automatically generates the files and content to start

```sh
mix new_year <year>
```

Create the solution for the day in `lib/aoc/y<year>/day_<day>.ex` and the data in `priv/<year>/day<day>.txt`.