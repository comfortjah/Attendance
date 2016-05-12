package main.java.com.jakewert.attendance;

import java.util.Scanner;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class CardReaderThread extends Thread
{
	//Have setters for class settings
	//have class listeners set the class information
	//listen for input all day
	//when input is received, send it to the class setting
	
	private String classKey;
	private Scanner input;
	
	public CardReaderThread()
	{
		this.input = new Scanner(System.in);
		this.classKey = "";
	}
	
	public void setClass(String classKey)
	{
		if(!this.isAlive())
		{
			this.classKey = classKey;
			this.start();
		}
		else
		{
			System.out.println("\r\nFinished taking attendance for " + this.classKey);
			this.classKey = classKey;
			System.out.print(this.classKey + "~ Student ID Card: ");
		}
	}
	
	public void start()
	{
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
			if(!studentID.equals(""))
			{
				DateTime dateTime = new DateTime();
				
				DateTimeFormatter dateFormat = DateTimeFormat.forPattern("M-d-yy");
				DateTimeFormatter timeFormat = DateTimeFormat.forPattern("h:mm a");
				
				String date = dateTime.toString(dateFormat);
				String time = dateTime.toString(timeFormat);
				
				FirebaseDAO dao = new FirebaseDAO("https://attendance-cuwcs.firebaseio.com");
				dao.addAttendanceRecord(this.classKey, date, studentID, time);
			}
		}
	}
	
}
