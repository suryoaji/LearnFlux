package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.support.v7.app.AlertDialog;
import android.support.v7.view.ContextThemeWrapper;
import android.widget.EditText;

import com.idesolusiasia.learnflux.LoginActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.db.DataSource;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.entity.User;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Random;

/**
 * Created by NAIT ADMIN on 24/06/2016.
 */
public class Functions {

	public static void showAlert(Context context,String title, String message){
		AlertDialog alertDialog = new AlertDialog.Builder(new ContextThemeWrapper(context, R.style.AppTheme)).create();
		alertDialog.setTitle(title);
		alertDialog.setMessage(message);
		alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "OK",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					}
				});
		alertDialog.show();
	}
	public static void showAlertWithCallback(Context context, String title, String message, final RequestTemplate.ServiceCallback callback){
		AlertDialog alertDialog = new AlertDialog.Builder(new ContextThemeWrapper(context, R.style.AppTheme)).create();
		alertDialog.setTitle(title);
		alertDialog.setMessage(message);
		alertDialog.setButton(AlertDialog.BUTTON_POSITIVE, "OK",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
						callback.execute(null);
					}
				});
		alertDialog.show();
	}

	public static int generateRandomPastelColor() {
		Random random = new Random();
		int red = random.nextInt(256);
		int green = random.nextInt(256);
		int blue = random.nextInt(256);

		// mix the color
		red = (red + 255) / 2;
		green = (green + 255) / 2;
		blue = (blue + 255) / 2;

		return Color.rgb(red,green,blue);
	}

	public static String convertSecondToDate(long second){
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("dd MMM yyyy kk:mm", Locale.US);
		second=second*1000;
		String a = simpleDateFormat.format(second);
		return a;
	}

	public static String convertSecondToAnyFormat(long second, String format){
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat(format, Locale.US);
		second=second*1000;
		String a = simpleDateFormat.format(second);
		return a;
	}

	public static void saveLastSync(Context c, String lastSync){
		SharedPreferences sharedPref = c.getApplicationContext().getSharedPreferences("com.idesolusiasia.learnflux",Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putString("lastSync",lastSync);
		editor.commit();
	}

	public static String getLastSync(Context c){
		SharedPreferences sharedPref = c.getApplicationContext().getSharedPreferences("com.idesolusiasia.learnflux",Context.MODE_PRIVATE);
		return sharedPref.getString("lastSync","0");
	}

	public static void addEventProcess(){

	}

	public static void logout(Context c){
		SharedPreferences sharedPref = c.getApplicationContext().getSharedPreferences("com.idesolusiasia.learnflux",Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPref.edit();
		editor.putString("username","");
		editor.putString("password","");
		editor.putString("lastSync","0");
		editor.commit();
		User.getUser().setUsername("");
		User.getUser().setPassword("");

		Intent i = new Intent(c, LoginActivity.class);
		i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
		c.startActivity(i);

		DataSource ds = new DataSource(c.getApplicationContext());
		ds.deleteDB();
	}

	public static String showInputAlertDialog(Context context,String title, String message, String hint){
		final String returnText="";
		final EditText editText = new EditText(context);

		editText.setHint(hint);

		new AlertDialog.Builder(context)
				.setTitle(title)
				.setMessage(message)
				.setView(editText)
				.setPositiveButton("Submit", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int whichButton) {
						String text = editText.getText().toString();
						returnText.replaceAll(".*",text);
					}
				})
				.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int whichButton) {
						dialog.dismiss();
					}
				})
				.show();

		return returnText;
	}

	/*
 * Copyright 2012 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */




	public static String getTimeAgo(long time) {
		final int SECOND_MILLIS = 1000;
		final int MINUTE_MILLIS = 60 * SECOND_MILLIS;
		final int HOUR_MILLIS = 60 * MINUTE_MILLIS;
		if (time < 1000000000000L) {
			// if timestamp given in seconds, convert to millis
			time *= 1000;
		}

		long now = System.currentTimeMillis();
		if (time > now || time <= 0) {
			return null;
		}

		// TODO: localize
		final long diff = now - time;
		if (diff < MINUTE_MILLIS) {
			return "just now";
		} else if (diff < 2 * MINUTE_MILLIS) {
			return "a minute ago";
		} else if (diff < 50 * MINUTE_MILLIS) {
			return diff / MINUTE_MILLIS + " minutes ago";
		} else if (diff < 120 * MINUTE_MILLIS) {
			return "an hour ago";
		} else if (diff < 24 * HOUR_MILLIS) {
			return diff / HOUR_MILLIS + " hours ago";
		} else if (diff < 48 * HOUR_MILLIS) {
			return "yesterday";
		} else {
			return convertSecondToAnyFormat(time/1000,"dd MMM yyyy");
		}
	}

	public static boolean isContainThread(Thread thing, List<Thread> threadList){
		for (int i=0;i<threadList.size();i++) {
			if (threadList.get(i).getId().equalsIgnoreCase(thing.getId())){
				return true;
			}
		}
		return false;
	}

	public static List<Object> sortingContact(List<Object> array){
		Collections.sort(array,
				new Comparator<Object>()
				{
					public int compare(Object f1, Object f2)
					{
						return f1.toString().compareTo(f2.toString());
					}
				});
		return array;
	}

}
