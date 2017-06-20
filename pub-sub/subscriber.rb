require "bunny"

pid = Process.pid

puts "[#{pid}] Enter server IP (localhost): "
host = gets.chomp
host = "localhost" if host.empty?

conn = Bunny.new(host: host)
conn.start

ch  = conn.create_channel
x   = ch.fanout("logs")
q   = ch.queue("", exclusive: true)

q.bind(x)

puts "[#{pid}] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts "[#{pid}] #{body}"
  end
rescue Interrupt
  ch.close
  conn.close
  puts "[#{pid}] Closing connection"
end

puts "[#{pid}] Shutting down"
