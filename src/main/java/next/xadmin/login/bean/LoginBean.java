package next.xadmin.login.bean;

import org.bson.Document;

public class LoginBean {
    private String username;
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // New method to convert LoginBean to a MongoDB Document
    public Document toDocument() {
        return new Document("username", username)
                .append("password", password);
    }
}
