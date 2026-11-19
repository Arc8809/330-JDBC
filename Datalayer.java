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
   private String userType;
   private int userID;
   private int roleID;

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
   }//connect

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
   }//close


   //
   //~~~~~~~~~~~~~~~~~~~~ password encryption ~~~~~~~~~~~~~~~~~~~~
   //
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
            System.out.println("Login Successful! Welcome " + rs.getString("FirstName") + " " + rs.getString("LastName") + " (" + rs.getString("UserType") + ")\n\n");
			 userID = rs.getInt("User_ID");
			 // run the user type's menu
			 switch(rs.getString("UserType")) {
				 case "Player":
					 userType = "Player";
					 getPlayerID();
					 runMenuP();
					 break;
				 case "Coach":
					 userType = "Coach";
					 getCoachID();
					 runMenuC();
					 break;
				 case "Director":
					 userType = "Director";
					 getDirectorID();
					 runMenuD();
					 break;
			 }//switch
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


   //
   //~~~~~~~~~~~~~~~~~~~~ each account type's menu ~~~~~~~~~~~~~~~~~~~~
   //
   public void runMenuP(){
	   //player menu
   	   //continuously presents a menu of actions to the user until they select exit
   	   Boolean stillRunning = true;

   	   while(stillRunning) {
   		   	System.out.println("--- Main Menu ---");
   		   	System.out.println("[1] My profile");
   		   	System.out.println("[2] Find a tournament");
   		   	System.out.println("[3] Tournament news");
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
			    System.out.println("[3] Tournament news");
   				System.out.println("[4] Log out");
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
         			case "recent":
    				   		recentGamesTD();
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
         		}//while
   }//director menu


   //
   //~~~~~~~~~~~~~~~~~~~~ personal profiles ~~~~~~~~~~~~~~~~~~~~
   //
	public void myProfile() {
	   try {
			String query = "SELECT Username, FirstName, LastName FROM UserAccount ";
			query += "WHERE User_ID=?;";
			PreparedStatement stmt = conn.prepareCall(query);
			stmt.setInt(1,userID);
			rs = stmt.executeQuery();

		   	if(rs.next()) {
					//tournamnet name
					System.out.println("\n\n--- "+rs.getString(1)+"' account ---");	
					System.out.println("First name: "+rs.getString(2));	
					System.out.println("Last name: "+rs.getString(3));	
					System.out.println("Account type: "+userType);	

		   	} //if

		} catch(SQLException e) {
			e.printStackTrace();
		}//catch
   }//myProfile
	
   public void myPlayerProfile() {
		//a player account's personal profile
	    myProfile();

	   Boolean stillRunning = true;

	    while(stillRunning) {
	      	System.out.println("\nWhat is your next action?");
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
	      				stillRunning = false;
	    		   		//Goes back to the main menu
  				   		break;
	      		default:
	    		   		System.out.println("User input not recognized. Please try again.");
  			    }//switch
   		   }//while
	   }//myplayerprofile

	   public void myCoachProfile() {
			//a coach account's personal profile
	   	    myProfile();

	   	   Boolean stillRunning = true;

	   	    while(stillRunning) {
	  		   	System.out.println("\nWhat is your next action?");
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
	   	      				stillRunning = false;
	   	    		   		//Goes back to the main menu
	  				   		break;
   	      			default:
	   	    		   		System.out.println("User input not recognized. Please try again.");
	  			}//switch
	      	}//while
	   }//mycoachprofile

	   public void myDirectorProfile() {
			//a director account's personal profile
	   	    myProfile();
		   
	   	   Boolean stillRunning = true;

	   	    while(stillRunning) {
	   	      	System.out.println("\nWhat is your next action?");
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
	   	      				stillRunning = false;
	   	      				//Goes back to the main menu
	   	      		   		break;
	   				default:
      				   		System.out.println("User input not recognized. Please try again.");
	   	      	}//switch
	      	}//while
	   }//mydirectorprofile


	//
	//~~~~~~~~~~~~~~~~~~~~ searches ~~~~~~~~~~~~~~~~~~~~
	//
	public void teamSearch() {
		System.out.println("Menu offering to search by sport, name, or coach");
	   System.out.println("Then a user can select a team, get information on it, and choose whether to join\n");
   }//teamsearch

	public void tournamentSearch() {
		System.out.println("Menu offering to search by sport, name, or director");
	    System.out.println("Then a user can select a tournament, get information on it, and choose whether to add one of their teams\n");
   }//tournament search


	//
	//~~~~~~~~~~~~~~~~~~~~ reports ~~~~~~~~~~~~~~~~~~~~
	//
	public void gameSchedule() {
		   System.out.println("Every game scheduled for the next month with the time, team, and opposing team\n");
	}//gameSchedule

	public void recentGamesTD() {
		   try {
				String query = "SELECT Tournament_ID, TournamentName FROM Tournaments ";
				query += "WHERE Director_ID=?;";
				PreparedStatement stmt = conn.prepareCall(query);
				stmt.setInt(1,roleID);
				rs = stmt.executeQuery();

		   		while(rs.next()) {
						//tournamnet name
						System.out.println(rs.getString(2));
						
						//get scores
						Integer tournament_id = rs.getInt(1);
						query = "{CALL GetRecentGameScoresTournament(?,?,?,?,?)}";
			 			CallableStatement stmt2 = conn.prepareCall(query);
			 			stmt2.setInt(1,tournament_id);

			 			stmt2.execute();

						if(stmt2.getString(2)!= null) {
								System.out.println(stmt2.getString(2)+" vs "+stmt2.getString(3));
								System.out.println(stmt2.getString(4)+"-"+stmt2.getString(5));
								System.out.println(stmt2.getString(2)+" is the winner!\n");
						} else {
							System.out.println("Games have not begun for this tournament");
						}
			   	} //while

			} catch(SQLException e) {
				e.printStackTrace();
			}//catch
	}//recentGamesTD


	//
	//~~~~~~~~~~~~~~~~~~~~ create processes ~~~~~~~~~~~~~~~~~~~~
	//
	public void createTeam() {
			System.out.println("Process to create a team\n");
	}//createteam

	public void createTournament() {
			System.out.println("Process to create a tournament\n");
	}//createtournament

	//
	//~~~~~~~~~~~~~~~~~~~~ get role-specific ids ~~~~~~~~~~~~~~~~~~~~
	//
	public void getPlayerID() {
		try {
			String query = "SELECT Player_ID FROM Players ";
			query += "WHERE User_ID=?;";
			PreparedStatement stmt = conn.prepareCall(query);
			stmt.setInt(1,userID);
			rs = stmt.executeQuery();
			if(rs.next()) {
				roleID = rs.getInt(1);
			}//if
		} catch(SQLException e) {
			e.printStackTrace();
		}//catch
	}//getPlayerID

	public void getCoachID() {
		try {
			String query = "SELECT Coach_ID FROM Coaches ";
			query += "WHERE User_ID=?;";
			PreparedStatement stmt = conn.prepareCall(query);
			stmt.setInt(1,userID);
			rs = stmt.executeQuery();
			if(rs.next()) {
				roleID = rs.getInt(1);
			}//if
		} catch(SQLException e) {
			e.printStackTrace();
		}//catch
	}//getCoachID

	public void getDirectorID() {
		try {
			String query = "SELECT Director_ID FROM Directors ";
			query += "WHERE User_ID=?;";
			PreparedStatement stmt = conn.prepareCall(query);
			stmt.setInt(1,userID);
			rs = stmt.executeQuery();
			if(rs.next()) {
				roleID = rs.getInt(1);
			}//if
		} catch(SQLException e) {
			e.printStackTrace();
		}//catch
	}//getDirectorID
	
}
