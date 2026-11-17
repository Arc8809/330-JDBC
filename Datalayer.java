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
      String url = "jdbc:mysql://localhost/";
      url = url + database + "?serverTimezone=UTC";
      try {
         Class.forName(DEFAULT_DRIVER);
         conn = DriverManager.getConnection(url, user, password);
         System.out.println("\nConnection to Database successful!\n");
      } catch (ClassNotFoundException ex) {
         System.out.println("\nError, failed to connect to Database.");
         System.out.println("Error Type: " + ex);
         return false;
      } catch (SQLException e) {
         System.out.println("\nError, failed to connect to Database.");
         System.out.println("Error Type: " + e);
         return false;
      }
      return (conn != null);
   }

   // Converts plain-text password into a 40-character SHA-1 hex string
   public String encrypt(String inputPass) {
      String hashedPass = "";
      try {
         MessageDigest md = MessageDigest.getInstance("SHA-1");
         byte[] messageDigest = md.digest(inputPass.getBytes("UTF-8"));
         BigInteger number = new BigInteger(1, messageDigest);
         hashedPass = String.format("%040x", number);
      } catch (Exception e) {
         System.out.println("Error hashing password: " + e.getMessage());
      }
      return hashedPass;
   }

   // Create a new user in UserAccount (with hashed password) and their ERD role table
   public boolean createUser(String userType, String firstName, String lastName, String username, String rawPassword) {
      String hashedPassword = encrypt(rawPassword);
      String sql = "INSERT INTO UserAccount (UserType, FirstName, LastName, Username, Password) VALUES (?, ?, ?, ?, ?)";
      try {
         pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
         pstmt.setString(1, userType);
         pstmt.setString(2, firstName);
         pstmt.setString(3, lastName);
         pstmt.setString(4, username);
         pstmt.setString(5, hashedPassword);
         int rows = pstmt.executeUpdate();

         if (rows > 0) {
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
               int newUserId = rs.getInt(1);
               insertRoleRecord(userType, newUserId);
            }
            return true;
         }
         return false;
      } catch (SQLException sqle) {
         System.out.println("\nError creating user.");
         System.out.println("Error Type: " + sqle);
         return false;
      }
   }

   // Helper method to insert User_ID into Players, Coaches, or Directors
   private void insertRoleRecord(String userType, int userId) throws SQLException {
      String roleSql = "";
      if (userType.equalsIgnoreCase("Player")) {
         roleSql = "INSERT INTO Players (User_ID) VALUES (?)";
      } else if (userType.equalsIgnoreCase("Coach")) {
         roleSql = "INSERT INTO Coaches (User_ID) VALUES (?)";
      } else if (userType.equalsIgnoreCase("Director")) {
         roleSql = "INSERT INTO Directors (User_ID) VALUES (?)";
      }

      if (!roleSql.isEmpty()) {
         PreparedStatement roleStmt = conn.prepareStatement(roleSql);
         roleStmt.setInt(1, userId);
         roleStmt.executeUpdate();
         roleStmt.close();
      }
   }

   // Authenticate user login by comparing the SHA-1 hash of input against UserAccount
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

   // Allow users to change their password after verifying their current password hash
   public boolean changePassword(String username, String oldPass, String newPass) {
      String oldHash = encrypt(oldPass);
      String newHash = encrypt(newPass);
      String sql = "UPDATE UserAccount SET Password = ? WHERE Username = ? AND Password = ?";
      try {
         pstmt = conn.prepareStatement(sql);
         pstmt.setString(1, newHash);
         pstmt.setString(2, username);
         pstmt.setString(3, oldHash);
         int rows = pstmt.executeUpdate();

         if (rows > 0) {
            System.out.println("Password changed successfully!");
            return true;
         } else {
            System.out.println("Could not change password. Check your username or old password.");
            return false;
         }
      } catch (SQLException sqle) {
         System.out.println("\nError changing password.");
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
