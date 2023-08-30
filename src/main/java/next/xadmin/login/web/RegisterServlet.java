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
import jakarta.servlet.http.HttpSession;
import next.xadmin.login.bean.LoginBean;

import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017")) {
            MongoDatabase database = mongoClient.getDatabase("userdb");
            MongoCollection<Document> usersCollection = database.getCollection("login");
            
         // Check if the username already exists
            Document existingUser = usersCollection.find(new Document("username", username)).first();
            if (existingUser != null) {
                // Username already exists, show toast message and return
                request.setAttribute("toastMessage", "Username already exists.");
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("registration.jsp");
                requestDispatcher.forward(request, response);
                return;
            }

            Document newUser = new Document("username", username).append("password", password);
            usersCollection.insertOne(newUser);

            request.setAttribute("success", true);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("welcome.jsp");
            request.setAttribute("userInfo", username);
            requestDispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Registration failed.");
        }
    }
}
