package com.idesolusiasia.learnflux.db;

import android.content.Context;

import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.Thread;

import java.util.List;

/**
 * Created by NAIT ADMIN on 22/07/2016.
 */
public class DatabaseFunction {
	public static void insertParticipant (Context c, List<Participant> participants){
		DataSource ds = new DataSource(c.getApplicationContext());
		ds.open();
		for (Participant p:participants) {
			ds.createParticipant(p);
		}
		ds.close();
		ds=null;
	}

	public static void insertThread (Context c, List<Thread> threads){
		DataSource ds = new DataSource(c.getApplicationContext());
		ds.open();
		for (Thread t:threads) {
			ds.createThread(t);
		}
		//List<Thread> ts= ds.getAllThreadWithAllMessage();
		ds.close();
		ds=null;
	}

	public static List<Thread> getThreadList (Context c){
		DataSource ds = new DataSource(c.getApplicationContext());
		ds.open();
		List<Thread> ts= ds.getAllThread();
		ds.close();
		ds=null;

		return ts;
	}
}
