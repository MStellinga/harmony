import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Simple class that listens to sockets and acts on the bytes it receives
 * It only reads one byte of the stream before disconnecting, so it should be safe from overflow and injection attacks.
 */
public class SocketListener {

    private SeleniumRunner runner;

    private static ExecutorService executorService =
            new ThreadPoolExecutor(1, 1, 0L, TimeUnit.MILLISECONDS,
                    new LinkedBlockingQueue<Runnable>());

    public SocketListener(SeleniumRunner runner) {
        this.runner = runner;
    }

    public void start(String initialPage) throws IOException {
        executorService.execute(() -> {
            try {
                runner.launchPage(initialPage);
            } catch (InterruptedException e) {
                //Terminate
            }
        });

        ServerSocket serverSocket = new ServerSocket(8642);
        Socket socket;
        boolean cont = true;
        while (cont) {
            socket = serverSocket.accept();
            try (InputStream input = socket.getInputStream()) {
                int command = input.read();
                executorService.execute(() -> {
                    try {
                        runner.launchPage(command);
                    } catch (InterruptedException e) {
                        //Terminate
                        Thread.currentThread().interrupt();
                    }
                });
                socket.getOutputStream().write(1);
                socket.getOutputStream().flush();
            } catch(SocketException e) {
                e.printStackTrace();
            } catch(InterruptedIOException e){
                cont = false;
            }
        }
    }
}
