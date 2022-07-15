Mix.install([:benchee, {:gsm, path: "."}])

Benchee.run(%{to_gsm: fn input -> GSM.to_gsm(input) end},
  load: ["bench/pattern-match.benchee"],
  save: [path: "bench/v0.1.1.benchee", tag: "v0.1.1"],
  inputs: %{
    extended: String.duplicate("{", 2048),
    non_extended: String.duplicate("a", 2048)
  }
)
