import java.sql.*;

public class Datalayer{

   private Connection conn;
   private String user;
   private String password;
   private String database;

   final String DEFAULT_DRIVER = "com.mysql.cj.jdbc.Driver";

   public Datalayer(String user, String password, String database){
      this.user = user;
      this.password = password;
      this.database = database;
   }

   public boolean connect(){
      conn = null;
      String url = "jdbc:mysql://localhost/" + database;
      url = url + "?serverTimezone=UTC";
      try{
         Class.forName(DEFAULT_DRIVER);
         conn = DriverManager.getConnection(url, user, password);
         System.out.println("\nConnection to Database successfull!\n");
      }catch(ClassNotFoundException cnfe){
         System.out.println("\nError, failed to connect to Database.");
         System.out.println("Error Type: " + cnfe);
         return false;
      }catch(SQLException sqle){
         System.out.println("\nError, failed to connect to Database.");
         System.out.println("Error Type: " + sqle);
         return false;
      }
      return (conn!=null);
   }

   public boolean close(){
      try{
         if (conn != null){
            conn.close();
            System.out.println("\nConnection to Database closed.\n");
            return true;
         }else{
            return false;
         }
      }catch(SQLException sqle){
         System.out.println("\nError, failed to close Database connection.\n");
         System.out.println("Error Type: " + sqle);
         return false;
      }
   }
}
