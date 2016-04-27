package main.java.com.jakewert.attendance;

import java.util.HashMap;
import java.util.Map.Entry;

import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.ValueEventListener;

public class FirebaseDAO_OLD
{
	private Firebase ref;
	private Firebase refClasses;
	
	private HashMap<String, Object> theClasses;
	//So we can access a boolean via a pointer and use it as a signal
	private boolean[] isDone = {false};
	
	private final String FIREBASE_URL = "https://attendance-cuwcs.firebaseio.com";
	
	public FirebaseDAO_OLD()
	{
		this.ref = new Firebase(this.FIREBASE_URL);
		this.refClasses = ref.child("Classes");
		
		this.theClasses = new HashMap<String, Object>();
	}
	
	private boolean isDone()
	{
		return this.isDone[0];
	}
	
	public HashMap<String, Object> getTheClasses() throws InterruptedException
	{
		while(!this.isDone())
		{
			Thread.sleep(300);
		}
		
		return this.theClasses;
	}
	
	public void retrieveClasses(String day, String room)
	{
		this.retrieveClasses(day, room, this.theClasses, this.isDone);
	}
	
	private void retrieveClasses(final String day, final String room, final HashMap<String, Object> theClasses, final boolean[] isDone)
	{
		this.refClasses.addListenerForSingleValueEvent(new ValueEventListener()
		{
		    @Override
		    public void onDataChange(DataSnapshot snapshot)
		    {
		        //System.out.println(snapshot.getValue());		    	
		    	HashMap<String, HashMap> data = (HashMap<String, HashMap>) snapshot.getValue();
		    	
		    	for(Entry<String, HashMap> entry : data.entrySet())
		    	{
		    		String key = entry.getKey();
		    	    HashMap value = entry.getValue();
		    		
		    	    HashMap<String, Object> theClass = data.get(key); 
		    	    if(theClass.get("room").equals(room) && ((String)theClass.get("days")).contains(day))
		    	    {
		    	    	theClasses.put(key, value);
		    	    	
		    	    	System.out.print(key);
			    	    System.out.print(" -> ");
			    	    System.out.println(value);
		    	    }
		    	}
		    	
		    	//Signals we are done
		    	isDone[0] = true;
		    }
		    @Override
		    public void onCancelled(FirebaseError firebaseError)
		    {
		        System.out.println("The read failed: " + firebaseError.getMessage());
		    }
		});

	}
	
	
}
