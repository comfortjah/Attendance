package main.java.com.jakewert.attendance;

import java.util.Date;
import java.util.HashMap;
import java.util.Map.Entry;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.Firebase.CompletionListener;
import com.firebase.client.FirebaseError;
import com.firebase.client.ValueEventListener;

/**
* <h1>FirebaseDAO</h1>
* 
* <p>
* 
* FirebaseDAO facilitates all communication
* (in the realm of data retrieval) with Firebase.
* It retrieves all of the classes in the attendance 
* system and filters them by room and meet days.
* 
* <p>
* 
* @author  Jake Wert
* @version 0.1
*/
public class FirebaseDAO implements ValueEventListener
{
	private Firebase ref;
	private HashMap<String, HashMap> theClasses;
	private boolean isDone;
	
	private String room;
	private String day;
	
	public FirebaseDAO(String firebaseURL)
	{
		this.ref = new Firebase(firebaseURL);
		this.theClasses = new HashMap<String, HashMap>();
		this.isDone = false;
	}
	
	/**
	   * retrieveClasses establishes a single event listener on the value of all classes. 
	   * Then the classes are filtered on the meeting days and the room.
	   * 
	   * @param day This is the String representation 
	   * (e.g. Monday -> "M", Thursday -> "R", etc.)
	   * of the day the class needs to meet.
	   *  
	   * @param room This is the String representation
	   * (e.g. "Stuenkel 120B")
	   * of the room the class needs to meet in.
	   * 
	   * @return HashMap<String, HashMap This returns a HashMap of the filtered classes.
	   */
	public HashMap<String, HashMap> retrieveClasses(String day, String room) throws InterruptedException
	{
		this.room = room;
		this.day = day;
		
		this.ref.child("Classes").addListenerForSingleValueEvent(this);
		
		while(!this.isDone)
		{
			Thread.sleep(250);
		}
		
		return this.theClasses;
	}
	
	public void addAttendanceRecord(String classKey, String date, String studentID, String time)
	{
		Firebase attendanceRecord = this.ref.child("Classes").child(classKey).child("Attendance").child(date).child(studentID);
		
		attendanceRecord.setValue(time, new CompletionListener()
		{

			@Override
			public void onComplete(FirebaseError error, Firebase ref)
			{
				if(error == null)
				{
					
				}
				else
				{
					System.out.println(error.getMessage());
				}
			}
		});
	}

	@Override
	public void onCancelled(FirebaseError error)
	{
		System.out.println("The read failed: " + error.getMessage());
	}

	@Override
	public void onDataChange(DataSnapshot snapshot)
	{
		DateTimeFormatter formatter = DateTimeFormat.forPattern("hh:mm a");
		HashMap<String, HashMap> data = (HashMap<String, HashMap>) snapshot.getValue();
    	for(Entry<String, HashMap> entry : data.entrySet())
    	{
    		String key = entry.getKey();
    	    HashMap value = entry.getValue();
    		
    	    HashMap<String, Object> theClass = data.get(key);
    	    
    	    String endTimeStr = (String)theClass.get("endTime");
    	    
    	    DateTime endTime = this.parseDate(endTimeStr);
    	    
    	    if(theClass.get("room").equals(this.room) && ((String)theClass.get("days")).contains(this.day))
    	    {
    	    	System.out.println(theClass.get("className"));
    	    	System.out.println(endTime);
    	    	System.out.println(endTime.isAfterNow());
    	    	
    	    	//In case of restart mid-day
    	    	//Leaves a 3 minute buffer to be safe
    	    	if(endTime.minusMinutes(23).isAfterNow())
    	    	{
    	    		this.theClasses.put(key, value);
    	    	}
    	    }
    	}
    	
    	this.isDone = true;
	}
	
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
