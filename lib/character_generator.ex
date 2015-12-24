# CharacterGenerator.default_keys |> Enum.zip(CharacterGenerator.point_buy(8*3) |> CharacterGenerator.rank)

defmodule CharacterGenerator do
  def point_buy(points, keys \\ nil) do
    keys = keys |> default_keys
    _point_buy(points, keys, (keys |> default_values))
  end

  def rank(values), do: Enum.map(values, &LetterGrade.rank/1)
  def percent(values), do: Enum.map(values, &LetterGrade.percent/1)

  def multiply(values, multiplier), do: Enum.map(values, &(&1 * multiplier))
  def add(values, bonus) do
    values
      |> Enum.zip(bonus
      |> resize_bonus(values))
      |> Enum.map(&(elem(&1,0)+elem(&1,1)))
  end
  def roll(values, x, y, c \\ 0), do: values |> Enum.map(&(&1+xdy(x,y,c)))
  def xdy(0, _y, c), do: c
  def xdy(x, y, c), do: xdy x-1, y, c + :random.uniform y

  defp _point_buy(points, _keys, values) when points < 1, do: values |> Tuple.to_list
  defp _point_buy(points, keys, values), do: _point_buy(points - 1, keys, (values |> allocate_random_point))

  defp random_index(max_index), do: (max_index |> :random.uniform) - 1
  defp allocate_point(values, index), do: values |> put_elem(index, (values |> elem(index)) + 1)
  defp allocate_random_point(values), do: values |> allocate_point(values |> tuple_size |> random_index)

  def default_keys(keys \\ nil)
  def default_keys(nil), do: [:str, :dex, :end, :int, :edu, :soc, :san, :psi]
  def default_keys(keys), do: keys

  defp resize_bonus(values, keys), do: values |> List.to_tuple |> default_values(keys) |> Tuple.to_list

  defp default_values(values \\ nil, keys)
  defp default_values(nil, keys), do: 0 |> Tuple.duplicate(keys |> length)
  defp default_values(values, keys) when tuple_size(values) < length(keys), do: default_values(values |> Tuple.append(0), keys)
  defp default_values(values, keys) when length(keys) < tuple_size(values), do: default_values(values |> Tuple.delete_at((values |> tuple_size) - 1), keys)
  defp default_values(values, _keys), do: values
end

