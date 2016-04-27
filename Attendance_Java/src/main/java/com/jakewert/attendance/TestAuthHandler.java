package main.java.com.jakewert.attendance;

import com.firebase.client.AuthData;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;

public class TestAuthHandler implements Firebase.AuthResultHandler
{
	private String uid;
	
	@Override
    public void onAuthenticated(AuthData authData)
    {
    	System.out.println("Authenticated.");
    	uid = authData.getUid();
    }
    @Override
    public void onAuthenticationError(FirebaseError firebaseError)
    {
    	System.out.println("Failed to authenticate.");
    	System.out.println(firebaseError.getMessage());
    	
    	//TODO exit the app or try again, stop the (what would be) infinite while loop in this.getUid()
    }
}
