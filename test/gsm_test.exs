defmodule GSMTest do
  use ExUnit.Case, async: true
  import GSM
  alias GSM.BadCharacter
  doctest GSM

  describe "to_gsm/1" do
    test "simple UTF-8 to GSM" do
      assert to_gsm("simple") == "simple"
    end

    test "double-byte characters" do
      assert to_gsm("foo []") == "foo \e<\e>"
    end

    test "invalid GSM characters" do
      assert_raise(BadCharacter, ~s(Unsupported GSM-7 character: \"б\"), fn ->
        to_gsm("баба")
      end)

      assert_raise(BadCharacter, ~s(Unsupported GSM-7 character: <<192>>), fn ->
        to_gsm(<<192>>)
      end)
    end
  end

  describe "to_utf8/1" do
    test "simple GSM to UTF-8" do
      assert to_utf8("simple") == "simple"
    end

    test "double-byte characters" do
      assert to_utf8("GSM \e<\e>") == "GSM []"
    end

    test "invalid GSM characters" do
      assert_raise(BadCharacter, ~s(Unsupported GSM-7 character: \"б\"), fn ->
        to_utf8("баба")
      end)

      assert_raise(BadCharacter, ~s(Unsupported GSM-7 character: <<192>>), fn ->
        to_gsm(<<192>>)
      end)
    end

    test "single escape code" do
      assert to_utf8("\x1B") == ""
    end
  end

  describe "valid?/1" do
    test "valid GSM text" do
      assert valid?("GSM []")
    end

    test "invalid GSM text" do
      refute valid?("баба")
    end
  end

  describe "size/2" do
    test "non-trivial GSM" do
      assert size(~s(GSM: 09azAZ@Δ¡¿£_!Φ"¥Γ#èΛ¤éΩ%ùΠ&ìΨòΣÇΘΞ:Ø;ÄäøÆ,<Ööæ=ÑñÅß>ÜüåÉ§à)) == 63
    end

    test "whitespace only" do
      assert size(~s(     )) == 5
      assert size(~s(\r\n  )) == 4
    end

    test "whitespace GSM" do
      assert size(~s(ΞØ     )) == 7
      assert size(~s(ΞØ\r\n  )) == 6
    end

    test "double-byte GSM" do
      assert size(~s(^{}[~]|€\\)) == 18
      assert size(~s(Σ: €)) == 5
    end

    test "unicode" do
      assert size(~s(кирилица), :unicode) == 8
      assert size(~s(Я!), :unicode) == 2
      assert size(~s(Уникод: ΞØ\r\n  ), :unicode) == 14
      assert size(String.duplicate(~s(Ю), 200), :unicode) == 200
    end

    test "double-byte unicode" do
      assert size(~s(Уникод: ^{}[~]|€\\), :unicode) == 17
      assert size(~s(Уникод: Σ: €), :unicode) == 12
    end
  end

  describe "double?/1" do
    test "double-byte character" do
      assert double?("\\")
      assert double?("[")
      assert double?("]")
    end

    test "non double-byte character" do
      refute double?("g")
      refute double?("s")
      refute double?("m")
    end
  end
end
