require 'DoubleArray'
class Integer
	def reminder_divison(n)
		# self=q*n+r where 0<=r<n; return [q,r]
		[self / n, self % n]
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
		@squares=DoubleArray.new($BoardSize,$BoardSize)
	end
	def row(index)
		(0...$BoardSize).collect{|j| self[index,j]}
	end
	def rows
		(0...$BoardSize).collect{|i| row(i)}
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
        delegate_methods :squares, '[]=', '[]'
	def each_row
		(0...$BoardSize).times {|i| yield(row(i),i)}
	end
	def each_column
		(0...$BoardSize).times {|i| yield(column(i),i)}
	end
	def inspect_row(row)
		row.collect{|x| (x != nil)?(x.to_s):("#")}.join(" ")+"\n"
	end
	def inspect
		rows.inject(""){|string, row| string+inspect_row(row)}
	end
end

temp=SudokuBoard.new
temp[3,5]=5
temp[2,2]=2
puts temp.inspect
puts temp.square(4).inspect
