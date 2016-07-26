package com.idesolusiasia.learnflux.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

/**
 * Created by NAIT ADMIN on 17/06/2016.
 */
public class DatabaseHelper extends SQLiteOpenHelper {
	private static final String DATABASE_NAME = "database.db";
	private static final int DATABASE_VERSION = 1;

	public static final String TABLE_THREAD = "thread";
	public static final String COLUMN_THREAD_ID = "id";
	public static final String COLUMN_THREAD_TITLE = "title";
	public static final String COLUMN_THREAD_IMAGE = "image";

	public static final String TABLE_MESSAGE = "message";
	public static final String COLUMN_MESSAGE_ID = "id";
	public static final String COLUMN_MESSAGE_SENDER = "sender";
	public static final String COLUMN_MESSAGE_BODY = "body";
	public static final String COLUMN_MESSAGE_CREATEDAT = "createdat";
	public static final String COLUMN_MESSAGE_THREADID = "threadid";

	public static final String TABLE_PARTICIPANT = "participant";
	public static final String COLUMN_PARTICIPANT_ID = "id";
	public static final String COLUMN_PARTICIPANT_NAME = "name";
	public static final String COLUMN_PARTICIPANT_IMAGE = "image";

	// Database creation sql statement
	private static final String DATABASE_CREATE_THREAD = "create table "
			+ TABLE_THREAD + "("
			+COLUMN_THREAD_ID + " text primary key not null, "
			+COLUMN_THREAD_TITLE + " text,"
			+COLUMN_THREAD_IMAGE + " text"
			+");";

	private static final String DATABASE_CREATE_MESSAGE = "create table "
			+ TABLE_MESSAGE + "("
			+COLUMN_MESSAGE_ID + " text primary key not null, "
			+COLUMN_MESSAGE_SENDER + " text,"
			+COLUMN_MESSAGE_BODY + " text,"
			+COLUMN_MESSAGE_CREATEDAT + " text,"
			+COLUMN_MESSAGE_THREADID + " text"
			+");";

	private static final String DATABASE_CREATE_PARTICIPANT = "create table "
			+ TABLE_PARTICIPANT + "("
			+COLUMN_PARTICIPANT_ID + " text primary key not null, "
			+COLUMN_PARTICIPANT_NAME + " text,"
			+COLUMN_PARTICIPANT_IMAGE + " text"
			+");";

	public DatabaseHelper(Context context){
		super(context,DATABASE_NAME,null,DATABASE_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {

		//Log.i("message", DATABASE_CREATE_MESSAGE);
		db.execSQL(DATABASE_CREATE_THREAD);
		db.execSQL(DATABASE_CREATE_MESSAGE);
		db.execSQL(DATABASE_CREATE_PARTICIPANT);
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		Log.w(DatabaseHelper.class.getName(),
				"Upgrading database from version " + oldVersion + " to "
						+ newVersion + ", which will destroy all old data");
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_THREAD);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_MESSAGE);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_PARTICIPANT);
		onCreate(db);
	}

	public void clearDatabase(SQLiteDatabase db){
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_THREAD);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_MESSAGE);
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_PARTICIPANT);
		onCreate(db);
	}
}
