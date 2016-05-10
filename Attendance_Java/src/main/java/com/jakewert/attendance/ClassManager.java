package main.java.com.jakewert.attendance;

import java.util.Date;
import java.util.HashMap;
import java.util.Timer;
import java.util.Map.Entry;

import org.joda.time.DateTime;

/**
* <h1>ClassManager</h1>
* 
* <p>
* 
* ClassManager creates a ClassListener for each class at a set time
* before the class's start time. Each ClassListener is scheduled 
* and executed by the ClassManager.
* 
* <p>
* 
* @author  Jake Wert
* @version 0.1
*/
public class ClassManager extends Timer
{
	private final HashMap<String, HashMap> theClasses;
	
	public ClassManager(HashMap<String, HashMap> theClasses)
	{
		this.theClasses = theClasses;
	}
	
	public void scheduleClasses()
	{
		for(Entry<String, HashMap> entry : this.theClasses.entrySet())
		{
    	    HashMap value = entry.getValue();
    	    
    	    String classKey = entry.getKey();
    	    String startTime = (String)value.get("startTime");
    	    DateTime endTime = this.parseDate((String)value.get("endTime")).minusMinutes(20);
    	    
    	    
    	    //Starts immediately if start time is in the past
    	    //In the case of a restart mid-day, as long as the class
    	    //has more than 5 minutes left to scan, it will begin
    	    //See FirebaseDAO for more information
    	    this.addClassListener(classKey, startTime, endTime);
		}
	}
	
	private void addClassListener(String classKey, String startTime, DateTime endTime)
	{
		ClassListener task = new ClassListener(classKey, endTime);
		this.schedule(task, this.parseDate(startTime).minusMinutes(15).toDate());
	}
	
	/**
	   * This method is used to parse a date string of format 'h:mm a'.
	   * 
	   * @param time This is the String representation
	   * (e.g. "2:35 PM", "12:00 AM", etc.)
	   * of the time.
	   * 
	   * @return DateTime This returns the parsed date.
	   */
	private DateTime parseDate(String time)
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
		
		return dateTime.withTime(hour, minute, 0, 0);
	}
}
