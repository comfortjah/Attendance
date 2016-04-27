package main.java.com.jakewert.attendance;

/**
* 
* <h1>Driver</h1>
* 
* <p>
* 
* Driver class manages the Java portion of Attendance.
* 
* <p>
*
* @author  Jake Wert
* @version 0.1
*/
public class Driver
{
	public static void main(String[] args) throws InterruptedException
	{	
		final String FIREBASE_URL = "https://attendance-cuwcs.firebaseio.com";
		
		final String email = "email@email.com";
		final String password = "********";
		
		final String day = "M";
		final String room = "Stuenkel 120B";
		
		AuthenticationHandler authHandler = new AuthenticationHandler(FIREBASE_URL);
		authHandler.authenticate(email, password);
		
		FirebaseDAO dao = new FirebaseDAO(FIREBASE_URL);
		System.out.println(dao.retrieveClasses(day, room));
	}
	
	
	
	
}
