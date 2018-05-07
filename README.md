# GSM

GSM-7 encoding for Elixir

[![Build Status](https://travis-ci.org/l1h3r/gsm.svg?branch=master)](https://travis-ci.org/l1h3r/gsm)
[![Coverage Status](https://coveralls.io/repos/github/l1h3r/gsm/badge.svg?branch=master)](https://coveralls.io/github/l1h3r/gsm?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/gsm.svg?style=flat-square)](https://hex.pm/packages/gsm)
[![Hex.pm](https://img.shields.io/hexpm/dt/gsm.svg?style=flat-square)](https://hex.pm/packages/gsm)

[GSM 03.38](https://en.wikipedia.org/wiki/GSM_03.38)

## Installation

```elixir
def deps do
  [
    {:gsm, "~> 0.1.0"}
  ]
end
```

## Usage

### GSM-7 conversion

```elixir
iex> GSM.to_gsm("foo")
"foo"

iex> GSM.to_gsm("bar :]")
"bar :\e>"

iex> GSM.to_gsm("баz")
** (GSM.BadCharacter) Unsupported GSM-7 character: "б"
```

### GSM-7 validation

```elixir
# Test if valid GSM string
iex> GSM.valid?("foo :]")
true

iex> GSM.valid?("баz")
false

# Test if 2-byte GSM character
iex> GSM.double?("|")
true

iex> GSM.double?(":")
false
```

### UTF-8 conversion

```elixir
iex> GSM.to_utf8("foo :\e>")
"foo :]"

iex> GSM.to_utf8("∫")
** (GSM.BadCharacter) Unsupported GSM-7 character: "∫"
```
