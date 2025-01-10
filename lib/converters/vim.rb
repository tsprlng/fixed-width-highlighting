require_relative '../parse'

module VimConverter

PlainStyles = [ 'tblPlain', 'tblPlain2' ]
WarningStyle = 'tblWarn'
PrefixStyle = 'tblPrefix'
DefaultHighlightLines = [
	'highlight tblPrefix guifg=White guibg=DarkBlue',
	'highlight tblWarn guifg=Red guibg=Red',
	'highlight tblPlain guifg=Black guibg=Grey',
	'highlight tblPlain2 guifg=White guibg=DarkGrey',
]

FtDetectDir = 'vim-ftdetect'
SyntaxDir = 'vim-syntax'
def self.output_dirs
	[ FtDetectDir, SyntaxDir ]
end

def self.convert_custom_style(style_name)
	return nil if style_name.nil? or style_name.empty?
	return "tbl#{ style_name.sub(/^\w/){|initial| initial.upcase } }"
end

def self.convert(file_info)
	ftdetect_file = File.open("#{FtDetectDir}/#{file_info.name}.vim", 'w') do |ftdetect_file|
		ftdetect_file.puts "autocmd BufRead,BufNewFile *#{file_info.extension}  set filetype=#{file_info.name}"
	end
	File.open("#{SyntaxDir}/#{file_info.name}.vim", 'w') do |syntax_file|
		highlight_lines = [DefaultHighlightLines, '']

		file_info.line_types.each do |line_type|
			line_namespace = "l#{line_type.name}"

			syntax_file.puts "syntax match #{line_namespace} '^#{line_type.prefix}.*$' contains=#{line_namespace}Prefix"

			fields = line_type.fields.to_enum
			first_field = fields.next
			syntax_file.puts "syntax match #{line_namespace}Prefix '^#{line_type.prefix}' contained nextgroup=#{line_namespace}#{first_field.name}"
			highlight_lines << "highlight link #{line_namespace}Prefix #{PrefixStyle}"

			field = first_field
			plain_styles = PlainStyles.cycle.to_enum
			loop do
				next_field = fields.next rescue nil
				syntax_file.puts "syntax match #{line_namespace}#{field.name} '#{"." * field.length}' contained nextgroup=#{line_namespace}#{next_field.name rescue 'ShouldEnd'}"
				highlight_lines << "highlight link #{line_namespace}#{field.name} #{ convert_custom_style(field.custom_style) || plain_styles.next}"
				field = next_field or break
			end
			syntax_file.puts "syntax match #{line_namespace}ShouldEnd '.*' contained"
			highlight_lines << "highlight link #{line_namespace}ShouldEnd #{WarningStyle}"
			syntax_file.puts
		end
		syntax_file.puts highlight_lines
	end
end

end
