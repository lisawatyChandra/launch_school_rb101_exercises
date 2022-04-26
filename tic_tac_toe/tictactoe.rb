def joinor(array, delimiter=', ', word='or')
  array = array.map { |e| e }
  case array.size
  when 0 then ''
  when 1 then array.first
  when 2 then array.join(" #{word}")
  else
    array[-1] = "#{word} #{array.last}"
    array.join(delimiter)
  end
end

array = [1, 2, 3, 4, 5]
puts joinor(array, ' :: ', '::')
puts joinor(array)
puts joinor(array, ' ** ', '&')