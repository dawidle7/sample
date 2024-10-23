import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;  

import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;  


public class SeleniumTest {

    public static void main(String[] args) {
        System.setProperty("webdriver.gecko.driver", "/path/of/downloaded/driver"); 

        WebDriver driver = new FirefoxDriver();
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

        try {
            driver.get("https://login");

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
            if (actualUsername.contains(expectedUsername)) {
                System.out.println("Welcome message contains username successfully.");
            } else {
                System.out.println("Welcome message does not contain username.");
            }

            WebElement currentDateElement = driver.findElement(By.id("current_date"));
            String expectedDateFormat = "yyyy-MM-dd";
            String actualDate = currentDateElement.getText();
            LocalDate currentDate = LocalDate.now();
            String formattedCurrentDate = currentDate.format(DateTimeFormatter.ofPattern(expectedDateFormat));
            if (actualDate.equals(formattedCurrentDate)) {
                System.out.println("Current date displayed correctly.");
            } else {
                System.out.println("Current date is not displayed correctly.");
            }

            WebElement elementOnPart1 = driver.findElement(By.id("element_on_part1"));
            WebElement elementOnPart2 = driver.findElement(By.id("element_on_part2"));
            System.out.println("Elements on part 1 and part 2 are present.");

            System.out.println("Login test passed successfully.");
        } catch (Exception e) {
            System.out.println("Login test failed: " + e.getMessage());
        } finally {
            driver.quit();
        }
    }
}