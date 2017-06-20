require "bunny"

pid = Process.pid

puts "[#{pid}] Specify server IP (localhost): "
host = gets.chomp
host = "localhost" if host.empty?

conn = Bunny.new(host: host)
conn.start

ch   = conn.create_channel
q    = ch.queue("task_queue", durable: true)

puts "[#{pid}] Sending infinite work. To exit press CTRL+C"
begin
	loop do
		number = rand(10)
		work = "." * number
		print work
		q.publish(work, persistent: true)
		sleep 5
	end
rescue Interrupt
  puts "\n[#{pid}] Closing connection"
  conn.close
end

puts "[#{pid}] Shutting down"
