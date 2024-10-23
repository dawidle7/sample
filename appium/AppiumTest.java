import io.appium.java_client.MobileDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.DesiredCapabilities;  

import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.net.MalformedURLException;  

import java.net.URL;  

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

public class  
 AppiumTest {

    public static void main(String[] args) throws MalformedURLException {
        DesiredCapabilities caps = new DesiredCapabilities();
        caps.setCapability("platformName", "Android");  
 // iOS
        caps.setCapability("platformVersion", "12");
        caps.setCapability("deviceName", "Pixel 3"); 
        caps.setCapability("app", "/path/to/your/app");

        URL appiumServerUrl = new URL("http://localhost:4723/wd/hub");

        MobileDriver<WebElement> driver = new MobileDriver<>(appiumServerUrl, caps);
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

        try {
            WebElement usernameField = driver.findElement(By.id("username"));
            usernameField.sendKeys("username1");

            WebElement passwordField = driver.findElement(By.id("password"));
            passwordField.sendKeys("password1");

            WebElement loginButton = driver.findElement(By.id("login_button"));
            loginButton.click();

            WebDriverWait wait = new WebDriverWait(driver, 10);
            WebElement welcomeMessage = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("welcome_message")));

            String expectedUsername = "username1";
            String actualUsername = welcomeMessage.getText();
            if (!actualUsername.contains(expectedUsername)) {
                throw new RuntimeException("Welcome message does not contain username.");
            }

            WebElement currentDateElement = driver.findElement(By.id("current_date"));
            String expectedDateFormat = "yyyy-MM-dd";
            String actualDate = currentDateElement.getText();
            LocalDate currentDate = LocalDate.now();
            String formattedCurrentDate = currentDate.format(DateTimeFormatter.ofPattern(expectedDateFormat));
            if (!actualDate.equals(formattedCurrentDate)) {
                throw new RuntimeException("Current date is not displayed correctly.");
            }

            WebElement elementOnPart1 = driver.findElement(By.id("element_on_part1"));
            WebElement elementOnPart2 = driver.findElement(By.id("element_on_part2"));

            System.out.println("Login test passed successfully.");
        } catch (Exception e) {
            System.out.println("Login test failed: " + e.getMessage());
        } finally {
            driver.quit();
        }
    }
}