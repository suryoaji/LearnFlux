package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.Toolbar;
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
import android.widget.ListView;
import android.widget.TimePicker;

import com.idesolusiasia.learnflux.adapter.AddPollAnswerAdapter;
import com.idesolusiasia.learnflux.adapter.ChatBubbleAdapter;
import com.idesolusiasia.learnflux.entity.ChatBubble;
import com.idesolusiasia.learnflux.entity.EventChatBubble;
import com.idesolusiasia.learnflux.entity.PlainChatBubble;
import com.idesolusiasia.learnflux.entity.PollChatBubble;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

public class ChattingActivity extends BaseActivity {

	boolean important = false;
	ChatBubbleAdapter adap;
	ListView listView;

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

		listView = (ListView) findViewById(R.id.listView);

		final EditText etMessage = (EditText) findViewById(R.id.etMessage);
		ImageView ivSend = (ImageView) findViewById(R.id.ivSend);


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


				Calendar cal = Calendar.getInstance();
				cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),cal.get(Calendar.HOUR_OF_DAY),cal.get(Calendar.MINUTE));
				PlainChatBubble bubble = new PlainChatBubble("plain", "me","","Agatha Cynthia",cal,
						important,etMessage.getText().toString());
				if (adap!=null){
					adap.add(bubble);
					adap.notifyDataSetChanged();
					listView.setSelection(adap.getCount() - 1);
				}
				etMessage.setText("");
			}
		});



		Button addEvent = (Button) findViewById(R.id.btnAddEvent);
		addEvent.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				addEventProcess();
			}
		});

		Button addPoll = (Button) findViewById(R.id.btnAddPoll);
		addPoll.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				addPollProcess();
			}
		});

		initChatBubble();
	}



	void initChatBubble(){
		ArrayList<ChatBubble> arr = new ArrayList<>();
		ChatBubble bubble;
		Calendar cal = Calendar.getInstance();
		cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),12,00);
		bubble = new PlainChatBubble("plain", "me","","Agatha Cynthia",cal,false,"You would not believe it!! \n Guess who I met just now?");
		arr.add(bubble);

		cal = Calendar.getInstance();
		cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),12,23);
		bubble = new PlainChatBubble("plain", "other","","Agatha Cynthia",cal,true,"Who? Your killer teacher??");
		arr.add(bubble);

		cal = Calendar.getInstance();
		cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),12,45);
		Calendar eventTime=Calendar.getInstance();
		eventTime.set(2016,4,2,12,0);
		bubble = new EventChatBubble("event", "me","","Agatha Cynthia",cal,"Parent Meeting", "Galaxy Hall", "", eventTime, eventTime);
		arr.add(bubble);

		cal = Calendar.getInstance();
		cal.set(2016,4,25,13,32);
		eventTime=Calendar.getInstance();
		eventTime.set(2016,5,22,13,0);
		cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),12,0);
		bubble = new EventChatBubble("event", "other","","Agatha Cynthia",cal,"Parent Meeting", "Galaxy Hall", "", eventTime, eventTime);
		arr.add(bubble);

		cal = Calendar.getInstance();
		cal.set(2016,4,25,13,32);
		cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),12,0);
		ArrayList<String> choices = new ArrayList<>();
		choices.add("Yes!");
		choices.add("No :(");
		choices.add("Maybe :|");
		bubble = new PollChatBubble("poll", "me","","Agatha Cynthia",cal,"",choices,"Would you like to go to this event next year?");
		arr.add(bubble);

		bubble = new PollChatBubble("poll", "other","","Agatha Cynthia",cal,"",choices,"Would you like to go to this event next year?");
		arr.add(bubble);

		adap = new ChatBubbleAdapter(ChattingActivity.this,arr);
		listView.setAdapter(adap);
		listView.setSelection(adap.getCount() - 1);

	}

	void addEventProcess(){
		final Dialog dialog = new Dialog(ChattingActivity.this);
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Create Event");

		dialog.setContentView(R.layout.dialog_add_event);
		final EditText etDate = (EditText) dialog.findViewById(R.id.add_event_date);
		final EditText etStart = (EditText) dialog.findViewById(R.id.add_event_time);
		final EditText etEnd = (EditText) dialog.findViewById(R.id.add_event_end);
		final EditText etTitle = (EditText) dialog.findViewById(R.id.add_event_title);
		final SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
		final Calendar calStart = Calendar.getInstance();
		final Calendar calEnd = Calendar.getInstance();
		etDate.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				DatePickerDialog datePickerDialog = new DatePickerDialog(ChattingActivity.this, new DatePickerDialog.OnDateSetListener() {

					public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
						calStart.set(year,monthOfYear,dayOfMonth);
						calEnd.set(year,monthOfYear,dayOfMonth);
						etDate.setText(dateFormatter.format(calStart.getTime()));
					}

				},calStart.get(Calendar.YEAR), calStart.get(Calendar.MONTH), calStart.get(Calendar.DAY_OF_MONTH));
				datePickerDialog.show();
			}
		});

		final SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm", Locale.US);
		etStart.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				//String birthdate = me.getBirthdate();
				TimePickerDialog timePickerDialog = new TimePickerDialog(ChattingActivity.this, new TimePickerDialog.OnTimeSetListener() {

					@Override
					public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
						calStart.set(Calendar.HOUR_OF_DAY, hourOfDay);
						calStart.set(Calendar.MINUTE, minute);
						etStart.setText(timeFormatter.format(calStart.getTime()));
					}
				}, calStart.get(Calendar.HOUR_OF_DAY), calStart.get(Calendar.MINUTE), true);
				timePickerDialog.show();
			}
		});

		etEnd.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				//String birthdate = me.getBirthdate();
				TimePickerDialog timePickerDialog = new TimePickerDialog(ChattingActivity.this, new TimePickerDialog.OnTimeSetListener() {

					@Override
					public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
						calEnd.set(Calendar.HOUR_OF_DAY, hourOfDay);
						calEnd.set(Calendar.MINUTE, minute);
						etEnd.setText(timeFormatter.format(calEnd.getTime()));
					}
				}, calStart.get(Calendar.HOUR_OF_DAY)+1, calStart.get(Calendar.MINUTE), true);
				timePickerDialog.show();
			}
		});

		Button btnAdd = (Button) dialog.findViewById(R.id.btnSubmitEvent);
		// if button is clicked, close the custom dialog
		btnAdd.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {

				Calendar calendar = Calendar.getInstance();
				calendar.set(calendar.get(Calendar.YEAR),calendar.get(Calendar.MONTH),calendar.get(Calendar.DAY_OF_MONTH),calendar.get(Calendar.HOUR_OF_DAY),calendar.get(Calendar.MINUTE));
				EventChatBubble bubble = new EventChatBubble("event", "me","","Agatha Cynthia",calendar,
						etTitle.getText().toString(), "Galaxy Hall", "", calStart, calEnd);
				adap.add(bubble);
				adap.notifyDataSetChanged();
				listView.setSelection(adap.getCount() - 1);
				dialog.dismiss();
			}
		});
		dialog.show();
	}

	void addPollProcess(){
		final Dialog dialog = new Dialog(ChattingActivity.this);
		dialog.setTitle("Create Poll");
		dialog.setContentView(R.layout.dialog_add_poll);

		final EditText etQuestion = (EditText) dialog.findViewById(R.id.add_poll_question);
		final ListView listView = (ListView) dialog.findViewById(R.id.listViewPoll);
		Button btnAddAnswer = (Button) dialog.findViewById(R.id.btnAddAnswer);
		Button btnSave = (Button) dialog.findViewById(R.id.btnSavePoll);
		ArrayList<String> arr = new ArrayList<>();
		arr.add(" ");
		final AddPollAnswerAdapter pollAnswerAdapter = new AddPollAnswerAdapter(getApplicationContext(),R.layout.dialog_add_poll,arr);
		listView.setAdapter(pollAnswerAdapter);
		adap.notifyDataSetChanged();

		btnAddAnswer.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				pollAnswerAdapter.add(" ");
				pollAnswerAdapter.notifyDataSetChanged();
			}
		});

		btnSave.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Calendar calendar = Calendar.getInstance();
				calendar.set(calendar.get(Calendar.YEAR),calendar.get(Calendar.MONTH),calendar.get(Calendar.DAY_OF_MONTH),calendar.get(Calendar.HOUR_OF_DAY),calendar.get(Calendar.MINUTE));

				PollChatBubble pollChatBubble = new PollChatBubble("poll","me","","Agatha Cynthia",
						calendar, "", pollAnswerAdapter.getList(),etQuestion.getText().toString());

				adap.add(pollChatBubble);
				adap.notifyDataSetChanged();
				listView.setSelection(adap.getCount() - 1);
				dialog.dismiss();

			}
		});


		dialog.show();

	}



}
