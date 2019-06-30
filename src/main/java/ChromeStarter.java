/**
 * The Main Class.
 * Yes, it doesn't use packages because I was lazy.
 * Normally, I'd use a Spring Boot application, but that takes longer to start.
 * The idea is to start this from
 */
public class ChromeStarter {

    // Like I said above, I'm not using Spring Boot, so I was also to lazy to use a proper property file for this
    private final static String driverPath = "c:/harmony/selenium/chromedriver.exe";
    private final static String userDir = "\\AppData\\Local\\Google\\Chrome\\User Data";

    private static SocketListener listener;

    public static void main(String[] args) {
        try {
            SeleniumRunner runner = new SeleniumRunner(driverPath, userDir);
            listener = new SocketListener(runner);
            listener.start(args.length >0 ? args[0] : "npo1");
        } catch (Exception e){
            // Yeah, I'm also too lazy to add Logback
            System.out.println("Fail");
            e.printStackTrace();
        }
    }

}