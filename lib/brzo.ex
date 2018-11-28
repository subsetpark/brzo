defmodule Brzo.Types do
  defmacro defbinop(atom) do
    quote do
      def unquote(atom)(a, [b]), do: unquote(atom)(a, b)
      def unquote(atom)(a, [b | rest]), do: unquote(atom)(a, b) |> unquote(atom)(rest)
      def unquote(atom)(a, b), do: {unquote(atom), a, b}

      def unquote(atom)([a | rest]), do: unquote(atom)(a, rest)
    end
  end
end

defmodule Brzo do
  @moduledoc """
  Regexing with derivatives.
  """
  import Brzo.Types

  def char(c), do: {:char, c}
  def star(c), do: {:star, c}

  defbinop(:cat)
  defbinop(:union)

  @type t :: :empty | :epsilon | {:char, t} | {:star, t} | {:cat, t} | {:union, t}

  @spec nullable?(t) :: boolean
  def nullable?(:empty), do: false
  def nullable?(:epsilon), do: true
  def nullable?({:char, _}), do: false
  def nullable?({:union, a, b}), do: nullable?(a) or nullable?(b)
  def nullable?({:cat, a, b}), do: nullable?(a) and nullable?(b)
  def nullable?({:star, _}), do: true

  @spec derive(t, char) :: t
  def derive(:empty, _), do: :empty
  def derive(:epsilon, _), do: :empty
  def derive({:char, c}, c), do: :epsilon
  def derive({:char, _}, _), do: :empty

  def derive({:union, a, b}, c), do: derive(a, c) |> union(derive(b, c))
  def derive({:star, l} = l_star, c), do: derive(l, c) |> cat(l_star)

  def derive({:cat, a, b}, c) do
    first = derive(a, c) |> cat(b)

    case nullable?(a) do
      false -> first
      true -> first |> union(derive(b, c))
    end
  end

  @spec matches?(String.t(), t) :: boolean
  def matches?("", language), do: nullable?(language)

  def matches?(<<c::utf8, rest::binary>>, language) do
    derivative = derive(language, c)
    matches?(rest, derivative)
  end
end
