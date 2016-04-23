package main.java.com.jakewert.attendance;

import java.util.Date;
import org.joda.time.DateTime;
import com.firebase.client.AuthData;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;

/**
* <h1>Driver</h1>
* The Driver class manages the Java portion of Attendance.
* <p>
* TODO Add a more detailed description.
* 
*
* @author  Jake Wert
* @version 0.1
*/
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
		    	System.out.println("Error");
		    }
		});
		
		System.out.println(Driver.parseDate("4:30 PM"));
	}
	
	/**
	   * This method is used to parse a date string of format 'h:mm a'.
	   * @param time This is the string representation of the time.
	   * @return Date This returns the parsed date.
	   */
	public static Date parseDate(String time)
	{
		String[] parsedTime = time.split("\\s+|:\\s*");
		
		int hour = Integer.parseInt(parsedTime[0]);
		int minute = Integer.parseInt(parsedTime[1]);
		
		if(parsedTime[2].equals("AM"))
		{
			if(hour == 12)
			{
				hour -= 12;
			}
		}
		else
		{
			if(hour != 12)
			{
				hour += 12;
			}
		}
		
		DateTime dateTime = new DateTime();
		
		return dateTime.withTime(hour, minute, 0, 0).toDate();
	}
}
