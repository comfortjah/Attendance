package main.java.com.jakewert.attendance;

import java.util.HashMap;
import java.util.Timer;
import java.util.Map.Entry;
import org.joda.time.DateTime;

/**
* <h1>ClassManager</h1>
* 
* <p>
* 
* ClassManager creates a ClassListener and ClassKiller for each class
* at a set time before the class's start time. Each ClassListener and 
* ClassKiller is scheduled and executed by the ClassManager.
* 
* <p>
* 
* @author  Jake Wert
* @version 1.0
*/
public class ClassManager extends Timer
{
	//This is (similar structure to JSON) and contains
	// the classes that the FirebaseDAO retrieved
	private final HashMap<String, HashMap> theClasses;
	private CardReaderThread crt;

	public ClassManager(HashMap<String, HashMap> theClasses)
	{
		this.theClasses = theClasses;
		this.crt = new CardReaderThread();
	}
	
	/**
	   * scheduleClasses iterates through theClasses and adds each member (class)
	   * to the attendance schedule for the day.
	   * 
	   */
	public void scheduleClasses()
	{
		for(Entry<String, HashMap> entry : this.theClasses.entrySet())
		{
    	    HashMap value = entry.getValue();
    	    
    	    String classKey = entry.getKey();
    	    DateTime startTime = Dates.parseTime((String)value.get("startTime"));
    	    DateTime endTime = Dates.parseTime((String)value.get("endTime"));
    	    
    	    /*
    	    Starts immediately if start time is in the past
    	    In the case of a restart mid-day, as long as the class
    	    has more than 3 minutes left to scan, it will begin
    	    See FirebaseDAO for more information
    	    */
    	    this.addClassListener(classKey, startTime, endTime);
		}
	}
	
	/**
	   * addClassListener schedules a single class to start and end at given times.
	   * 
	   * @param classKey The key used to identify a given class in the Firebase database.
	   * "" (empty String) indicates there is currently no class
	   *  
	   * @param startTime This is the DateTime representation of the classes' start time
	   * 
	   * @param endTime This is the DateTime representation of the classes' end time
	   * 
	   */
	private void addClassListener(String classKey, DateTime startTime, DateTime endTime)
	{
		ClassListener taskStart = new ClassListener(classKey, this.crt);
		ClassKiller taskEnd = new ClassKiller(this.crt);
		
		this.schedule(taskStart, startTime.minusMinutes(15).toDate());
		this.schedule(taskEnd, endTime.minusMinutes(20).toDate());
	}
}
