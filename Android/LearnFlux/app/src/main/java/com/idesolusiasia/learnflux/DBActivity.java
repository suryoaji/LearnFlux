package com.idesolusiasia.learnflux;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import com.idesolusiasia.learnflux.db.DataSource;

public class DBActivity extends AppCompatActivity {
	DataSource ds;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_db);

		ds = new DataSource(getApplicationContext());
		ds.open();
		//initThread();

	}

	/*void initThread(){
		Thread t = new Thread();
		t.setTitle("Thread 1");
		t.setId("T001");
		ds.createThread(t);

		t = new Thread();
		t.setTitle("Thread 2");
		t.setId("T002");
		ds.createThread(t);

		t = new Thread();
		t.setTitle("Thread 3");
		t.setId("T003");
		ds.createThread(t);

		Message m = new Message();
		m.setThreadID("T001");
		m.setBody("Hey");
		m.setSender("S001");
		m.setID("M001");
		ds.createMessage(m);

		m.setThreadID("T001");
		m.setBody("I'm Agatha");
		m.setSender("S001");
		m.setID("M002");
		ds.createMessage(m);

		m.setThreadID("T002");
		m.setBody("heelloooo");
		m.setSender("S001");
		m.setID("M003");
		ds.createMessage(m);


		ds.getAllThread();
		ds.getAllMessageByThread("T001");
	}*/

	@Override
	protected void onStop() {
		super.onStop();
		ds.close();
	}
}
