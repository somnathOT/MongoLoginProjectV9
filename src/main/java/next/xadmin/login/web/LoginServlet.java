package next.xadmin.login.web;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import next.xadmin.login.bean.LoginBean;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private MongoClient mongoClient;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    
    public void init() throws ServletException {
        super.init();
        mongoClient = MongoClients.create("mongodb://localhost:27017");
        database = mongoClient.getDatabase("userdb");
        collection = database.getCollection("login");
    }

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Query the database for the user with the provided username
        Document query = new Document("username", username);
        Document result = collection.find(query).first();

        if (result != null) {
            String storedPassword = result.getString("password");
            int failedAttempts = result.getInteger("failedAttempts", 0);

            if (failedAttempts < 3) {
                if (password.equals(storedPassword)) {
                    // Successful login
                    collection.updateOne(query, new Document("$set", new Document("failedAttempts", 0)));

                    // Set user info and forward to welcome page
                    request.setAttribute("userInfo", username);
                    RequestDispatcher requestDispatcher = request.getRequestDispatcher("welcome.jsp");
                    requestDispatcher.forward(request, response);
                } else {
                    // Failed login attempt
                    failedAttempts++;
                    int remainingAttempts = 3 - failedAttempts;

                    // Update the failedAttempts count and lastFailedTime
                    Instant lastFailedTime = Instant.now();
                    String lastFailedTimeFormatted = DateTimeFormatter.ISO_INSTANT.format(lastFailedTime);
                    collection.updateOne(query, new Document("$set",
                            new Document("failedAttempts", failedAttempts)
                                    .append("lastFailedTime", lastFailedTimeFormatted)));

                    // Construct the error message with remaining attempts
                    String errorMessage = "Invalid password. " + remainingAttempts + " attempts remaining.";
                    response.sendRedirect("login.jsp?error=" + URLEncoder.encode(errorMessage, StandardCharsets.UTF_8));
                }
            } else {
                // Account locked due to too many failed attempts
                Object lastFailedTimeObj = result.get("lastFailedTime");
                
                if (lastFailedTimeObj != null) {
                    Instant lastFailedTime = Instant.parse((String) lastFailedTimeObj);
                    Instant currentTime = Instant.now();

                    if (currentTime.minusSeconds(24 * 60 * 60).isBefore(lastFailedTime)) {
                        // Account locked for less than 24 hours
                        response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Account locked. Please try again later.", StandardCharsets.UTF_8));
                    } else {
                        // Reset failed attempts and unlock the account
                        collection.updateOne(query, new Document("$set",
                                new Document("failedAttempts", 0)
                                        .append("lastFailedTime", null))); // Clear lastFailedTime

                        // Retry login after resetting attempts
                        doPost(request, response);
                    }
                }
            }
        } else {
            // User not found
            response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Username or password is incorrect", StandardCharsets.UTF_8));
        }
    }

    
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
        super.destroy();
    }
}
