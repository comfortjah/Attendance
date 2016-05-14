package main.java.com.jakewert.attendance;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

/**
* <h1>Dates</h1>
*
* <p>
*
* Dates is a wrapper class for DateTime, which provides any and all
* Date or Time functionality needed to use this attendance system.
*
* <p>
*
* @author  Jake Wert
* @version 1.0
*/
public class Dates
{
	/**
	   * dayToday returns a single character abbreviation for the current
	   * day of the week.
	   *
	   * @return String a single character String representation of the
	   * day of the week
	   */
	public static String dayToday()
	{
		DateTime today = new DateTime();

		String[] days = {"M", "T", "W", "R", "F", "S", "S"};
		int todayIndex = today.getDayOfWeek()-1;

		return days[todayIndex];
	}

	/**
	   * dateToday returns today's date as a String
	   *
	   * @return String a String representation of today's date
	   */
	public static String dateToday()
	{
		DateTimeFormatter dateFormat = DateTimeFormat.forPattern("M-d-yy");

		return new DateTime().toString(dateFormat);
	}

	/**
	   * timeNow returns a the current time as a String
	   *
	   * @return String a String representation of the current time (e.g. "2:35 PM")
	   */
	public static String timeNow()
	{
		DateTimeFormatter timeFormat = DateTimeFormat.forPattern("h:mm a");

		return new DateTime().toString(timeFormat);
	}

	/**
	   * classHasEnded is used to determine if a class has ended its attendance taking.
	   * It accounts for a 3 minute buffer to prevent a race condition. Because classes
	   * normally stop attendance 20 minutes before their end time, this should leave
	   * sufficient time to take attendance in the instance of a reboot mid-day.
	   *
	   * @param time This is the String representation
	   * (e.g. "2:35 PM", "12:00 AM", etc.) of the endTime.
	   *
	   * @return boolean whether or not it is currently after the endTime.
	   */
	public static boolean classHasEnded(String endTimeStr)
	{
		DateTime endTime = Dates.parseTime(endTimeStr);

		return endTime.minusMinutes(23).isAfterNow();
	}

	/**
	   * This method is used to parse a time string of format 'h:mm a'.
	   *
	   * @param time This is the String representation
	   * (e.g. "2:35 PM", "12:00 AM", etc.)
	   * of the time.
	   *
	   * @return DateTime This returns the parsed date.
	   */
	public static DateTime parseTime(String time)
	{
		//"\\s+|:\\s*" is a regex for String.split(), which produces
		//an array like "2:35 PM" -> [HOUR, MINUTE, AM/PM]
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
