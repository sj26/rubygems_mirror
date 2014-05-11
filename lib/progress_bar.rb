#
# Ruby/ProgressBar - a text progress bar library
#
# Copyright (C) 2001-2005 Satoru Takabayashi <satoru@namazu.org>
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms
# of Ruby's license.
#

require "io/console"

class ProgressBar
  attr_reader :title, :current, :total
  attr_accessor :start_time, :synchronized

  def initialize (title, total, out = STDERR)
    @title = title
    @total = total
    @out = out
    @bar_mark = "="
    @current = 0
    @previous = 0
    @finished_p = false
    @synchronized = false
    @start_time = Time.now
    @previous_time = @start_time
    @format = "%s %3d%% %s %s"
    @format_arguments = [:title, :percentage, :bar, :stat]
    @width = terminal_width
    clear
    show
  end

  def synchronized= value
    @synchronized = value.tap do
      @mutex ||= (@mutex || Mutex.new if value)
    end
  end

  def synchronized!
    tap { self.synchronized = true }
  end

private

  def synchronize &block
    if synchronized
      @mutex.synchronize(&block)
    else
      block.call
    end
  end

  def self.synchronize *symbols
    symbols.each do |symbol|
      symbol_without_synchronize = :"#{symbol}_without_synchronize"
      alias_method symbol_without_synchronize, symbol
      define_method symbol do |*args, &block|
        synchronize do
          send symbol_without_synchronize, *args, &block
        end
      end
    end
  end

  def fmt_bar
    bar_width = do_percentage * @width / 100
    sprintf("[%s%s]",
            @bar_mark * bar_width,
            " " *  (@width - bar_width))
  end

  def fmt_percentage
    do_percentage
  end

  def fmt_stat
    if @finished_p then elapsed else eta end
  end

  def fmt_stat_for_file_transfer
    if @finished_p then
      sprintf("%s %s %s", bytes, transfer_rate, elapsed)
    else
      sprintf("%s %s %s", bytes, transfer_rate, eta)
    end
  end

  def fmt_title
    @title + "..."
  end

  def convert_bytes (bytes)
    if bytes < 1024
      sprintf("%6dB", bytes)
    elsif bytes < 1024 * 1000 # 1000kb
      sprintf("%5.1fKB", bytes.to_f / 1024)
    elsif bytes < 1024 * 1024 * 1000  # 1000mb
      sprintf("%5.1fMB", bytes.to_f / 1024 / 1024)
    else
      sprintf("%5.1fGB", bytes.to_f / 1024 / 1024 / 1024)
    end
  end

  def transfer_rate
    bytes_per_second = @current.to_f / (Time.now - @start_time)
    sprintf("%s/s", convert_bytes(bytes_per_second))
  end

  def bytes
    convert_bytes(@current)
  end

  def format_time (t)
    t = t.to_i
    sec = t % 60
    min  = (t / 60) % 60
    hour = t / 3600
    sprintf("%02d:%02d:%02d", hour, min, sec);
  end

  # ETA stands for Estimated Time of Arrival.
  def eta
    if @current == 0
      "ETA:  --:--:--"
    else
      elapsed = Time.now - @start_time
      eta = elapsed * @total / @current - elapsed;
      sprintf("ETA:  %s (%d/%d)", format_time(eta), @current, @total)
    end
  end

  def elapsed
    elapsed = Time.now - @start_time
    sprintf("Time: %s", format_time(elapsed))
  end

  def eol
    if @finished_p then "\n" else "\r" end
  end

  def do_percentage
    if @total.zero?
      100
    else
      @current  * 100 / @total
    end
  end

  def terminal_width
    begin
      rows, columns = IO.winsize
      columns
    rescue Exception
      80
    end
  end

  def show
    arguments = @format_arguments.map do |method|
      method = sprintf("fmt_%s", method)
      send(method)
    end
    line = sprintf(@format, *arguments)

    # Check if terminal size has changed
    @width = terminal_width

    # Make sure we don't overflow a line
    # line = line[0..@width]

    # Push it out straight away
    @out.print line, eol
    @out.flush

    # For ETA calculations
    @previous_time = Time.now
  end
  synchronize :show

  def show_if_needed
    if @total.zero?
      cur_percentage = 100
      prev_percentage = 0
    else
      cur_percentage  = (@current  * 100 / @total).to_i
      prev_percentage = (@previous * 100 / @total).to_i
    end

    # Use "!=" instead of ">" to support negative changes
    if cur_percentage != prev_percentage ||
        Time.now - @previous_time >= 1 || @finished_p
      show
    end
  end

public

  def clear
    @width = terminal_width
    @out.print "\r", (" " * (@width - 1)), "\r"
  end
  synchronize :clear

  # puts making sure the progressbar doesn't get in the way
  def puts *args
    clear
    @out.puts *args
    show
  end
  synchronize :puts

  def finish
    @current = @total
    @finished_p = true
    show
  end

  def finished?
    @finished_p
  end

  def file_transfer_mode
    @format_arguments = [:title, :percentage, :bar, :stat_for_file_transfer]
  end

  def format= (format)
    @format = format
  end

  def format_arguments= (arguments)
    @format_arguments = arguments
  end

  def halt
    @finished_p = true
    show
  end

  def increment(step=1)
    @current += step
    @current = @total if @current > @total
    show_if_needed
    @previous = @current
  end

  def current=(value)
    if value < 0 || value > total
      raise ArgumentError, "invalid: #{value} (total: #{total})"
    end
    @current = value
    show_if_needed
    @previous = @current
  end

  def total=(value)
    if value < 0 || value < current
      raise ArgumentError, "invalid: #{value} (current: #{total})"
    end

    @total = value
    show
  end

  def inspect
    "#<ProgressBar:#{@current}/#{@total}>"
  end
end
