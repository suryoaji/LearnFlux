package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.DatePicker;
import android.widget.ImageView;

import junit.framework.Test;

import java.util.Calendar;

public class HomeActivity extends BaseActivity {

	private StaggeredGridLayoutManager gaggeredGridLayoutManager;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);
		super.onCreateDrawer(savedInstanceState);

		ImageView ivInterest  = (ImageView)findViewById(R.id.ivInterest);
		ivInterest.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent a = new Intent(HomeActivity.this, InterestGroup.class);
				startActivity(a);
			}
		});
		ImageView ivChat= (ImageView) findViewById(R.id.ivChat);
		ivChat.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(HomeActivity.this,ChatsActivity.class);
				i.putExtra("chatroom", "org");
				startActivity(i);
			}
		});
		ImageView ivGallery = (ImageView)findViewById(R.id.ivGallery);
		ImageView ivCalendar = (ImageView)findViewById(R.id.ivCalendar);
		ivCalendar.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				final Calendar c = Calendar.getInstance();
				DatePickerDialog datePicker = new DatePickerDialog(HomeActivity.this, new DatePickerDialog.OnDateSetListener() {
					@Override
					public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
						c.set(year,month,dayOfMonth);
					}
				},c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DAY_OF_MONTH));
				datePicker.show();
			}
		});
		ImageView ivProject = (ImageView) findViewById(R.id.ivProject);
		ivProject.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent i = new Intent(HomeActivity.this, ProjectActivity.class);
				i.putExtra("projectAct", "activity");
				startActivity(i);
			}
		});

	}


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.home, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();

		//noinspection SimplifiableIfStatement
		if (id == R.id.action_settings) {
			return true;
		}

		return super.onOptionsItemSelected(item);
	}

}
