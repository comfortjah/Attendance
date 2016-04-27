package main.java.com.jakewert.attendance;

import com.firebase.client.AuthData;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;

/**
* <h1>Authentication</h1>
* The Authentication class manages the authentication
* between this client and Firebase.
* <p>
* TODO Add a more detailed description.
* 
*
* @author  Jake Wert
* @version 0.1
*/
public class Authentication
{
	private String email;
	private String password;
	private StringBuilder uid;
	private Firebase ref;
	
	private final String FIREBASE_URL = "https://attendance-cuwcs.firebaseio.com";
	private final int NUM_CHARS_UID = 36;
	
	public Authentication(String email, String password)
	{
		this.email = email;
		this.password = password;
		
		this.ref = new Firebase(this.FIREBASE_URL);
		this.uid = new StringBuilder(this.NUM_CHARS_UID);
	}
	
	/**
	   * This method is used to determine when authentication has been complete.
	   * @return boolean Returns true if authenticated and false if not
	   */
	private boolean isDone()
	{
		return this.uid.length() == 36;
	}
	
	/**
	   * This method is used to parse a date string of format 'h:mm a'.
	   * @param time This is the string representation of the time.
	   * @return Date This returns the parsed date.
	   */
	public String getUid() throws InterruptedException
	{
		while(!this.isDone())
		{
			System.out.println("Haven't finished authenticating...");
			
			//Wait before checking again
			Thread.sleep(300);
		}
		
		return this.uid.toString();
	}
	
	/**
	   * This method serves as a wrapper to call authenticate(final StringBuilder uid)
	   * without providing outside access to uid.
	   * @return void
	   */
	public void authenticate()
	{
		System.out.println("Authenticating...");
		
		this.authenticate(this.uid);
	}
	
	/**
	   * This method authenticates with Firebase. A StringBuilder 
	   * is used for the pointer. Because the authentication is 
	   * asynchronous and takes place in a closure, I use a pointer 
	   * capable of holding a String.
	   * @param uid This is a StringBuilder to hold the uid
	   * @return void
	   */
	private void authenticate(final StringBuilder uid)
	{
		TestAuthHandler tah = new TestAuthHandler();
		this.ref.authWithPassword(this.email, this.password, tah);
		
		/*
		this.ref.authWithPassword(this.email, this.password, new Firebase.AuthResultHandler()
		{
		    @Override
		    public void onAuthenticated(AuthData authData)
		    {
		    	System.out.println("Authenticated.");
		        uid.append(authData.getUid());
		    }
		    @Override
		    public void onAuthenticationError(FirebaseError firebaseError)
		    {
		    	System.out.println("Failed to authenticate.");
		    	System.out.println(firebaseError.getMessage());
		    	
		    	//TODO exit the app or try again, stop the (what would be) infinite while loop in this.getUid()
		    }
		});
		*/
	}
}
