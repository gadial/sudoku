require 'DoubleArray'
class Integer
	def reminder_divison(n)
		# self=q*n+r where 0<=r<n; return [q,r]
		[self / n, self % n]
	end
end

class Array
	def has_duplicates?
		self.uniq.length < self.length
	end
	def find_all_indexes
		(0...self.length).find_all{|i| yield(self[i])}
	end
end

class Class
  def delegate_methods(instance_var, *methods)
#     puts "Delegating methods %p to variable %p" % [methods, instance_var]
    methods.each do |method|
      define_method method do |*args|
        instance_variable_get("@#{instance_var}".to_sym).send method, *args
      end
    end
  end
end

class SudokuBoard
	$BoardBasicSize=3
	$BoardSize=$BoardBasicSize**2 #The assumption is that $BoardSize=n^2 for some positive n
		def initialize
		@basic_squares=DoubleArray.new($BoardSize,$BoardSize)
	end
	def row(index)
		(0...$BoardSize).collect{|j| self[index,j]}
	end
	def rows
		(0...$BoardSize).collect{|i| row(i)}
	end
	def columns
		(0...$BoardSize).collect{|i| column(i)}
	end
	def squares
		(0...$BoardSize).collect{|i| square(i)}
	end
	def column(index)
		(0...$BoardSize).collect{|i| self[i,index]}
	end
	def square(index)
		row_num, col_num = index.reminder_divison($BoardBasicSize)
		row_num*=$BoardBasicSize; col_num*=$BoardBasicSize
		(0...$BoardSize).collect do |i|
			offset_row, offset_col=i.reminder_divison($BoardBasicSize)
			self[row_num+offset_row, col_num+offset_col]
		end
	end
        delegate_methods :basic_squares, '[]=', '[]'
	def each_row
		(0...$BoardSize).times {|i| yield(row(i),i)}
	end
	def each_column
		(0...$BoardSize).times {|i| yield(column(i),i)}
	end
	def each_square
		(0...$BoardSize).times {|i| yield(square(i),i)}
	end
	def inspect_row(row)
		row.collect{|x| (x != nil)?(x.to_s):("#")}.join(" ")+"\n"
	end
	def inspect
		rows.inject(""){|string, row| string+inspect_row(row)}
	end

	def <<(board_string)
		#for now, assumes each square is represented by a single char
		board_string.delete!("\n ") #we allow whitespaces in the input to make input files easier to read and write manually
		raise "wrong input size" unless board_string.length==$BoardSize**2
		board_string.length.times do |i|
			self[*(i.reminder_divison($BoardSize))]=(board_string[i..i] != "0")?(board_string[i..i].to_i):(nil)
		end
		self
	end
	def illegal(vector)
		(vector-[nil]).has_duplicates?
	end
	def illegals
		rows.find_all_indexes{|row| illegal(row)}.collect{|i| [:row,i]} +
		columns.find_all_indexes{|column| illegal(column)}.collect{|i| [:column,i]}+
		squares.find_all_indexes{|square| illegal(square)}.collect{|i| [:square,i]}
	end

	def legal?
		illegals.empty?
	end

	def compress
		rows.collect{|row| row.collect{|x| (x!=nil)?(x.to_s):("0")}}.flatten.join("")
	end
	def SudokuBoard::load(filename)
		SudokuBoard.new << File.open(filename,"r"){|file| file.read}
	end
end

temp=SudokuBoard.load("test.sud")
temp[0,7]=4
puts temp.inspect
puts temp.legal?
puts temp.illegals.inspect
# temp=SudokuBoard.new
# temp[3,5]=5
# temp[2,2]=2
# puts temp.inspect
# puts temp.square(4).inspect
# puts temp.compress
# temp2=SudokuBoard.new
# temp2 << temp.compress
# puts temp2.inspect
