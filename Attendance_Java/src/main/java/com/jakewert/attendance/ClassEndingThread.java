package main.java.com.jakewert.attendance;

public class ClassEndingThread extends Thread
{
	private ClassListenerThread classThread;
	
	public ClassEndingThread(ClassListenerThread classThread)
	{
		this.classThread = classThread;
	}
	
	public void run()
	{
		//Wait for class to be over
		
		try
		{
			Thread.sleep(6000);
		} catch (InterruptedException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
