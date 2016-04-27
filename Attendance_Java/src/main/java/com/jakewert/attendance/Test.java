package main.java.com.jakewert.attendance;

import java.util.HashMap;

import com.firebase.client.Firebase;

public class Test
{
	public static void main(String args[]) throws InterruptedException
	{
		final String FIREBASE_URL = "https://attendance-cuwcs.firebaseio.com";
		
		final String email = "awesomefat@email.com";
		final String password = "dragonflaps";
		
		final String day = "M";
		final String room = "Stuenkel 120B";
		
		AuthenticationHandler authHandler = new AuthenticationHandler(FIREBASE_URL);
		authHandler.authenticate(email, password);
		
		FirebaseDAO dao = new FirebaseDAO(FIREBASE_URL);
		System.out.println(dao.retrieveClasses(day, room));
	}
}
