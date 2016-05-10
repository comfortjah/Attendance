package main.java.com.jakewert.attendance;

import java.io.IOException;
import java.util.Scanner;
import java.util.TimerTask;

import org.joda.time.DateTime;

public class ClassListener extends TimerTask
{
	private final String classKey;
	private final DateTime endTime;
	
	private Scanner input;
	
	public ClassListener(String classKey, DateTime endTime)
	{
		this.classKey = classKey;
		this.endTime = endTime;
		
		this.input = new Scanner(System.in);
	}

	@Override
	public void run()
	{
		//final long NANOSEC_PER_MIN = 1000l*1000*1000*60;
		
		ClassListenerThread classListenerThread = new ClassListenerThread(classKey);
		classListenerThread.start();
		
		//long startTime = System.nanoTime();
		//while ((System.nanoTime()-startTime)< duration*NANOSEC_PER_MIN)
		while (this.endTime.isAfterNow())
		{
			try
			{
				Thread.sleep(1000);
			}
			catch (InterruptedException e)
			{
				e.printStackTrace();
			}
		}
		
		try
		{
			classListenerThread.kill();
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}

}
