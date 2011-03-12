class Array
  
  def paginate___(page=1, per_page=15)
    pagination_array = WillPaginate::Collection.new(page, per_page, self.size)
    start_index = pagination_array.offset
    end_index = start_index + (per_page - 1)
    array_to_concat = self[start_index..end_index]
    array_to_concat.nil? ? [] : pagination_array.concat(array_to_concat)
  end
  
=begin
>> chunk_array [1,2,3,4,5,6], 2
   3  => [[1, 2, 3], [4, 5, 6]]
   4  
   5  >> chunk_array [1,2,3,4,5,6], 3
   6  => [[1, 2], [3, 4], [5, 6]]
   7  
   8  >> chunk_array [1,2,3,4,5,6], 4
   9  => [[1, 2], [3, 4], [5], [6]]
  10  
  11  >> chunk_array [1,2,3,4,5,6,7,8,9,10], 4
  12  => [[1, 2, 3], [4, 5, 6], [7, 8], [9, 10]]
  13  
  14  >> chunk_array [1,2,3], 4
  15  => [[1], [2], [3], []]
  16  
  17  >> chunk_array [], 2
  18  => [[], []]
=end
  def Array.chunk_array(array, pieces=2)
    len = array.length;
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << array[start..last] || []
      start = last+1
    end
    chunks
  end

=begin
   1  
   2  >> [1,2,3,4,5,6,7,8,9,10].chunk
   3  => [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]
   4  
   5  >> [1,2,3,4,5,6,7,8,9,10].chunk 3
   6  => [[1, 2, 3, 4], [5, 6, 7], [8, 9, 10]]
=end
  def chunk(pieces=2)
    len = self.length;
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << self[start..last] || []
      start = last+1
    end
    chunks
  end
  
=begin
http://snippets.dzone.com/posts/show/3486
[:now, :is, :the, :time, :for, :all, :good, :men, :to, :come, :to, :the, :aid] / 3

gives

=> [[:now, :is, :the], [:time, :for, :all], [:good, :men, :to], [:come, :to, :the], [:aid]]
=end
  def / len
    a = []
    each_with_index do |x,i|
      a << [] if i % len == 0
      a.last << x
    end
    a
  end
  
end