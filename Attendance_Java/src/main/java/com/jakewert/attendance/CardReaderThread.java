package main.java.com.jakewert.attendance;

import java.util.Scanner;

/**
* <h1>CardReaderThread</h1>
* 
* <p>
* 
* CardReaderThread manages the the input from the card reader
* and communicates with its instance of FirebaseDAO to create
* attendance records.
* 
* <p>
* 
* @author  Jake Wert
* @version 1.0
*/
public class CardReaderThread extends Thread
{	
	/*	The key used to identify a given class in the Firebase database
	 * 	"" (empty String) indicates there is currently no class
	 */
	private String classKey;
	private Scanner input;
	private FirebaseDAO dao;
	
	public CardReaderThread()
	{
		this.input = new Scanner(System.in);
		this.classKey = "";
	}
	
	/**
	   * This method is used to set the current class
	   * 
	   * @param classKey This is the String representation of the key
	   * used to identify a given class in the Firebase database
	   * (e.g. "-KHOKLhMCwo_giyOi8iQ").
	   * 
	   */
	public void setClass(String classKey)
	{
		if(!this.isAlive())
		{
			this.classKey = classKey;
			this.start();
		}
		else
		{
			this.classKey = classKey;
			System.out.print(this.classKey + "~ Student ID Card: ");
		}
	}
	
	/**
	   * This method is used to set the class to an empty String,
	   * effectively signaling this Thread that the previous class's
	   * attendance has been taken.
	   */
	public void setClass()
	{
		System.out.println("\r\nFinished taking attendance for " + this.classKey);
		this.classKey = "";
	}
	
	public void run()
	{
		this.dao = new FirebaseDAO("https://attendance-cuwcs.firebaseio.com");
		while (true)
		{
			System.out.print(this.classKey + "~ Student ID Card: ");
			String studentID = "";
			try
			{
				studentID = this.input.nextLine();
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			if(!studentID.equals("") && !this.classKey.equals(""))
			{	
				this.dao.addAttendanceRecord(this.classKey, Dates.dateToday(), studentID, Dates.timeNow());
			}
		}
	}
	
}
