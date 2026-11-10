import java.sql.*;
import java.math.BigInteger;
import java.security.MessageDigest;

public class Datalayer {

   private Connection conn;
   private PreparedStatement pstmt;
   private ResultSet rs;
   private String user;
   private String password;
   private String database;

   final String DEFAULT_DRIVER = "com.mysql.cj.jdbc.Driver";

   public Datalayer(String user, String password, String database) {
      this.user = user;
      this.password = password;
      this.database = database;
   }

   public boolean connect() {
      conn = null;
      String url = "jdbc:mysql://localhost/" + database;
      url = url + "?serverTimezone=UTC";
      try {
         Class.forName(DEFAULT_DRIVER);
         conn = DriverManager.getConnection(url, user, password);
         System.out.println("\nConnection to Database successful!\n");
      } catch (ClassNotFoundException cnfe) {
         System.out.println("\nError, failed to connect to Database.");
         System.out.println("Error Type: " + cnfe);
         return false;
      } catch (SQLException sqle) {
         System.out.println("\nError, failed to connect to Database.");
         System.out.println("Error Type: " + sqle);
         return false;
      }
      return (conn != null);
   }

   private String encrypt(String secret) {
      String sha1 = "";
      String value = new String(secret);
      try {
         MessageDigest digest = MessageDigest.getInstance("SHA-1");
         digest.reset();
         digest.update(value.getBytes("utf8"));
         sha1 = String.format("%040x", new BigInteger(1, digest.digest()));
      } catch (Exception e) {
         e.printStackTrace();
      }
      System.out.println("The sha1 of \"" + value + "\" is:");
      System.out.println("--->" + sha1);
      System.out.println();
      return sha1;
   }

   // Create a new user with a hashed password
   public boolean createUser(String userType, String firstName, String lastName, String username, String rawPassword) {
      String hashedPassword = encrypt(rawPassword);
      String sql = "INSERT INTO UserAccount (UserType, FirstName, LastName, Username, Password) VALUES (?, ?, ?, ?, ?)";
      try {
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, userType);
         pstmt.setString(2, firstName);
         pstmt.setString(3, lastName);
         pstmt.setString(4, username);
         pstmt.setString(5, hashedPassword);
         int rows = pstmt.executeUpdate();
         return (rows > 0);
      } catch (SQLException sqle) {
         System.out.println("\nError creating user.");
         System.out.println("Error Type: " + sqle);
         return false;
      }
   }

   // Authenticate user login by comparing SHA-1 hashes
   public boolean authenticateUser(String username, String rawPassword) {
      String hashedPassword = encrypt(rawPassword);
      String sql = "SELECT User_ID, UserType, FirstName, LastName FROM UserAccount WHERE Username = ? AND Password = ?";
      try {
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, username);
         pstmt.setString(2, hashedPassword);
         rs = pstmt.executeQuery();

         if (rs.next()) {
            System.out.println("Login Successful! Welcome " + rs.getString("FirstName") + " " + rs.getString("LastName") + " (" + rs.getString("UserType") + ")");
            return true;
         } else {
            System.out.println("Login Failed: Invalid username or password.");
            return false;
         }
      } catch (SQLException sqle) {
         System.out.println("\nError authenticating user.");
         System.out.println("Error Type: " + sqle);
         return false;
      }
   }

   public boolean close() {
      try {
         if (rs != null) rs.close();
         if (pstmt != null) pstmt.close();
         if (conn != null) {
            conn.close();
            System.out.println("\nConnection to Database closed.\n");
            return true;
         } else {
            return false;
         }
      } catch (SQLException sqle) {
         System.out.println("\nError, failed to close Database connection.\n");
         System.out.println("Error Type: " + sqle);
         return false;
      }
   }
}