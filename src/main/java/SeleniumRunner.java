import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.List;

/**
 * This class actually starts Selenium and
 * uses it to open web pages
 */
public class SeleniumRunner {

    private static final int CODE_NPO1 = 1;
    private static final int CODE_NPO2 = 2;
    private static final int CODE_NPOZAPP = 3;
    private static final int CODE_RADIO4 = 4;
    private static final int CODE_NETFLIX = 5;
    private static final int CODE_YOUTUBE = 6;
    private static final int CODE_BLANK = 7;
    private static final int CODE_GOOGLEMUSIC = 8;

    private static final String URL_RADIO4 = "https://www.nporadio4.nl/live";
    private static final String URL_NPO1 = "https://www.npostart.nl/live/npo-1";
    private static final String URL_NPO2 = "https://www.npostart.nl/live/npo-2";
    private static final String URL_NPOZAPP = "https://www.npostart.nl/live/npo-zapp";
    private static final String URL_NETFLIX = "https://www.netflix.com";
    private static final String URL_YOUTUBE = "https://www.youtube.com/watch?v=RH3OxVFvTeg";
    private static final String URL_GOOGLEMUSIC = "https://play.google.com/music/listen#/home";

    private WebDriver driver;
    private String driverPath;
    private String userDir;
    private String lastTarget = null;

    public SeleniumRunner(String driverPath, String userDir) {
        this.driverPath = driverPath;
        this.userDir = userDir;
    }

    private void createNewDriver(){
        System.setProperty("webdriver.chrome.driver", driverPath);
        ChromeOptions options = new ChromeOptions();
        options.addArguments("disable-infobars","user-data-dir="+System.getProperty("user.home")+userDir);
        driver = new ChromeDriver(options);
    }

    private List<WebElement> waitForElements(By by) throws InterruptedException {
        List<WebElement> elems = driver.findElements(by);
        int count = 0;
        while(elems.size()==0 && count <100) {
            Thread.sleep(100);
            count ++;
            elems = driver.findElements(by);
        }
        return elems;
    }

    private  WebElement waitForElement(By by) throws InterruptedException {
        return (new WebDriverWait(driver, 15)).until(ExpectedConditions.elementToBeClickable(by));
    }

    private void checkDriver(){
        if(driver != null) {
            try {
                driver.getCurrentUrl();
            } catch (Exception e) {
                try {
                    driver.close();
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
                driver = null;
            }
        }
        if(driver == null) {
            createNewDriver();
        }
    }

    public synchronized void launchPage(int target) throws InterruptedException {
        checkDriver();
        switch (target) {
            case CODE_NPO1:
                launchPage("npo1");
                break;
            case CODE_NPO2:
                launchPage("npo2");
                break;
            case CODE_NPOZAPP:
                launchPage("npo-zapp");
                break;
            case CODE_RADIO4:
                launchPage("radio4");
                break;
            case CODE_NETFLIX:
                launchPage("netflix");
                break;
            case CODE_YOUTUBE:
                launchPage("youtube");
                break;
            case CODE_GOOGLEMUSIC:
                launchPage("googlemusic");
                break;
            case CODE_BLANK:
                launchPage("blank");
                break;

        }
    }

    public synchronized void launchPage(String target) throws InterruptedException {
        checkDriver();
        clickLeaveMessage();

        lastTarget = null;
        switch(target){
            case "radio4":
                driver.get(URL_RADIO4);
                fullScreenRadio4();
                break;
            case "npo1":
                driver.get(URL_NPO1);
                fullScreenNPO();
                break;
            case "npo2":
                driver.get(URL_NPO2);
                fullScreenNPO();
                break;
            case "npo-zapp":
                driver.get(URL_NPOZAPP);
                fullScreenNPO();
                break;
            case "netflix":
                driver.get(URL_NETFLIX);
                break;
            case "youtube":
                driver.get(URL_YOUTUBE);
                fullScreenYoutube();
                break;
            case "googlemusic":
                driver.get(URL_GOOGLEMUSIC);
                break;
            case "blank":
                driver.get("about:blank");
                break;
        }
        lastTarget = target;
    }

    private void fullScreenYoutube() throws InterruptedException {
        waitForElement(By.id("player-container"));
        new Actions(driver).sendKeys("f").perform();
    }

    private void fullScreenNPO() throws InterruptedException {
        List<WebElement> frames = waitForElements(By.tagName("iframe"));
        for(WebElement frame: frames) {
            if(frame.getAttribute("src").startsWith("https://start-player.npo.nl")) {
                driver.switchTo().frame(frame);
                Thread.sleep(100);
                WebElement fullscreenButton = waitForElement(By.className("vjs-fullscreen-control"));
                fullscreenButton.click();
            }
        }
    }

    private void fullScreenRadio4() throws InterruptedException {
        WebElement header = waitForElement(By.className("heading-large"));
        header.click();
        List<WebElement> frames = waitForElements(By.tagName("iframe"));
        for(WebElement frame: frames) {
            if(frame.getAttribute("src").startsWith("https://start-player.npo.nl")) {
                driver.switchTo().frame(frame);
                WebElement playButton = waitForElement(By.className("vjs-big-play-button"));
                JavascriptExecutor executor = (JavascriptExecutor)driver;
                executor.executeScript("arguments[0].click();", playButton);
                driver.switchTo().parentFrame();
                fullScreenNPO();
            }
        }
    }

    /**
     * remove the 'are you sure you want to leave message'
     */
    private void clickLeaveMessage() {
        if(lastTarget != null && lastTarget.startsWith("music")){
            driver.get("https://www.google.com");
            driver.switchTo().alert().accept();
        }
    }
}