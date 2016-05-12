package main.java.com.jakewert.attendance;

import java.io.IOException;
import java.util.Scanner;
import java.util.TimerTask;

import org.joda.time.DateTime;

public class ClassListener extends TimerTask
{
	private final String classKey;
	private final DateTime endTime;
	private CardReaderThread crt;
	private Scanner input;
	
	public ClassListener(String classKey, DateTime endTime, CardReaderThread crt)
	{
		this.classKey = classKey;
		this.endTime = endTime;
		
		this.crt = crt;
		
		this.input = new Scanner(System.in);
	}

	@Override
	public void run()
	{
		this.crt.setClass(classKey);
	}

}
