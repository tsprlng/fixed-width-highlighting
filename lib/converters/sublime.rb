require 'yaml'
require_relative '../parse'

module SublimeConverter

PlainStyles = [ 'tabular.plain', 'tabular.plain2' ]
WarningStyle = 'invalid.illegal'
PrefixStyle = 'tabular.prefix'

SublimeDir = 'sublime'
def self.output_dirs
	[ SublimeDir ]
end

def self.convert_custom_style(style_name)
	return nil if style_name.nil? or style_name.empty?
	"tabular.#{style_name.downcase}"
end

def self.convert(file_info)
	main_context = []
	contexts = {'main'=> main_context }
	output = {
		'file_extensions'=> [ file_info.extension.sub(/^\./, '') ],
		'scope'=> "source.tabular.#{file_info.name}",
		'contexts'=> contexts,
	}

	file_info.line_types.each do |line_type|
		line_namespace = "l#{line_type.name}"
		fields = line_type.fields.to_enum
		first_field = fields.next

		main_context << {
			'match'=> "^#{line_type.prefix}",
			'scope'=> PrefixStyle,
			'push'=> "#{line_namespace}#{first_field.name}",
		}

		field = first_field
		plain_styles = PlainStyles.cycle.to_enum
		loop do
			next_field = fields.next rescue nil
			contexts["#{line_namespace}#{field.name}"] = [{
				'match'=> ".{#{field.length}}",
				'scope'=> convert_custom_style(field.custom_style) || plain_styles.next,
				'pop'=> true,
				'push'=> "#{line_namespace}#{ next_field ? next_field.name : '_should_end'}",
			}]
			field = next_field or break
		end
		contexts["#{line_namespace}_should_end"] = [{
			'match'=> ".*",
			'scope'=> WarningStyle,
			'pop'=> true,
		}]
	end

	File.open("#{SublimeDir}/#{file_info.name}.sublime-syntax", 'w') do |syntax_file|
		syntax_file.puts '%YAML 1.2'
			# it's in sublime's example, who knows why

		syntax_file.puts YAML.dump(output)
	end
end

end
