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
import com.idesolusiasia.learnflux.entity.User;

import java.text.SimpleDateFormat;
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
		SimpleDateFormat simpleDateFormat=new SimpleDateFormat("dd-MMM-yyyy kk:mm", Locale.US);
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

}
