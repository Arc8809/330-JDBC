public class Presentationlayer {
   Datalayer db;

   public Presentationlayer() {
      System.out.println("Connecting to Database...");

      System.out.print("Enter username: ");
      String userName = GetInput.readLine().trim(); 
      if (userName.isEmpty()) {
         userName = "root";
      }
      System.out.print("Enter password: ");
      String password = GetInput.readLine().trim();
      if (password.isEmpty()) {
         password = "student";
      }
      System.out.print("Enter database: ");
      String database = GetInput.readLine().trim();
      if (database.isEmpty()) {
         database = "esports";
      } 

      db = new Datalayer(userName, password, database);
      
      if (db.connect()) {
         runMenu();
      }
   }

   public void runMenu() {
      int choice = 0;
      do {
         System.out.println("\n--- Esports Auth Menu ---");
         System.out.println("1. Create User");
         System.out.println("2. Login");
         System.out.println("3. Exit");
         System.out.print("Enter choice: ");
         choice = GetInput.readLineInt();

         switch (choice) {
            case 1:
               System.out.print("Enter UserType (Director/Coach/Player): ");
               String type = GetInput.readLine().trim();
               System.out.print("Enter First Name: ");
               String fName = GetInput.readLine().trim();
               System.out.print("Enter Last Name: ");
               String lName = GetInput.readLine().trim();
               System.out.print("Enter Username: ");
               String uName = GetInput.readLine().trim();
               System.out.print("Enter Password: ");
               String pass = GetInput.readLine().trim();

               if (db.createUser(type, fName, lName, uName, pass)) {
                  System.out.println("User created successfully!");
               }
               break;

            case 2:
               System.out.print("Enter Username: ");
               String loginUser = GetInput.readLine().trim();
               System.out.print("Enter Password: ");
               String loginPass = GetInput.readLine().trim();

               db.authenticateUser(loginUser, loginPass);
               break;

            case 3:
               db.close();
               break;

            default:
               System.out.println("Invalid choice. Try again.");
         }
      } while (choice != 3);
   }

   public static void main(String[] args) {
      new Presentationlayer();
   }
}