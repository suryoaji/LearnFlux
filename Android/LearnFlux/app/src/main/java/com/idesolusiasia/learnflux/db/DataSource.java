package com.idesolusiasia.learnflux.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NAIT ADMIN on 17/06/2016.
 */
public class DataSource {

	//Database fields
	private SQLiteDatabase db;
	private DatabaseHelper dbHelper;
	private String[] allColumnsThread = {
			DatabaseHelper.COLUMN_THREAD_ID,
			DatabaseHelper.COLUMN_THREAD_TITLE,
			DatabaseHelper.COLUMN_THREAD_IMAGE};

	private String[] allColumnsMESSAGE = {
			DatabaseHelper.COLUMN_MESSAGE_ID,
			DatabaseHelper.COLUMN_MESSAGE_SENDER,
			DatabaseHelper.COLUMN_MESSAGE_BODY,
			DatabaseHelper.COLUMN_MESSAGE_CREATEDAT,
			DatabaseHelper.COLUMN_MESSAGE_THREADID};

	private String[] allColumnsPARTICIPANTS = {
			DatabaseHelper.COLUMN_PARTICIPANT_ID,
			DatabaseHelper.COLUMN_PARTICIPANT_NAME,
			DatabaseHelper.COLUMN_PARTICIPANT_IMAGE};

	public DataSource(Context context){
		dbHelper = new DatabaseHelper(context);
	}
	public void open() throws SQLException{
		db=dbHelper.getWritableDatabase();
	}
	public void close(){
		dbHelper.close();
	}


	//Threads
	public void createThread(Thread t){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_THREAD_ID,t.getId());
		values.put(DatabaseHelper.COLUMN_THREAD_TITLE,t.getTitle());
		values.put(DatabaseHelper.COLUMN_THREAD_IMAGE,t.getImage());
		db.insert(DatabaseHelper.TABLE_THREAD,null,values);
	}
	public void deleteThread(Thread t) {
		String id = t.getId();
		System.out.println("Thread deleted with id: " + id);
		db.delete(DatabaseHelper.TABLE_THREAD, DatabaseHelper.COLUMN_THREAD_ID
				+ "=?", new String[]{id});
	}
	public List<Thread> getAllThread(){
		List<Thread> threads = new ArrayList<Thread>();

		Cursor cursor = db.query(DatabaseHelper.TABLE_THREAD,
				allColumnsThread, null, null, null, null, null);

		cursor.moveToFirst();
		while (!cursor.isAfterLast()) {
			Thread t = cursorToThread(cursor);
			threads.add(t);
			Log.i("Threads", t.toString());
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();
		return threads;
	}
	private Thread cursorToThread(Cursor cursor) {
		Thread t = new Thread();
		t.setId(cursor.getString(0));
		t.setTitle(cursor.getString(1));
		t.setImage(cursor.getString(2));
		return t;
	}

	//Messages
	public void createMessage(Message m){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_MESSAGE_ID,m.getID());
		values.put(DatabaseHelper.COLUMN_MESSAGE_SENDER,m.getSender());
		values.put(DatabaseHelper.COLUMN_MESSAGE_BODY,m.getBody());
		values.put(DatabaseHelper.COLUMN_MESSAGE_CREATEDAT,m.getCreatedAt());
		values.put(DatabaseHelper.COLUMN_MESSAGE_THREADID,m.getThreadID());
		db.insert(DatabaseHelper.TABLE_MESSAGE,null,values);
	}
	public void deleteMessage(Message m) {
		String id = m.getID();
		System.out.println("Message deleted with id: " + id);
		db.delete(DatabaseHelper.TABLE_MESSAGE, DatabaseHelper.COLUMN_MESSAGE_ID
				+ "=?", new String[]{id});
	}
	public List<Message> getAllMessageByThread(String threadID){
		List<Message> messages = new ArrayList<Message>();

		Cursor cursor = db.query(DatabaseHelper.TABLE_MESSAGE,
				allColumnsMESSAGE,DatabaseHelper.COLUMN_MESSAGE_THREADID+"=?",new String[] {threadID},null,null,null);

		cursor.moveToFirst();
		while (!cursor.isAfterLast()) {
			Message m = cursorToMessage(cursor);
			messages.add(m);
			Log.i("Message", m.toString());
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();
		return messages;
	}
	private Message cursorToMessage(Cursor cursor) {
		Message m = new Message();
		m.setID(cursor.getString(0));
		m.setSender(cursor.getString(1));
		m.setBody(cursor.getString(2));
		m.setCreatedAt(cursor.getLong(3));
		m.setThreadID(cursor.getString(4));
		return m;
	}

	//Participants
	public void createParticipant(Participant p){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_PARTICIPANT_ID,p.getID());
		values.put(DatabaseHelper.COLUMN_PARTICIPANT_NAME,p.getName());
		values.put(DatabaseHelper.COLUMN_PARTICIPANT_IMAGE,p.getImage());
		db.insert(DatabaseHelper.TABLE_PARTICIPANT,null,values);
	}
	public void deleteParticipant(Participant p) {
		String id = p.getID();
		System.out.println("Participant deleted with id: " + id);
		db.delete(DatabaseHelper.TABLE_PARTICIPANT, DatabaseHelper.COLUMN_PARTICIPANT_ID
				+ "=?", new String[]{id});
	}
	public Participant getParticipantByID(String participantID){

		Cursor cursor = db.query(DatabaseHelper.TABLE_PARTICIPANT,
				allColumnsPARTICIPANTS,null,null,null,null,null);

		if (cursor != null)
			cursor.moveToFirst();

		Participant p = cursorToParticipant(cursor);

		// make sure to close the cursor
		cursor.close();
		return p;
	}
	private Participant cursorToParticipant(Cursor cursor) {
		Participant p = new Participant();
		p.setID(cursor.getString(0));
		p.setName(cursor.getString(1));
		p.setImage(cursor.getString(2));
		return p;
	}
}
