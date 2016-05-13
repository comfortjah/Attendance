package main.java.com.jakewert.attendance;

import java.util.HashMap;

/**
* 
* <h1>AttendanceLauncher</h1>
* 
* <p>
* 
* AttendanceLauncher facilitates the attendance taking process.
* 
* <p>
*
* @author  Jake Wert
* @version 0.1
*/
public class AttendanceLauncher
{
	public static void main(String[] args) throws InterruptedException
	{	
		final String FIREBASE_URL = "https://attendance-cuwcs.firebaseio.com";
		
		final String email = "attendance.cuwcs@gmail.com";
		final String password = "********";
		
		final String day = Dates.dayToday();
		final String room = "Stuenkel 120";
		
		AuthenticationHandler authHandler = new AuthenticationHandler(FIREBASE_URL);
		authHandler.authenticate(email, password);
		
		FirebaseDAO dao = new FirebaseDAO(FIREBASE_URL);
		HashMap<String, HashMap> theClasses = dao.retrieveClasses(day, room);
		
		ClassManager classManager = new ClassManager(theClasses);
		classManager.scheduleClasses();
	}
}
