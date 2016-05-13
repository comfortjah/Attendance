package main.java.com.jakewert.attendance;

import java.util.HashMap;
import java.util.Map.Entry;

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
* @version 1.0
*/
public class FirebaseDAO implements ValueEventListener
{
	private Firebase ref;
	
	//This is a HashMap<String, HashMap> (similar structure to JSON)
	//which contains the classes that the FirebaseDAO has retrieved.
	private HashMap<String, HashMap> theClasses;
	
	//isDone is used to block access to theClasses 
	//until they are retrieved from Firebase
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
	
	/**
	   * addAttendanceRecord creates a new attendance record for the class
	   * corresponding to <i>classKey</i>, for the day <i>date</i> at the
	   * time <i>time</i>.
	   * 
	   * @param classKey This is the String representation ("-KHOKLhMCwo_giyOi8iQ")
	   * of the key used to identify a given class in the Firebase database.
	   *  
	   * @param date This is the String representation (e.g. "5-13-16")
	   * of the date on which the student signed into class.
	   * 
	   * @param studentID This is the String representation (e.g. "05984231")
	   * of the 8 digit number stored on a student ID.
	   * 
	   * @param time This is the String representation (e.g. "2:35 PM")
	   * of the time a student signed into class.
	   * 
	   * @return HashMap<String, HashMap This returns a HashMap of the filtered classes.
	   */
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
		HashMap<String, HashMap> data = (HashMap<String, HashMap>) snapshot.getValue();
		
    	for(Entry<String, HashMap> entry : data.entrySet())
    	{
    		String key = entry.getKey();
    	    HashMap value = entry.getValue();
    		
    	    HashMap<String, Object> theClass = data.get(key);
    	    
    	    String endTime = (String)theClass.get("endTime");
    	    
    	    if(theClass.get("room").equals(this.room) && ((String)theClass.get("days")).contains(this.day))
    	    {
    	    	//In case of restart mid-day
    	    	if(Dates.classHasEnded(endTime))
    	    	{
    	    		this.theClasses.put(key, value);
    	    		System.out.println("Scheduling: " + theClass.get("className") + " (" + theClass.get("startTime") + " to " + endTime + ")");
    	    	}
    	    }
    	}
    	
    	this.isDone = true;
	}
}
