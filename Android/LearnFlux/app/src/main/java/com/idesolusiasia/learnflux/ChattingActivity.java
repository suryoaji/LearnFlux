package com.idesolusiasia.learnflux;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.google.gson.Gson;
import com.idesolusiasia.learnflux.adapter.AddPollAnswerAdapter;
import com.idesolusiasia.learnflux.adapter.ChatBubbleAdapter;
import com.idesolusiasia.learnflux.adapter.PeopleAdapter;
import com.idesolusiasia.learnflux.db.DatabaseFunction;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class ChattingActivity extends BaseActivity {

	boolean important = false;
	ChatBubbleAdapter adap;
	ListView listView;
	String idThread = "";
	Gson gson= new Gson();
	boolean firstTime = true;
	int positionLast =0;
	ImageView ivScrollDown;
	boolean pause=false;
	Thread thread;



	private int mInterval = 5000; // 5 seconds by default, can be changed later
	private Handler mHandler;
	LinearLayout attachmentLayout;
	ImageView ivAttachment;

	private static final String TAG  = "Chatting";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_base);
		super.onCreateDrawer(savedInstanceState);

		idThread = getIntent().getStringExtra("idThread");

		Log.i(TAG, "onCreate: "+ getIntent().getStringExtra("idThread") );

		FrameLayout parentLayout = (FrameLayout) findViewById(R.id.activity_layout);
		final LayoutInflater layoutInflater = LayoutInflater.from(this);
		View childLayout = layoutInflater.inflate(
				R.layout.activity_chatting, null);
		parentLayout.addView(childLayout);

		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		toolbar.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Toast.makeText(getApplicationContext(), "Toolbar title clicked", Toast.LENGTH_SHORT).show();
				showParticipant();
			}
		});

		ivScrollDown = (ImageView) findViewById(R.id.ivScrollDown);
		ivScrollDown.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if (adap!=null){
					listView.setSelection(adap.getCount() - 1);
					listView.refreshDrawableState();
				}
			}
		});

		listView = (ListView) findViewById(R.id.listView);
		listView.setOnScrollListener(new AbsListView.OnScrollListener() {
			@Override
			public void onScrollStateChanged(AbsListView absListView, int i) {

			}

			@Override
			public void onScroll(AbsListView absListView, int firstVisible, int visibleItemCount, int i2) {
				positionLast=firstVisible+visibleItemCount;
				if (adap!=null){
					if (positionLast<(adap.getCount()-3)){
						ivScrollDown.setVisibility(View.VISIBLE);
					}else {
						ivScrollDown.setVisibility(View.GONE);
					}
				}

			}
		});


		final EditText etMessage = (EditText) findViewById(R.id.etMessage);
		ImageView ivSend = (ImageView) findViewById(R.id.ivSend);


		attachmentLayout = (LinearLayout) findViewById(R.id.attachmentLayout);
		ivAttachment = (ImageView) findViewById(R.id.ivAttachment);
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

				if (!TextUtils.isEmpty(etMessage.getText())){
					Engine.sendMessage(ChattingActivity.this, idThread, etMessage.getText().toString(),
							null, null,
							new RequestTemplate.ServiceCallback() {
						@Override
						public void execute(JSONObject obj) {
							refreshDB();
							etMessage.setText("");
						}
					});
				}

				/*Calendar cal = Calendar.getInstance();
				cal.set(cal.get(Calendar.YEAR),cal.get(Calendar.MONTH),cal.get(Calendar.DAY_OF_MONTH),cal.get(Calendar.HOUR_OF_DAY),cal.get(Calendar.MINUTE));
				PlainChatBubble bubble = new PlainChatBubble("plain", "me","","Agatha Cynthia",cal,
						important,etMessage.getText().toString());
				if (adap!=null){
					adap.add(bubble);
					adap.notifyDataSetChanged();
					listView.setSelection(adap.getCount() - 1);
				}
				etMessage.setText("");*/
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
		refreshDB();
		etMessage.clearFocus();


		mHandler = new Handler();
		startRepeatingTask();
	}

	Runnable r = new Runnable() {
		@Override
		public void run() {
			try {
				refreshDB();
			} finally {
				// 100% guarantee that this always happens, even if
				// your update method throws an exception
				mHandler.postDelayed(r, mInterval);
			}
		}
	};

	void startRepeatingTask() {
		r.run();
	}

	void stopRepeatingTask() {
		mHandler.removeCallbacks(r);
	}

	void refreshDB(){
		Engine.getThreads(getApplicationContext(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				initChatBubble();
			}
		});
	}

	void initChatBubble(){
		//read from local database, compare with now shown adapter
		thread = DatabaseFunction.getThreadDetail(getApplicationContext(),idThread);
		if (thread.getParticipants().size()==2){
			attachmentLayout.setVisibility(View.GONE);
			ivAttachment.setVisibility(View.GONE);
		}

		if (thread.getGroup()==null){
			attachmentLayout.setVisibility(View.GONE);
			ivAttachment.setVisibility(View.GONE);
		}

		if (adap==null){
			adap=new ChatBubbleAdapter(ChattingActivity.this,thread.getMessages());
			listView.setAdapter(adap);
			listView.setSelection(adap.getCount() - 1);
			listView.refreshDrawableState();
		}else{
			boolean scroll = false;
			boolean in = false;
			if (positionLast>=(adap.getCount()-3)){
				scroll=true;
			}
			for (int i=adap.getCount();i<thread.getMessages().size();i++){
				adap.add(thread.getMessages().get(i));
				in=true;
			}
			adap.notifyDataSetChanged();
			if (scroll&&in){
				listView.setSelection(adap.getCount() - 1);
				listView.refreshDrawableState();
			}

		}
	}

	void showParticipant(){
		AlertDialog.Builder builderSingle = new AlertDialog.Builder(ChattingActivity.this);
		builderSingle.setIcon(R.drawable.icon_groups);
		builderSingle.setTitle("Participants");

		final PeopleAdapter arrayAdapter = new PeopleAdapter(
				ChattingActivity.this,
				thread.getParticipants());

		builderSingle.setPositiveButton(
				"OK",
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					}
				});

		builderSingle.setAdapter(
				arrayAdapter,null);
		builderSingle.show();
	}

	void addEventProcess(){
		final Dialog dialog = new Dialog(ChattingActivity.this);
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Create Event");

		dialog.setContentView(R.layout.dialog_add_event);
		final EditText etDate = (EditText) dialog.findViewById(R.id.add_event_date);
		final EditText etStart = (EditText) dialog.findViewById(R.id.add_event_time);
		/*final EditText etEnd = (EditText) dialog.findViewById(R.id.add_event_end);*/
		final EditText etTitle = (EditText) dialog.findViewById(R.id.add_event_title);
		final EditText etDesc = (EditText) dialog.findViewById(R.id.add_event_description);
		final EditText etLocation = (EditText) dialog.findViewById(R.id.add_event_location);
		final SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
		final Calendar calStart = Calendar.getInstance();
		/*final Calendar calEnd = Calendar.getInstance();*/
		etDate.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				DatePickerDialog datePickerDialog = new DatePickerDialog(ChattingActivity.this, new DatePickerDialog.OnDateSetListener() {

					public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
						calStart.set(year,monthOfYear,dayOfMonth);
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

		/*etEnd.setOnClickListener(new View.OnClickListener() {
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
		});*/

		Button btnAdd = (Button) dialog.findViewById(R.id.btnSubmitEvent);
		// if button is clicked, close the custom dialog
		btnAdd.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {

				/*Calendar calendar = Calendar.getInstance();
				calendar.set(calendar.get(Calendar.YEAR),calendar.get(Calendar.MONTH),calendar.get(Calendar.DAY_OF_MONTH),calendar.get(Calendar.HOUR_OF_DAY),calendar.get(Calendar.MINUTE));*/

				/*Event bubble = new Event(etDesc.getText(),);
				adap.add(bubble);
				adap.notifyDataSetChanged();
				listView.setSelection(adap.getCount() - 1);*/
				Engine.createEvent(v.getContext(), true, etTitle.getText().toString(),
						etDesc.getText().toString(), etLocation.getText().toString(), calStart.getTimeInMillis() / 1000, null,
						thread.getGroup().getId(), thread.getGroup().getType(), new RequestTemplate.ServiceCallback() {
							@Override
							public void execute(JSONObject obj) {
								refreshDB();
								dialog.dismiss();
							}
						});
			}
		});
		dialog.show();
	}

	void addPollProcess(){
		final Dialog dialog = new Dialog(ChattingActivity.this);
		dialog.setTitle("Create Poll");
		dialog.setContentView(R.layout.dialog_add_poll);
		final EditText etTitle = (EditText) dialog.findViewById(R.id.add_poll_title);
		final EditText etQuestion = (EditText) dialog.findViewById(R.id.add_poll_question);
		final ListView listView = (ListView) dialog.findViewById(R.id.listViewPoll);
		ImageView btnAddAnswer = (ImageView) dialog.findViewById(R.id.btnAddAnswer);
		Button btnSave = (Button) dialog.findViewById(R.id.btnSavePoll);
		ArrayList<String> arr = new ArrayList<>();
		arr.add(" ");
		final AddPollAnswerAdapter pollAnswerAdapter = new AddPollAnswerAdapter(ChattingActivity.this,R.layout.dialog_add_poll,arr);
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
				List<String> options = pollAnswerAdapter.getList();
				try {
					JSONArray opt = new JSONArray();
					for (int i=0;i<options.size();i++){
						JSONObject obj = new JSONObject();
						obj.put("name",options.get(i));
						obj.put("value",String.valueOf(i));
						opt.put(obj);
					}

					Engine.createPoll(ChattingActivity.this, etTitle.getText().toString(),
							etQuestion.getText().toString(), opt, idThread, new RequestTemplate.ServiceCallback() {
								@Override
								public void execute(JSONObject obj) {
									refreshDB();
									dialog.dismiss();
								}
							});
				} catch (JSONException e) {
					e.printStackTrace();
				}


			}
		});
		dialog.show();
	}

	@Override
	protected void onPause() {
		super.onPause();
		stopRepeatingTask();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.home, menu);
		return true;
	}
}
