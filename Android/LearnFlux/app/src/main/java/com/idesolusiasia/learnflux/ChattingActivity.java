package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.Toolbar;
import android.text.format.Time;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.TimePicker;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class ChattingActivity extends BaseActivity {

	boolean important = false;
	private static final String TAG  = "Chatting";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_chatting, null);
		parentLayout.addView(childLayout);

		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
		fab.hide();

		final EditText etMessage = (EditText) findViewById(R.id.etMessage);
		ImageView ivSend = (ImageView) findViewById(R.id.ivSend);
		final LinearLayout chatbubbleLayout = (LinearLayout) findViewById(R.id.chatbubbleLayout);

		final LinearLayout attachmentLayout = (LinearLayout) findViewById(R.id.attachmentLayout);
		ImageView ivAttachment = (ImageView) findViewById(R.id.ivAttachment);
		ivAttachment.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				attachmentLayout.setVisibility(View.VISIBLE);
				View view = getCurrentFocus();
				if (view != null) {
					InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
					imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
				}
			}
		});

		etMessage.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				attachmentLayout.setVisibility(View.GONE);
			}
		});

		final ImageView ivImportant = (ImageView) findViewById(R.id.ivImportant);
		ivImportant.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if (important){
					important=!important;
					Log.d(TAG, "onClick: "+important);
					ivImportant.setColorFilter(Color.parseColor("#000000"), PorterDuff.Mode.SRC_ATOP);

				}else{
					important=!important;
					ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
					Log.d(TAG, "onClick: "+important);
				}
			}
		});

		ivSend.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				View view = layoutInflater.inflate(R.layout.row_chatbubble, null);
				TextView tvTime = (TextView) view.findViewById(R.id.tvTime);
				Time time = new Time();
				time.setToNow();
				tvTime.setText("Today - "+time.hour +"."+time.minute);

				TextView tvMessage = (TextView) view.findViewById(R.id.tvMessage);
				tvMessage.setText(etMessage.getText());
				etMessage.setText("");

				LinearLayout chatbubbleParent = (LinearLayout) view.findViewById(R.id.chatbubbleParent);
				ImageView ivImportantStatus = (ImageView) view.findViewById(R.id.ivImpotantStatus);
				if (important){
					ivImportantStatus.setVisibility(View.VISIBLE);
					tvMessage.setTextColor(Color.parseColor("#FF0000"));
				}
				important=false;
				ivImportant.setColorFilter(Color.parseColor("#000000"), PorterDuff.Mode.SRC_ATOP);
				chatbubbleLayout.addView(view);
			}
		});



		Button addEvent = (Button) findViewById(R.id.btnAddEvent);
		addEvent.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				final Dialog dialog = new Dialog(ChattingActivity.this, android.R.style.Theme_Holo_Light_Dialog);
				//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
				dialog.setTitle("Create Event");

				dialog.setContentView(R.layout.dialog_add_event);
				final EditText etDate = (EditText) dialog.findViewById(R.id.add_event_date);
				final EditText etTime = (EditText) dialog.findViewById(R.id.add_event_time);
				final EditText etTitle = (EditText) dialog.findViewById(R.id.add_event_title);
				final SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
				final Calendar cal = Calendar.getInstance();
				etDate.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						Calendar newCalendar = Calendar.getInstance();
						DatePickerDialog datePickerDialog = new DatePickerDialog(ChattingActivity.this, new DatePickerDialog.OnDateSetListener() {

							public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
								Calendar newDate = Calendar.getInstance();
								newDate.set(year, monthOfYear, dayOfMonth);
								cal.set(year,monthOfYear,dayOfMonth);
								etDate.setText(dateFormatter.format(newDate.getTime()));
							}

						},newCalendar.get(Calendar.YEAR), newCalendar.get(Calendar.MONTH), newCalendar.get(Calendar.DAY_OF_MONTH));
						datePickerDialog.show();
					}
				});

				final SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm", Locale.US);
				etTime.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						Calendar newCalendar = Calendar.getInstance();
						//String birthdate = me.getBirthdate();
						TimePickerDialog timePickerDialog = new TimePickerDialog(ChattingActivity.this, new TimePickerDialog.OnTimeSetListener() {

							@Override
							public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
								Calendar newTime = Calendar.getInstance();
								newTime.set(0, 0, 0, hourOfDay, minute);
								cal.set(Calendar.HOUR_OF_DAY, hourOfDay);
								cal.set(Calendar.MINUTE, minute);
								etTime.setText(timeFormatter.format(newTime.getTime()));
							}
						}, newCalendar.get(Calendar.HOUR_OF_DAY), newCalendar.get(Calendar.MINUTE), true);
						timePickerDialog.show();
					}
				});

				Button btnAdd = (Button) dialog.findViewById(R.id.btnSubmitEvent);
				// if button is clicked, close the custom dialog
				btnAdd.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						View view = layoutInflater.inflate(R.layout.row_chatevent, null);
						TextView tvTime = (TextView) view.findViewById(R.id.tvTime);
						TextView tvEventTime = (TextView) view.findViewById(R.id.tvEventTime);
						TextView tvEventDate = (TextView) view.findViewById(R.id.tvEventDate);
						TextView tvEventTitle = (TextView) view.findViewById(R.id.tvEventTitle);
						ImageView ivAddToCalendar = (ImageView) view.findViewById(R.id.ivAddToCalendar);


						Time time = new Time();
						time.setToNow();
						tvTime.setText("Today - "+time.hour +"."+time.minute);

						tvEventDate.setText("Date : " + etDate.getText());
						tvEventTime.setText("Time : " + etTime.getText());
						tvEventTitle.setText(etTitle.getText());
						ivAddToCalendar.setOnClickListener(new View.OnClickListener() {
							@Override
							public void onClick(View v) {
								Log.d(TAG, "onClick: ");
								
								addtoCalendar(v.getContext(),
										etTitle.getText().toString(),
										cal);
							}
						});

						chatbubbleLayout.addView(view);
						dialog.dismiss();
					}
				});
				dialog.show();
			}
		});
	}

	public static void addtoCalendar(final Context context, String title, Calendar cal) {

		Intent intent = new Intent(Intent.ACTION_EDIT);
		intent.setType("vnd.android.cursor.item/event");
		intent.putExtra("beginTime", cal.getTimeInMillis());
		intent.putExtra("title", title);
		context.startActivity(intent);
	}
}
