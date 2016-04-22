package main.java.com.jakewert.attendance;

import com.firebase.client.*;

public class Driver
{
	public static void main(String[] args)
	{	
		Firebase ref = new Firebase("https://attendance-cuwcs.firebaseio.com");
		ref.authWithPassword("attendance.cuwcs@gmail.com", "admin", new Firebase.AuthResultHandler()
		{
		    @Override
		    public void onAuthenticated(AuthData authData)
		    {
		        System.out.println("User ID: " + authData.getUid() + ", Provider: " + authData.getProvider());
		    }
		    @Override
		    public void onAuthenticationError(FirebaseError firebaseError)
		    {
		        // there was an error
		    	System.out.println("Error");
		    }
		});
		
		while(true)
		{
			
		}
	}
	
	//Given start time and end time, 
	//loop while it is 15 minutes before class until 15 minutes before end of class
	//Once loop closes, check schedule (downloaded from firebase) for next class
	//After all classes restart at 12:00am?
	
	//param format -> "00:00 PM" OR "0:00 PM"
	public static void listenForClassAttendance(String startTime, String endTime)
	{
		
	}
}
