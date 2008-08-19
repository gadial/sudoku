require 'DoubleArray'

class SudokuBoard
	$BoardSize=9
		def initialize
		@squares=DoubleArray.new($BoardSize,$BoardSize)
	end
	def row(index)
		(0...$BoardSize).collect{|j| self[index,j]}
	end
	def column(index)
		(0...$BoardSize).collect{|i| self[i,index]}
	end
	def []=(tx,ty,r)
		@squares[tx,ty]=r
	end
	def [](tx,ty)
		@squares[tx,ty]
	end
	def each_row
		
	end
end

temp=SudokuBoard.new
temp[3,5]=5
puts temp.row(3).inspect