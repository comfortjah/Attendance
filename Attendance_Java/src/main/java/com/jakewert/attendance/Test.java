package main.java.com.jakewert.attendance;

import java.io.IOException;
import java.util.HashMap;
import java.util.Scanner;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class Test
{	
	public static void main(String[] args) throws InterruptedException, IOException
	{
		final String FIREBASE_URL = "https://attendance-cuwcs.firebaseio.com";
		
		final String email = "awesomefat@email.com";
		final String password = "dragonflaps";
		
		final String day = "T";
		final String room = "Stuenkel 120";
		
		AuthenticationHandler authHandler = new AuthenticationHandler(FIREBASE_URL);
		authHandler.authenticate(email, password);
		
		FirebaseDAO dao = new FirebaseDAO(FIREBASE_URL);
		HashMap<String, HashMap> theClasses = dao.retrieveClasses(day, room);
		
		ClassManager classManager = new ClassManager(theClasses);
		classManager.scheduleClasses();
	}

}
