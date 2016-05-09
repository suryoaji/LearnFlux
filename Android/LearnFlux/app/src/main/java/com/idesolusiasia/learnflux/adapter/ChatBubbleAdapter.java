package com.idesolusiasia.learnflux.adapter;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.ChatBubble;
import com.idesolusiasia.learnflux.entity.EventChatBubble;
import com.idesolusiasia.learnflux.entity.PlainChatBubble;
import com.idesolusiasia.learnflux.entity.PollChatBubble;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class ChatBubbleAdapter extends ArrayAdapter<ChatBubble>{

	List<ChatBubble> chatBubbles=null;
	int page;

	public ChatBubbleAdapter(Context context, List<ChatBubble> objects) {
		super(context, R.layout.row_plainbubble_other, objects);
		this.chatBubbles=objects;
		page=2;
	}

	public ChatBubble getItem(int i){
		if (chatBubbles!=null && chatBubbles.size()>0 && i>=0){
			return chatBubbles.get(i);
		}else return null;
	}
	public View getView(int position, View conView, ViewGroup parent){
		//Log.i("Response","masuk getView");
		View row=conView;
		if(row==null){

		}

		final ChatBubble e = chatBubbles.get(position);
		if(e != null){
			SimpleDateFormat timeStampFormatter = new SimpleDateFormat("dd MMM yyyy HH:mm", Locale.US);
			LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

			if (e.getType().equalsIgnoreCase("plain")){
				if (e.getSender().equalsIgnoreCase("me")){
					row = inflater.inflate(R.layout.row_plainbubble_me,null);

					ViewHolderPlainMe viewHolder = new ViewHolderPlainMe();
					viewHolder.message = (TextView) row.findViewById(R.id.tvMessage);
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
					viewHolder.ivImportant = (ImageView) row.findViewById(R.id.ivImportant);

					if (((PlainChatBubble)e).isImportant()){
						viewHolder.ivImportant.setVisibility(View.VISIBLE);
						viewHolder.ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
						viewHolder.message.setTextColor(Color.parseColor("#FF0000"));
					}else {
						viewHolder.ivImportant.setVisibility(View.GONE);
					}

					viewHolder.message.setText(((PlainChatBubble) e).getMessage());
					viewHolder.timestamp.setText(timeStampFormatter.format(((PlainChatBubble) e).getChatCalendar().getTime()));

				}else{
					row = inflater.inflate(R.layout.row_plainbubble_other,null);

					ViewHolderPlainOther viewHolder = new ViewHolderPlainOther();
					viewHolder.message = (TextView) row.findViewById(R.id.tvMessage);
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
					viewHolder.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
					viewHolder.name = (TextView) row.findViewById(R.id.tvName);
					viewHolder.ivImportant = (ImageView) row.findViewById(R.id.ivImportant);

					if (((PlainChatBubble)e).isImportant()){
						viewHolder.ivImportant.setVisibility(View.VISIBLE);
						viewHolder.ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
						viewHolder.message.setTextColor(Color.parseColor("#FF0000"));
					}else {
						viewHolder.ivImportant.setVisibility(View.GONE);
					}
					viewHolder.message.setText(((PlainChatBubble) e).getMessage());
					viewHolder.timestamp.setText(timeStampFormatter.format(((PlainChatBubble) e).getChatCalendar().getTime()));
					viewHolder.ivUser.setImageUrl(((PlainChatBubble) e).getUserPhoto(),
							VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
					viewHolder.ivUser.setDefaultImageResId(R.drawable.me);
					viewHolder.name.setText(((PlainChatBubble) e).getUserName());
				}
			}else if (e.getType().equalsIgnoreCase("event")){
				SimpleDateFormat eventDateFormatter = new SimpleDateFormat("dd MMM yyyy HH:mm", Locale.US);
				SimpleDateFormat eventEndFormatter = new SimpleDateFormat("HH:mm", Locale.US);
				if (e.getSender().equalsIgnoreCase("me")){
					row = inflater.inflate(R.layout.row_chatevent_me,null);

					ViewHolderEventMe viewHolder = new ViewHolderEventMe();
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
					viewHolder.title = (TextView) row.findViewById(R.id.tvEventTitle);
					viewHolder.eventTime = (TextView) row.findViewById(R.id.tvEventDate);
					viewHolder.location = (TextView) row.findViewById(R.id.tvEventLocation);
					viewHolder.bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
					viewHolder.btnAddToCalendar = (ImageView) row.findViewById(R.id.ivAddToCalendar);

					viewHolder.timestamp.setText(timeStampFormatter.format(((EventChatBubble) e).getChatCalendar().getTime()));
					viewHolder.title.setText(((EventChatBubble)e).getTitle());
					viewHolder.eventTime.setText(eventDateFormatter.format(((EventChatBubble)e).getTimeStart().getTime())+"-"+
							eventEndFormatter.format(((EventChatBubble)e).getTimeEnd().getTime()));
					viewHolder.location.setText(((EventChatBubble)e).getLocation());
					viewHolder.btnAddToCalendar.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							addtoCalendar(getContext(),
									((EventChatBubble) e).getTitle().toString(),
									((EventChatBubble) e).getTimeStart(),
									((EventChatBubble) e).getTimeEnd());
						}
					});
					viewHolder.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							eventDetails((EventChatBubble) e);
						}
					});
				}else{
					row = inflater.inflate(R.layout.row_chatevent_other,null);

					ViewHolderEventOther viewHolder = new ViewHolderEventOther();
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
					viewHolder.title = (TextView) row.findViewById(R.id.tvEventTitle);
					viewHolder.eventTime = (TextView) row.findViewById(R.id.tvEventDate);
					viewHolder.location = (TextView) row.findViewById(R.id.tvEventLocation);
					viewHolder.bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
					viewHolder.btnAddToCalendar = (ImageView) row.findViewById(R.id.ivAddToCalendar);
					viewHolder.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
					viewHolder.name = (TextView) row.findViewById(R.id.tvName);

					viewHolder.ivUser.setImageUrl(((EventChatBubble) e).getUserPhoto(),
							VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
					viewHolder.name.setText(((EventChatBubble) e).getUserName());
					viewHolder.eventTime.setText(eventDateFormatter.format(((EventChatBubble)e).getTimeStart().getTime())+"-"+
							eventEndFormatter.format(((EventChatBubble)e).getTimeEnd().getTime()));
					viewHolder.title.setText(((EventChatBubble)e).getTitle());
					viewHolder.location.setText(((EventChatBubble)e).getLocation());
					viewHolder.ivUser.setDefaultImageResId(R.drawable.me);
					viewHolder.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							eventDetails((EventChatBubble) e);
						}
					});
					viewHolder.btnAddToCalendar.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							addtoCalendar(getContext(),
									((EventChatBubble) e).getTitle().toString(),
									((EventChatBubble) e).getTimeStart(),
									((EventChatBubble) e).getTimeEnd());
						}
					});
				}
			}
			else if (e.getType().equalsIgnoreCase("poll")){
				if (e.getSender().equalsIgnoreCase("me")){
					row = inflater.inflate(R.layout.row_chatpoll_me,null);

					ViewHolderPollMe viewHolder = new ViewHolderPollMe();
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
					viewHolder.bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
					viewHolder.question = (TextView) row.findViewById(R.id.tvPollQuestion);

					viewHolder.question.setText(((PollChatBubble) e).getQuestion());
					viewHolder.timestamp.setText(timeStampFormatter.format(((PollChatBubble) e).getChatCalendar().getTime()));
					viewHolder.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							//do something
							pollDetails((PollChatBubble) e);
						}
					});
				}else{
					row = inflater.inflate(R.layout.row_chatpoll_other,null);

					ViewHolderPollOther viewHolder = new ViewHolderPollOther();
					viewHolder.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
					viewHolder.name = (TextView) row.findViewById(R.id.tvName);
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
					viewHolder.bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
					viewHolder.question = (TextView) row.findViewById(R.id.tvPollQuestion);

					viewHolder.ivUser.setImageUrl(((PollChatBubble) e).getUserPhoto(),
							VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
					viewHolder.name.setText(((PollChatBubble) e).getUserName());
					viewHolder.ivUser.setDefaultImageResId(R.drawable.me);
					viewHolder.question.setText(((PollChatBubble) e).getQuestion());
					viewHolder.timestamp.setText(timeStampFormatter.format(((PollChatBubble) e).getChatCalendar().getTime()));
					viewHolder.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							//do something
							pollDetails((PollChatBubble) e);
						}
					});
				}
			}
		}

		return row;
	}

	public static void addtoCalendar(final Context context, String title, Calendar calStart, Calendar calEnd) {

		Intent intent = new Intent(Intent.ACTION_EDIT);
		intent.setType("vnd.android.cursor.item/event");
		intent.putExtra("beginTime", calStart.getTimeInMillis());
		intent.putExtra("endTime", calEnd.getTimeInMillis());
		intent.putExtra("title", title);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		context.startActivity(intent);
	}

	private class ViewHolderPlainOther{
		NetworkImageView ivUser;
		ImageView ivImportant;
		TextView name, message, timestamp;
	}
	private class ViewHolderPlainMe{
		TextView message, timestamp;
		ImageView ivImportant;
	}
	private class ViewHolderEventOther{
		NetworkImageView ivUser;
		ImageView btnAddToCalendar;
		LinearLayout bubbleLayout;
		TextView name, title, timestamp, eventTime, location;
	}
	private class ViewHolderEventMe{
		ImageView btnAddToCalendar;
		LinearLayout bubbleLayout;
		TextView title, timestamp, eventTime, location;
	}
	private class ViewHolderPollOther{
		NetworkImageView ivUser;
		LinearLayout bubbleLayout;
		TextView name, question, timestamp;
	}
	private class ViewHolderPollMe{
		LinearLayout bubbleLayout;
		TextView question, timestamp;
	}

	void eventDetails(final EventChatBubble e){
		Log.i("event", "eventDetails: clicked");
		Log.i("event", "eventDetails: "+e.getAcceptanceStatus());

		final Dialog dialog = new Dialog(getContext());
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Event Detail");

		dialog.setContentView(R.layout.dialog_event_detail);
		final TextView tvTitle = (TextView) dialog.findViewById(R.id.tvTitle);
		final TextView tvDate = (TextView) dialog.findViewById(R.id.tvDate);
		final TextView tvTime = (TextView) dialog.findViewById(R.id.tvTime);
		final TextView tvLocation = (TextView) dialog.findViewById(R.id.tvLocation);
		final SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, dd MMM yyyy", Locale.US);
		final SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm", Locale.US);
		RadioGroup rgEvent = (RadioGroup) dialog.findViewById(R.id.rgEvent);
		Button btnOK = (Button) dialog.findViewById(R.id.btnOK);
		Button btnChatRoom = (Button) dialog.findViewById(R.id.btnChatRoom);


		tvTitle.setText(e.getTitle());
		tvDate.setText(dateFormatter.format(e.getTimeStart().getTime()));
		tvTime.setText(timeFormatter.format(e.getTimeStart().getTime()) + " - " + timeFormatter.format(e.getTimeEnd().getTime()));
		tvLocation.setText("at " + e.getLocation());

		if (e.getAcceptanceStatus().equalsIgnoreCase("attend")){
			((RadioButton)dialog.findViewById(R.id.rbAttend)).setChecked(true);
		}else if (e.getAcceptanceStatus().equalsIgnoreCase("notAttend")){
			((RadioButton)dialog.findViewById(R.id.rbNotAttend)).setChecked(true);
		}

		rgEvent.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				if (checkedId==R.id.rbAttend){
					e.setAcceptanceStatus("attend");
				}else{
					e.setAcceptanceStatus("notAttend");
				}

				Toast.makeText(getContext(), "Thanks for your response", Toast.LENGTH_SHORT).show();
			}
		});

		btnOK.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		btnChatRoom.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Toast.makeText(getContext(), "openChatroom", Toast.LENGTH_SHORT).show();
					/*Intent i = new Intent(getContext(), EventChat.class);
					getContext().startActivity(i);*/
			}
		});

		dialog.show();
	}

	void pollDetails(final PollChatBubble p){

		final Dialog dialog = new Dialog(getContext());
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Poll Detail");

		dialog.setContentView(R.layout.dialog_poll_detail);
		final TextView tvQuestion = (TextView) dialog.findViewById(R.id.tvQuestion);
		RadioGroup rgPoll = (RadioGroup) dialog.findViewById(R.id.rgPoll);
		Button btnOK = (Button) dialog.findViewById(R.id.btnOK);
		Button btnChatRoom = (Button) dialog.findViewById(R.id.btnChatRoom);
		ArrayList<RadioButton> arrRB = new ArrayList<>();

		for (int i=0;i<p.getChoices().size();i++){
			RadioButton rb = new RadioButton(dialog.getContext());
			if (p.getAnswer().equalsIgnoreCase(p.getChoices().get(i))){
				rb.setChecked(true);
			}
			rb.setText(p.getChoices().get(i));
			//arrRB.add(rb);
			rgPoll.addView(rb);
		}

		tvQuestion.setText(p.getQuestion());

		rgPoll.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				p.setAnswer(((RadioButton) group.findViewById(checkedId)).getText().toString());
				Toast.makeText(getContext(), "Thanks for your response", Toast.LENGTH_SHORT).show();
			}
		});

		btnOK.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		btnChatRoom.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Toast.makeText(getContext(), "openChatroom", Toast.LENGTH_SHORT).show();
					/*Intent i = new Intent(getContext(), PollChat.class);
					getContext().startActivity(i);*/
			}
		});

		dialog.show();
	}
}