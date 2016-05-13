package main.java.com.jakewert.attendance;

import java.util.TimerTask;

/**
* <h1>ClassKiller</h1>
* 
* <p>
* 
* ClassKiller is a TimerTask, which is to be scheduled by a Timer.
* It will be executed 20 minutes prior to the end time of class and
* set the CardReaderThread's classKey to the empty string, effectively
* ending the attendance taking for a class.
* 
* <p>
* 
* @author  Jake Wert
* @version 1.0
*/
public class ClassKiller extends TimerTask
{
	private CardReaderThread crt;
	
	public ClassKiller(CardReaderThread crt)
	{	
		this.crt = crt;
	}
	
	@Override
	public void run()
	{
		this.crt.setClass();
	}
}
