package com.idesolusiasia.learnflux.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import com.idesolusiasia.learnflux.entity.BasicItem;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.Message;
import com.idesolusiasia.learnflux.entity.MessageEvent;
import com.idesolusiasia.learnflux.entity.MessagePoll;
import com.idesolusiasia.learnflux.entity.Participant;
import com.idesolusiasia.learnflux.entity.Poll;
import com.idesolusiasia.learnflux.entity.Thread;

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
			DatabaseHelper.COLUMN_THREAD_IMAGE,
			DatabaseHelper.COLUMN_THREAD_REFID,
			DatabaseHelper.COLUMN_THREAD_REFTYPE};

	private String[] allColumnsMESSAGE = {
			DatabaseHelper.COLUMN_MESSAGE_ID,
			DatabaseHelper.COLUMN_MESSAGE_SENDER,
			DatabaseHelper.COLUMN_MESSAGE_BODY,
			DatabaseHelper.COLUMN_MESSAGE_CREATEDAT,
			DatabaseHelper.COLUMN_MESSAGE_THREADID,
			DatabaseHelper.COLUMN_MESSAGE_REFID,
			DatabaseHelper.COLUMN_MESSAGE_REFTYPE};

	private String[] allColumnsPARTICIPANTS = {
			DatabaseHelper.COLUMN_PARTICIPANT_ID,
			DatabaseHelper.COLUMN_PARTICIPANT_NAME,
			DatabaseHelper.COLUMN_PARTICIPANT_IMAGE};

	private String[] allColumnsTHREADMEMBER = {
			DatabaseHelper.COLUMN_THREADMEMBER_THREADID,
			DatabaseHelper.COLUMN_THREADMEMBER_PARTICIPANTID};

	private String[] allColumnsEVENT = {
			DatabaseHelper.COLUMN_EVENT_ID,
			DatabaseHelper.COLUMN_EVENT_TITLE,
			DatabaseHelper.COLUMN_EVENT_DETAILS,
			DatabaseHelper.COLUMN_EVENT_LOCATION,
			DatabaseHelper.COLUMN_EVENT_TIMESTAMP};

	private String[] allColumnsPOLL = {
			DatabaseHelper.COLUMN_POLL_ID,
			DatabaseHelper.COLUMN_POLL_TITLE};

	public DataSource(Context context){
		dbHelper = new DatabaseHelper(context);
	}
	public void open() throws SQLException{
		db=dbHelper.getWritableDatabase();
	}
	public void close(){
		dbHelper.close();
	}

	public void deleteDB(){
		open();
		dbHelper.clearDatabase(db);
		close();
	}

	//Threads
	public void createThread(Thread t){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_THREAD_ID,t.getId());
		values.put(DatabaseHelper.COLUMN_THREAD_TITLE,t.getTitle());
		values.put(DatabaseHelper.COLUMN_THREAD_IMAGE,t.getImage());

		if (t.getGroup()!=null){
			values.put(DatabaseHelper.COLUMN_THREAD_REFID, t.getGroup().getId());
			values.put(DatabaseHelper.COLUMN_THREAD_REFTYPE, t.getGroup().getType());
		}

		db.beginTransaction();
		try {
			db.insertWithOnConflict(DatabaseHelper.TABLE_THREAD,null,values,SQLiteDatabase.CONFLICT_IGNORE);
			if (t.getMessages()!=null){
				for (Message m:t.getMessages()) {
					createMessage(m, t.getId());
				}
			}

			if (t.getParticipants()!=null){
				for (Participant p:t.getParticipants()) {
					createParticipant(p);
					createThreadMember(t.getId(),p.getId());
				}
			}

			db.setTransactionSuccessful();
		}finally {
			db.endTransaction();
		}
	}
	public void deleteThread(Thread t) {
		String id = t.getId();
		Log.i("deleteThread ",id);
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
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();

		for (Thread t:threads) {
			t.setLastMessage(getLastMessageByThread(t.getId()));
		}
		return threads;
	}
	public Thread getThreadByID(String id){
		Thread t=new Thread();
		Cursor cursor = db.query(DatabaseHelper.TABLE_THREAD,
				allColumnsThread,DatabaseHelper.COLUMN_THREAD_ID+"=?",new String[] {id},null,null,null);

		cursor.moveToFirst();
		while (!cursor.isAfterLast()) {
			t = cursorToThread(cursor);
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();

		t.setMessages(getAllMessageByThread(t.getId()));
		t.setParticipants(getParticipantByThreadID(t.getId()));
		return t;
	}
	private Thread cursorToThread(Cursor cursor) {
		Thread t = new Thread();
		t.setId(cursor.getString(0));
		t.setTitle(cursor.getString(1));
		t.setImage(cursor.getString(2));
		if (cursor.getString(3)!=null){
			BasicItem g = new BasicItem();
			g.setId(cursor.getString(3));
			g.setType(cursor.getString(4));
			t.setGroup(g);
		}
		return t;
	}

	//Messages
	public void createMessage(Message m, String threadID){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_MESSAGE_ID,m.getId());
		values.put(DatabaseHelper.COLUMN_MESSAGE_SENDER,m.getSender().getId());
		values.put(DatabaseHelper.COLUMN_MESSAGE_BODY,m.getBody());
		values.put(DatabaseHelper.COLUMN_MESSAGE_CREATEDAT,m.getCreatedAt());
		values.put(DatabaseHelper.COLUMN_MESSAGE_THREADID,threadID);

		if(m instanceof MessageEvent){
			values.put(DatabaseHelper.COLUMN_MESSAGE_BODY,m.getSender().getFirstName()+" create an event");
			values.put(DatabaseHelper.COLUMN_MESSAGE_REFID,((MessageEvent)m).getEvent().getId());
			values.put(DatabaseHelper.COLUMN_MESSAGE_REFTYPE,((MessageEvent)m).getEvent().getType());
			createEvent(((MessageEvent)m).getEvent());
		}else if (m instanceof MessagePoll){
			values.put(DatabaseHelper.COLUMN_MESSAGE_BODY,m.getSender().getFirstName()+" create a poll");
			values.put(DatabaseHelper.COLUMN_MESSAGE_REFID,((MessagePoll)m).getPoll().getId());
			values.put(DatabaseHelper.COLUMN_MESSAGE_REFTYPE,((MessagePoll)m).getPoll().getType());
			createPoll(((MessagePoll)m).getPoll());
		}
		db.insert(DatabaseHelper.TABLE_MESSAGE,null,values);

		createParticipant(m.getSender());
	}
	public void deleteMessage(Message m) {
		String id = m.getId();
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
			//Log.i("Message", String.valueOf(m.getSender().getId()));
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();
		return messages;
	}
	public Message getLastMessageByThread(String threadID){
		Message message = new Message();

		Cursor cursor = db.query(DatabaseHelper.TABLE_MESSAGE,
				allColumnsMESSAGE,DatabaseHelper.COLUMN_MESSAGE_THREADID+"=?",new String[] {threadID},null,null,
				DatabaseHelper.COLUMN_MESSAGE_ID+" desc","1");

		cursor.moveToFirst();
		while (!cursor.isAfterLast()) {
			message = cursorToMessage(cursor);
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();
		return message;
	}
	private Message cursorToMessage(Cursor cursor) {
		Message m=new Message();
		if (cursor.getString(6)!=null){
			if (cursor.getString(6).equalsIgnoreCase("event")){
				m=new MessageEvent();
				((MessageEvent)m).setEvent(getEventByID(cursor.getString(5)));
			}else if (cursor.getString(6).equalsIgnoreCase("poll")){
				m=new MessagePoll();
				((MessagePoll)m).setPoll(getPollByID(cursor.getString(5)));
			}
		}

		m.setId(cursor.getString(0));
		m.setSender(getParticipantByID(cursor.getString(1)));
		m.setBody(cursor.getString(2));
		m.setCreatedAt(cursor.getLong(3));
		return m;
	}

	//Participants
	public void createParticipant(Participant p){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_PARTICIPANT_ID,p.getId());
		values.put(DatabaseHelper.COLUMN_PARTICIPANT_NAME,p.getFirstName());
		values.put(DatabaseHelper.COLUMN_PARTICIPANT_IMAGE,p.getPhoto());
		db.insertWithOnConflict(DatabaseHelper.TABLE_PARTICIPANT,null,values,SQLiteDatabase.CONFLICT_IGNORE);
	}
	public void deleteParticipant(Participant p) {
		String id = String.valueOf(p.getId());
		System.out.println("Participant deleted with id: " + id);
		db.delete(DatabaseHelper.TABLE_PARTICIPANT, DatabaseHelper.COLUMN_PARTICIPANT_ID
				+ "=?", new String[]{id});
	}
	public Participant getParticipantByID(String participantID){

		Cursor cursor = db.query(DatabaseHelper.TABLE_PARTICIPANT,
				allColumnsPARTICIPANTS,DatabaseHelper.COLUMN_PARTICIPANT_ID+"=?",new String[] {participantID},null,null,
				DatabaseHelper.COLUMN_PARTICIPANT_ID+" desc","1");

		if (cursor != null)
			cursor.moveToFirst();

		Participant p = cursorToParticipant(cursor);

		// make sure to close the cursor
		cursor.close();
		return p;
	}
	private Participant cursorToParticipant(Cursor cursor) {
		Participant p = new Participant();
		p.setId(Integer.parseInt(cursor.getString(0)));
		p.setFirstName(cursor.getString(1));
		p.setPhoto(cursor.getString(2));
		return p;
	}

	//Thread Member
	public void createThreadMember(String threadId, int participantId){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_THREADMEMBER_THREADID,threadId);
		values.put(DatabaseHelper.COLUMN_THREADMEMBER_PARTICIPANTID,participantId);
		db.insertWithOnConflict(DatabaseHelper.TABLE_THREADMEMBER,null,values,SQLiteDatabase.CONFLICT_IGNORE);
	}

	public List<Participant> getParticipantByThreadID(String threadID){
		ArrayList<Participant> participants = new ArrayList<>();
		String query = "SELECT "+DatabaseHelper.COLUMN_PARTICIPANT_ID+","+DatabaseHelper.COLUMN_PARTICIPANT_NAME+","+DatabaseHelper.COLUMN_PARTICIPANT_IMAGE
				+" FROM "+DatabaseHelper.TABLE_PARTICIPANT+" p, "+DatabaseHelper.TABLE_THREADMEMBER+" tm"
				+" WHERE p."+DatabaseHelper.COLUMN_PARTICIPANT_ID+"=tm."+DatabaseHelper.COLUMN_THREADMEMBER_PARTICIPANTID
				+" AND tm."+DatabaseHelper.COLUMN_THREADMEMBER_THREADID+"=?";

		Cursor cursor =db.rawQuery(query, new String[]{String.valueOf(threadID)});

		cursor.moveToFirst();
		while (!cursor.isAfterLast()) {
			Participant t = cursorToParticipant(cursor);
			participants.add(t);
			cursor.moveToNext();
		}
		// make sure to close the cursor
		cursor.close();

		return participants;
	}

	//POLL
	public void createPoll(Poll p){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_POLL_ID,p.getId());
		values.put(DatabaseHelper.COLUMN_POLL_TITLE,p.getTitle());
		db.insert(DatabaseHelper.TABLE_POLL,null,values);
	}

	public Poll getPollByID(String pollID){

		Cursor cursor = db.query(DatabaseHelper.TABLE_POLL,
				allColumnsPOLL,DatabaseHelper.COLUMN_POLL_ID+"=?",new String[] {pollID},null,null,
				DatabaseHelper.COLUMN_POLL_ID+" desc","1");

		if (cursor != null)
			cursor.moveToFirst();

		Poll p = cursorToPoll(cursor);

		// make sure to close the cursor
		cursor.close();
		return p;
	}

	private Poll cursorToPoll(Cursor cursor) {
		Poll p = new Poll();
		p.setId(cursor.getString(0));
		p.setTitle(cursor.getString(1));
		return p;
	}

	//Event
	public void createEvent(Event e){
		ContentValues values= new ContentValues();
		values.put(DatabaseHelper.COLUMN_EVENT_ID,e.getId());
		values.put(DatabaseHelper.COLUMN_EVENT_TITLE,e.getTitle());
		values.put(DatabaseHelper.COLUMN_EVENT_DETAILS,e.getDetails());
		values.put(DatabaseHelper.COLUMN_EVENT_LOCATION,e.getLocation());
		values.put(DatabaseHelper.COLUMN_EVENT_TIMESTAMP,e.getTimestamp());
		db.insert(DatabaseHelper.TABLE_EVENT,null,values);
	}

	public Event getEventByID(String eventID){

		Cursor cursor = db.query(DatabaseHelper.TABLE_EVENT,
				allColumnsEVENT,DatabaseHelper.COLUMN_EVENT_ID+"=?",new String[] {eventID},null,null,
				DatabaseHelper.COLUMN_EVENT_ID+" desc","1");

		if (cursor != null)
			cursor.moveToFirst();

		Event p = cursorToEvent(cursor);

		// make sure to close the cursor
		cursor.close();
		return p;
	}

	private Event cursorToEvent(Cursor cursor) {
		Event e = new Event();
		e.setId(cursor.getString(0));
		e.setTitle(cursor.getString(1));
		e.setDetails(cursor.getString(2));
		e.setLocation(cursor.getString(3));
		e.setTimestamp(Long.parseLong(cursor.getString(4)));
		return e;
	}
}
