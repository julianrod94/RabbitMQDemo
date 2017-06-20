import com.rabbitmq.client.*;
import java.io.IOException;
import java.util.Scanner;

public class Subscriber {
    private static final String EXCHANGE_NAME = "logs";

    public static void main(String[] argv) throws Exception {

        Scanner s = new Scanner(System.in);
        System.out.print("[Java] Enter server IP (localhost)");
        String host = s.nextLine();
        if(host.isEmpty()) {
            host = "localhost";
        }

        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost(host);
        Connection connection = factory.newConnection();
        Channel channel = connection.createChannel();

        channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
        String queueName = channel.queueDeclare().getQueue();
        channel.queueBind(queueName, EXCHANGE_NAME, "");

        System.out.println("[Java] Waiting for messages. To exit press CTRL+C");

        Consumer consumer = new DefaultConsumer(channel) {
            @Override
            public void handleDelivery(String consumerTag, Envelope envelope,
                                       AMQP.BasicProperties properties, byte[] body) throws IOException {
                String message = new String(body, "UTF-8");
                System.out.println("[Java] Received '" + message + "'");
            }
        };
        channel.basicConsume(queueName, true, consumer);
    }
}
