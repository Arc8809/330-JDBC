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

   //
   //~~~~~~~~~~~~~~~~~~~~ each account type's menu ~~~~~~~~~~~~~~~~~~~~
   //
   public void logIn(){
	   //user logs in
	   System.out.print("Username: ");
	   String user = GetInput.readLine();
	   System.out.print("Password: ");
	   String psswd = GetInput.readLine();

	   //some sort of thing to check that the username and password are correct

	   System.out.println("Welcome "+user+"!\n");

       //switch to determine account type
	   runMenuP();
	   //runMenuC();
	   //runMenuD();
   }


   //
   //~~~~~~~~~~~~~~~~~~~~ each account type's menu ~~~~~~~~~~~~~~~~~~~~
   //
   public void runMenuP(){
	   //player menu
   	   //continuously presents a menu of actions to the user until they select exit
   	   Boolean stillRunning = true;

   	   while(stillRunning) {
   		   	System.out.println("What is your next action?");
   		   	System.out.println("[1] My profile");
   		   	System.out.println("[2] Find a tournament");
   		   	System.out.println("[3] Game schedule");
   	   		System.out.println("[4] Log out");
   		   	String userInput = GetInput.readLine();

   	   		switch(userInput.toLowerCase()) {
   		   		case "1":
   		   		case "[1]":
   		   		case "profile":
   		   			myPlayerProfile();
   						System.out.println("");
   		   			break;
   		   		case "2":
   		   		case "[2]":
   		   		case "find":
   		   				teamSearch();
   						System.out.println("");
   				   		break;
   				case "3":
   				case "[3]":
   				case "schedule":
   						gameSchedule();
   						System.out.println("");
   				   		break;
   				case "4":
   				case "[4]":
   				case "logout":
   				   		System.out.println("\nGoodbye!");
   						stillRunning = false;
   				   		break;
   				default:
   				   		System.out.println("User input not recognized. Please try again.");
   			}//switch
   			System.out.println("");
		}//while loop
   }//playermenu

   public void runMenuC(){
	   	   //coach menu
      	   //continuously presents a menu of actions to the user until they select exit
      	   Boolean stillRunning = true;

      	   while(stillRunning) {
      		   	System.out.println("What is your next action?");
				System.out.println("[1] My profile");
				System.out.println("[2] Create a team");
				System.out.println("[3] Find a tournament");
				System.out.println("[4] Game schedule");
   	   			System.out.println("[5] Log out");
      		   	String userInput = GetInput.readLine();

      	   		switch(userInput.toLowerCase()) {
      		   		case "1":
      		   		case "[1]":
      		   		case "profile":
      		   				myCoachProfile();
   							System.out.println("");
      		   				break;
      		   		case "2":
      		   		case "[2]":
      		   		case "create":
      		   				createTeam();
   							System.out.println("");
      				   		break;
      				case "3":
      				case "[3]":
      				case "find":
      						tournamentSearch();
   							System.out.println("");
      				case "4":
					case "[4]":
      				case "schedule":
      						gameSchedule();
      						System.out.println("");
      				   		break;
      				case "5":
      				case "[5]":
      				case "logout":
      				   		System.out.println("\nGoodbye!");
      						stillRunning = false;
      				   		break;
      				default:
      				   		System.out.println("User input not recognized. Please try again.");
      			}//switch
      			System.out.println("");
      		}//while
   }//coach menu

   public void runMenuD(){
   	   	   //director menu
           //continuously presents a menu of actions to the user until they select exit
           Boolean stillRunning = true;

           while(stillRunning) {
         		System.out.println("What is your next action?");
   				System.out.println("[1] My profile");
   				System.out.println("[2] Create a tournament");
   				System.out.println("[3] Log out");
         		String userInput = GetInput.readLine();

         	   	switch(userInput.toLowerCase()) {
         		   	case "1":
         		   	case "[1]":
         			case "profile":
	     	   				myDirectorProfile();
	     	   				System.out.println("");
    		   				break;
         		   	case "2":
         			case "[2]":
         	   		case "create":
    		   				createTournament();
    		   				System.out.println("");
         					break;
         			case "3":
         			case "[3]":
         			case "logout":
    				   		System.out.println("\nGoodbye!");
     						stillRunning = false;
         		   			break;
         			default:
    			   		System.out.println("User input not recognized. Please try again.");
         			}//switch
         			System.out.println("");
         		}//while
   }//director menu


   //
   //~~~~~~~~~~~~~~~~~~~~ personal profiles ~~~~~~~~~~~~~~~~~~~~
   //
   public void myPlayerProfile() {
		//a player account's personal profile
	   System.out.println("My information(name, teams, stats)");
	   System.out.println("Menu offering edit data, teams, back to main menu");

	   Boolean stillRunning = true;

	    while(stillRunning) {
	      	System.out.println("What is your next action?");
		   	System.out.println("[1] Edit my information");
      		System.out.println("[2] See my teams");
		   	System.out.println("[3] Back to main menu");
      		String userInput = GetInput.readLine();

	   		switch(userInput.toLowerCase()) {
	      		case "1":
	       		case "[1]":
	      		   		System.out.println("Edit data");
	      				break;
	       		case "2":
  		   		case "[2]":
	      		   		System.out.println("List of teams a player is on");
	      		   		break;
	    		case "3":
  				case "[3]":
	      				System.out.println("\nGoodbye!");
	      				stillRunning = false;
	    		   		//Goes back to the main menu
  				   		break;
	      		default:
	    		   		System.out.println("User input not recognized. Please try again.");
  			    }//switch
	      		System.out.println("");
   		   }//while
	   }//myplayerprofile

	   public void myCoachProfile() {
			//a coach account's personal profile
	   	   System.out.println("My information(name, teams, stats)");
	   	   System.out.println("Menu offering edit data, see my teams, back to main menu");

	   	   Boolean stillRunning = true;

	   	    while(stillRunning) {
	  		   	System.out.println("What is your next action?");
	   	      	System.out.println("[1] Edit my information");
	   		   	System.out.println("[2] See my teams");
      		   	System.out.println("[3] Back to main menu");
	   	      	String userInput = GetInput.readLine();

	   	      	switch(userInput.toLowerCase()) {
	   		   		case "1":
      		   		case "[1]":
	   	      		   		System.out.println("Edit data");
	   	      				break;
	   	       		case "2":
	  		   		case "[2]":
	   	      		   		System.out.println("List of teams a coach coaches");
	   	      		   		break;
	   	    		case "3":
	  				case "[3]":
	   	      				System.out.println("\nGoodbye!");
	   	      				stillRunning = false;
	   	    		   		//Goes back to the main menu
	  				   		break;
   	      			default:
	   	    		   		System.out.println("User input not recognized. Please try again.");
	  			}//switch
	   	      	System.out.println("");
	      	}//while
	   }//mycoachprofile

	   public void myDirectorProfile() {
			//a director account's personal profile
	   	   System.out.println("My information(name, tournaments)");
	   	   System.out.println("Menu offering edit personal data, see tournaments, back to main menu");

	   	   Boolean stillRunning = true;

	   	    while(stillRunning) {
	   	      	System.out.println("What is your next action?");
	   		   	System.out.println("[1] Edit my information");
      		   	System.out.println("[2] See my tournaments");
	   	      	System.out.println("[3] Back to main menu");
	   		   	String userInput = GetInput.readLine();

	   	    	switch(userInput.toLowerCase()) {
	   	      		case "1":
	  		   		case "[1]":
	   	      		   		System.out.println("Edit data");
	   	      		   		break;
	   	      		case "2":
	   	       		case "[2]":
	  		   				System.out.println("List of tournaments the director is in charge of");
   	      				   	break;
	   	      		case "3":
	   	    		case "[3]":
	  				   		System.out.println("\nGoodbye!");
	   	      				stillRunning = false;
	   	      				//Goes back to the main menu
	   	      		   		break;
	   				default:
      				   		System.out.println("User input not recognized. Please try again.");
	   	      	}//switch
	   	       System.out.println("");
	      	}//while
	   }//mydirectorprofile


	//
	//~~~~~~~~~~~~~~~~~~~~ searches ~~~~~~~~~~~~~~~~~~~~
	//
	public void teamSearch() {
		System.out.println("Menu offering to search by sport, name, or coach");
	   System.out.println("Then a user can select a team, get information on it, and choose whether to join");
   }//teamsearch

	public void tournamentSearch() {
		System.out.println("Menu offering to search by sport, name, or director");
	    System.out.println("Then a user can select a tournament, get information on it, and choose whether to add one of their teams");
   }//tournament search


	//
	//~~~~~~~~~~~~~~~~~~~~ reports ~~~~~~~~~~~~~~~~~~~~
	//
	public void gameSchedule() {
		   System.out.println("Every game scheduled for the next month with the time, team, and opposing team");
	}


	//
	//~~~~~~~~~~~~~~~~~~~~ create processes ~~~~~~~~~~~~~~~~~~~~
	//
	public void createTeam() {
			System.out.println("Process to create a team");
	}

	public void createTournament() {
			System.out.println("Process to create a tournament");
	}
}
