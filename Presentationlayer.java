//presentation layer
public class Presentationlayer {
   	Datalayer db;

   	public Presentationlayer(){
		   System.out.println("Connecting to Database...");

         System.out.print("Enter username: ");
         String userName = GetInput.readLine(); 
         System.out.print("Enter password: ");
         String password = GetInput.readLine(); 
         System.out.print("Enter database: ");
         String database = GetInput.readLine(); 

         db = new Datalayer(userName, password, database);
         db.connect();
      }

   public static void main(String [] args){;
      new Presentationlayer();
   }
}
