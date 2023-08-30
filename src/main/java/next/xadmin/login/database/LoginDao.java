package next.xadmin.login.database;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import org.bson.Document;

import next.xadmin.login.bean.LoginBean;

public class LoginDao {
    private MongoClient mongoClient;
    private MongoDatabase database;
    private MongoCollection<Document> collection;

    public LoginDao() {
        mongoClient = MongoClients.create("mongodb://localhost:27017");
        database = mongoClient.getDatabase("userdb");
        collection = database.getCollection("login");
    }

    public boolean validate(LoginBean loginBean) {
        Document query = new Document("username", loginBean.getUsername())
                .append("password", loginBean.getPassword());

        Document result = collection.find(query).first();

        return result != null;
    }

    public void close() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
