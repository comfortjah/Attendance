package main.java.com.jakewert.attendance;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class ClassListenerThread extends Thread
{
	//private Scanner input;
	//private InputStreamReader console;
	private InputStreamReader input;
	private BufferedReader reader;
	private BufferedWriter writer;
	private OutputStreamWriter output;
	private boolean finishedAttendance;
	
	public ClassListenerThread(String classKey)
	{
		super(classKey);
	}
	
	public void run()
	{
		
	}
}
