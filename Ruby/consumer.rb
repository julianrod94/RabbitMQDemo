require "bunny"

pid = Process.pid

puts "[#{pid}] Specify server IP (localhost): "
host = gets.chomp
host = "localhost" if host.empty?

conn = Bunny.new(host: host)
conn.start

ch   = conn.create_channel
q    = ch.queue("task_queue", durable: true)

ch.prefetch(1)
puts "[*#{pid}] Ready to receive work. To exit press CTRL+C"

begin
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    work = body.scan('.').size
    print "[*#{pid}] Received #{work} units of work. Working..."
    # Imitate some work
    sleep work*2
    puts "Done"
    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt
  puts "\n[*#{pid}] Closing connection"
  conn.close
end

puts "Shutting down"
