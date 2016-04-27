package main.java.com.jakewert.attendance;

import com.firebase.client.AuthData;
import com.firebase.client.Firebase;
import com.firebase.client.Firebase.AuthResultHandler;
import com.firebase.client.FirebaseError;

/**
* <h1>AuthenticationHandler</h1>
* 
* <p>
* 
* AuthenticationHandler authenticates the Java client with Firebase.
* 
* <p>
* 
* @author  Jake Wert
* @version 0.1
*/
public class AuthenticationHandler implements AuthResultHandler
{
	private Firebase ref;
	private boolean isDone;
	
	public AuthenticationHandler(String firebaseURL)
	{
		this.ref = new Firebase(firebaseURL);
		this.isDone = false;
	}
	
	/**
	   * authenticate makes an asynchronous call to authenticate with Firebase.
	   * 
	   * @param email This is the String representation 
	   * (e.g. "email@email.com")
	   * of the administrator's email account with Firebase.
	   *  
	   * @param password This is the String representation
	   * of the administrator's password.
	   * 
	   * @return void
	   */
	public void authenticate(String email, String password) throws InterruptedException
	{
		this.ref.authWithPassword(email, password, this);
		
		while(!this.isDone)
		{
			Thread.sleep(250);
		}
	}
	
	@Override
	public void onAuthenticated(AuthData authData)
	{
		// TODO Auto-generated method stub
		System.out.println("Authenticated");
		this.isDone = true;
	}

	@Override
	public void onAuthenticationError(FirebaseError error)
	{
		// TODO Auto-generated method stub
		System.out.println(error.getMessage());
	}

}
