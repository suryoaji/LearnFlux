package com.idesolusiasia.learnflux.util;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.support.v7.app.AlertDialog;
import android.support.v7.view.ContextThemeWrapper;

import com.idesolusiasia.learnflux.LoginActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.User;

import org.json.JSONObject;

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

	public static void reLogin(final Context context, final RequestTemplate.ServiceCallback reDo){
		Engine.login(context, User.getUser().getUsername(), User.getUser().getPassword(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				Engine.getMe(context);
				if (reDo!=null){
					reDo.execute(obj);
				}

			}
		}, new RequestTemplate.ErrorCallback() {
			@Override
			public void execute(JSONObject error) {
				Intent i = new Intent(context, LoginActivity.class);
				i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_CLEAR_TASK);
				context.startActivity(i);

			}
		});
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
}
