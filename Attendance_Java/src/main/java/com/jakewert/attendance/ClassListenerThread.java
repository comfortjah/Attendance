package main.java.com.jakewert.attendance;

import java.io.IOException;
import java.util.NoSuchElementException;
import java.util.Scanner;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class ClassListenerThread extends Thread
{
	private Scanner input;
	
	public ClassListenerThread(String classKey)
	{
		super(classKey);
		this.input = new Scanner(System.in);
	}
	
	public void run()
	{
		while (true)
		{
			try
			{
				System.out.print(this.getName() + "~ Student ID Card: ");
				String studentID = input.nextLine();
				
				DateTime dateTime = new DateTime();
				
				DateTimeFormatter dateFormat = DateTimeFormat.forPattern("M-d-yy");
				DateTimeFormatter timeFormat = DateTimeFormat.forPattern("h:mm a");
				
				String date = dateTime.toString(dateFormat);
				String time = dateTime.toString(timeFormat);
				
				FirebaseDAO dao = new FirebaseDAO("https://attendance-cuwcs.firebaseio.com");
				dao.addAttendanceRecord(this.getName(), date, studentID, time);
			}
			catch(NoSuchElementException e)
			{
				break;
			}	
		}
		System.out.println("\r\n" +this.getName() + "~ Done taking attendance.");
	}

	public void kill() throws IOException
	{
		//this.input.close();
		System.in.close();
	}
}
