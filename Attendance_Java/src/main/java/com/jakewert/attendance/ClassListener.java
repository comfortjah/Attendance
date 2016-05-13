package main.java.com.jakewert.attendance;

import java.util.TimerTask;

/**
* <h1>ClassListener</h1>
* 
* <p>
* 
* ClassListener is a TimerTask, which is to be scheduled by a Timer.
* It will be executed 15 minutes prior to the start time of class and
* set the CardReaderThread's classKey to that provided to ClassListener.
* 
* <p>
* 
* @author  Jake Wert
* @version 1.0
*/
public class ClassListener extends TimerTask
{
	private final String classKey;
	private CardReaderThread crt;
	
	public ClassListener(String classKey, CardReaderThread crt)
	{
		this.classKey = classKey;
		
		this.crt = crt;
	}

	@Override
	public void run()
	{
		this.crt.setClass(classKey);
	}

}
