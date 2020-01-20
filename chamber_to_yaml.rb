#!/usr/bin/env ruby

require 'pry'
require 'pry-nav'
require 'base64'

class GetChamberValues
  attr_reader :values

  def initialize(chamber_system_cmd)
    raise "Must provide a chamber cmd" unless chamber_system_cmd
    chamber_secrets = `#{chamber_system_cmd}`
    @lines = chamber_secrets.split("\n")
    @values = @lines[1..-1].map do |l|
      l.split("\t").keep_if {|i| i!="" }
    end
  end
end

class SecretFilesGenerator
  attr_reader :values, :secrets, :visibles

  def initialize(values)
    @values = values
    @secrets = []
    @visibles = []
  end

  def prompt_values_to_secrets
    puts "Is the value a secret?"
    values.each do |value|
      key_value = [value[0], value[-1]]
      prompt = "[#{key_value.join(': ')}] [y/n] "
      puts prompt
      answer = get_char

      if answer == 'y'
        @secrets << key_value
      elsif answer == 'n'
        @visibles << key_value
      else
        puts 'MUST ANSWER WITH "y" or "n"'
        redo
      end
    end

    self
  end

  def write_files
    ['secrets', 'visibles'].each do |type|
      File.open("#{type}.yml", 'w') do |f|
        f.write(
          send(type).map do |s|
            key = s[0].upcase
            value = type == 'secrets' ? Base64.strict_encode64(s[1]) : s[1]
            "#{key}: \"#{value}\""
          end.join("\n") + "\n"
        )
      end
    end
  end

  def get_char
    state = `stty -g`
    `stty raw -echo -icanon isig`

    STDIN.getc.chr
  ensure
    `stty #{state}`
  end
end

values = GetChamberValues.new(ARGV[0]).values
SecretFilesGenerator.new(values).prompt_values_to_secrets.write_files

