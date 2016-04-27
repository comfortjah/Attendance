package main.java.com.jakewert.attendance;

import java.util.Date;
import org.joda.time.DateTime;

/**
* <h1>TaskManager</h1>
* 
* <p>
* 
* TaskManager creates a TimerTask for each class at a set time
* before the class's start time. Each TimerTask is scheduled 
* and executed by the Timer.
* 
* <p>
* 
* @author  Jake Wert
* @version 0.1
*/
public class TaskManager
{
	public TaskManager()
	{
		
	}
	
	/**
	   * This method is used to parse a date string of format 'h:mm a'.
	   * 
	   * @param time This is the String representation
	   * (e.g. "2:35 PM", "12:00 AM", etc.)
	   * of the time.
	   * 
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
