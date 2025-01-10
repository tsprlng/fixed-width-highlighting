FileInfo = Struct.new('FileInfo', :name, :extension, :line_types)
LineType = Struct.new('LineType', :name, :prefix, :total_length, :fields)
Field = Struct.new('Field', :name, :length, :custom_style)

module Parser

def self.parse_table(table_path)
	file_info = nil
	line_info = nil

	File.open(table_path).each_line do |l|
		l.strip!
		next if /^\s*(#|$)/ =~ l
			# skip blank lines and comments (#)

		if l.start_with?('FILE')
			file_info = FileInfo.new(*l.split(/ +/)[1..], [])
		elsif l.start_with?('LINE')
			line_info = LineType.new(*l.split(/ +/)[1..], [])
			line_info.total_length = line_info.total_length.to_i
			file_info.line_types << line_info
		else
			field = Field.new(*l.split(/ +/))
			field.length = field.length.to_i
			line_info.fields << field
		end
	end

	file_info.line_types.each do |line_type|
		fields_length_sum = line_type.fields.map{|f| f.length }.sum
		fields_length_sum += line_type.prefix.length
		if line_type.total_length != fields_length_sum
			$stderr.puts "WARN: #{table_path} #{line_type.name} total length (#{fields_length_sum}) is not #{line_type.total_length}!"
		end
	end

	file_info
end

end
