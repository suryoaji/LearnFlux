package com.idesolusiasia.learnflux.adapter;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.provider.CalendarContract;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.ChattingActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.Message;
import com.idesolusiasia.learnflux.entity.MessageEvent;
import com.idesolusiasia.learnflux.entity.MessagePoll;
import com.idesolusiasia.learnflux.entity.Poll;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class ChatBubbleAdapter extends ArrayAdapter<Message> implements Filterable{

	public List<Message> chatBubbles=null;
	int meID = User.getUser().getID();
	public static final int TYPE_PLAIN_ME = 0;
	public static final int TYPE_PLAIN_OTHER = 1;
	public static final int TYPE_EVENT_ME = 2;
	public static final int TYPE_EVENT_OTHER = 3;
	public static final int TYPE_POLL_ME = 4;
	public static final int TYPE_POLL_OTHER = 5;

	public ChatBubbleAdapter(Context context, List<Message> objects) {
		super(context, R.layout.row_plainbubble_other, objects);
		this.chatBubbles=objects;
	}

	@Override
	public int getViewTypeCount() {
		return 6;
	}

	@Override
	public int getItemViewType(int position) {
		String type = chatBubbles.get(position).getType();
		boolean me = (chatBubbles.get(position).getSender().getId()==meID);
		if (chatBubbles.get(position) instanceof MessageEvent){
			if (me){
				return TYPE_EVENT_ME;
			}else{
				return TYPE_EVENT_OTHER;
			}
		}else if (chatBubbles.get(position) instanceof MessagePoll){
			if (me){
				return TYPE_POLL_ME;
			}else{
				return TYPE_POLL_OTHER;
			}
		}else{
			if (me){
				return TYPE_PLAIN_ME;
			}else{
				return TYPE_PLAIN_OTHER;
			}
		}

		/*if (me){
			return TYPE_PLAIN_ME;
		}else{
			return TYPE_PLAIN_OTHER;
		}*/
	}

	public Message getItem(int i){
		if (chatBubbles!=null && chatBubbles.size()>0 && i>=0){
			return chatBubbles.get(i);
		}else return null;
	}
	public View getView(int position, View conView, ViewGroup parent){
		View row=conView;


		final Message e = chatBubbles.get(position);
		if (e.getSender().getId()==7){
			e.getSender().setFirstName("Alpha - Tester");
		}else if (e.getSender().getId()==8){
			e.getSender().setFirstName("Beta - Tester2");
		}
		else if (e.getSender().getId()==6){
			e.getSender().setFirstName("Admin");
		}

		if (e!=null){
			LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			switch (getItemViewType(position)) {
				case TYPE_PLAIN_ME:
					ViewHolderPlainMe viewHolderPlainMe;
					if (row==null){
						row = inflater.inflate(R.layout.row_plainbubble_me, null);
						viewHolderPlainMe = new ViewHolderPlainMe();
						viewHolderPlainMe.message = (TextView) row.findViewById(R.id.tvMessage);
						viewHolderPlainMe.timestamp = (TextView) row.findViewById(R.id.tvTime);
						viewHolderPlainMe.ivImportant = (ImageView) row.findViewById(R.id.ivImportant);
						row.setTag(viewHolderPlainMe);
					}else{
						viewHolderPlainMe=(ViewHolderPlainMe) row.getTag();
					}

					/*if (((PlainChatBubble) e).isImportant()) {
					viewHolder.ivImportant.setVisibility(View.VISIBLE);
					viewHolder.ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
					viewHolder.message.setTextColor(Color.parseColor("#FF0000"));
					} else {
						viewHolder.ivImportant.setVisibility(View.GONE);
					}*/

					viewHolderPlainMe.message.setText(e.getBody());
					viewHolderPlainMe.timestamp.setText(e.getCreatedAtDate());
					break;
				case TYPE_PLAIN_OTHER:
					ViewHolderPlainOther viewHolderPlainOther;

					if (row==null){
						row = inflater.inflate(R.layout.row_plainbubble_other, null);
						viewHolderPlainOther=new ViewHolderPlainOther();
						viewHolderPlainOther.message = (TextView) row.findViewById(R.id.tvMessage);
						viewHolderPlainOther.timestamp = (TextView) row.findViewById(R.id.tvTime);
						viewHolderPlainOther.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
						viewHolderPlainOther.name = (TextView) row.findViewById(R.id.tvName);
						viewHolderPlainOther.ivImportant = (ImageView) row.findViewById(R.id.ivImportant);
						row.setTag(viewHolderPlainOther);
					}else{
						viewHolderPlainOther=(ViewHolderPlainOther) row.getTag();
					}
					/*if (((PlainChatBubble) e).isImportant()) {
					viewHolder.ivImportant.setVisibility(View.VISIBLE);
					viewHolder.ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
					viewHolder.message.setTextColor(Color.parseColor("#FF0000"));
					} else {
						viewHolder.ivImportant.setVisibility(View.GONE);
					}*/

					viewHolderPlainOther.ivImportant.setVisibility(View.GONE);
					viewHolderPlainOther.message.setText(e.getBody());
					viewHolderPlainOther.timestamp.setText(e.getCreatedAtDate());
					viewHolderPlainOther.ivUser.setImageUrl(e.getSender().getPhoto(),
							VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
					viewHolderPlainOther.ivUser.setDefaultImageResId(R.drawable.me);
					viewHolderPlainOther.name.setText(e.getSender().getFirstName());
					break;
				case TYPE_EVENT_ME:
					ViewHolderEventMe viewHolderEventMe;
					if (row==null){
						row = inflater.inflate(R.layout.row_chatevent_me, null);
						viewHolderEventMe = new ViewHolderEventMe();
						viewHolderEventMe.eventDate = (TextView) row.findViewById(R.id.tvEventDate);
						viewHolderEventMe.eventLocation = (TextView) row.findViewById(R.id.tvEventLocation);
						viewHolderEventMe.eventTitle = (TextView) row.findViewById(R.id.tvEventTitle);
						viewHolderEventMe.timestamp = (TextView) row.findViewById(R.id.tvTime);
						viewHolderEventMe.ivAddToCalendar = (ImageView) row.findViewById(R.id.ivAddToCalendar);
						viewHolderEventMe.bubbleLayout= (LinearLayout) row.findViewById(R.id.bubbleLayout);
						row.setTag(viewHolderEventMe);
					}else {
						viewHolderEventMe = (ViewHolderEventMe) row.getTag();
					}
					final Event eventMe=((MessageEvent)e).getEvent();
					viewHolderEventMe.eventDate.setText(eventMe.getTimestampDate());
					viewHolderEventMe.eventLocation.setText("at " + eventMe.getLocation());
					viewHolderEventMe.eventTitle.setText(eventMe.getTitle());
					viewHolderEventMe.timestamp.setText(e.getCreatedAtDate());
					viewHolderEventMe.ivAddToCalendar.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View view) {
							addEventToCalendar(eventMe,view.getContext());
						}
					});

					viewHolderEventMe.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(final View view) {
							Engine.getEventById(view.getContext(), eventMe.getId(), new RequestTemplate.ServiceCallback() {
								@Override
								public void execute(JSONObject obj) {
									try {
										Event e = Converter.convertEvent(obj.getJSONObject("data"));
										showEventDetails(e,view.getContext());
									} catch (JSONException e1) {
										e1.printStackTrace();
									}

								}
							});
						}
					});
					break;
				case TYPE_EVENT_OTHER:
					ViewHolderEventOther viewHolderEventOther;
					if (row==null){
						row = inflater.inflate(R.layout.row_chatevent_other, null);
						viewHolderEventOther = new ViewHolderEventOther();
						viewHolderEventOther.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
						viewHolderEventOther.name = (TextView) row.findViewById(R.id.tvName);
						viewHolderEventOther.eventDate = (TextView) row.findViewById(R.id.tvEventDate);
						viewHolderEventOther.eventLocation = (TextView) row.findViewById(R.id.tvEventLocation);
						viewHolderEventOther.eventTitle = (TextView) row.findViewById(R.id.tvEventTitle);
						viewHolderEventOther.timestamp = (TextView) row.findViewById(R.id.tvTime);
						viewHolderEventOther.ivAddToCalendar = (ImageView) row.findViewById(R.id.ivAddToCalendar);
						viewHolderEventOther.bubbleLayout= (LinearLayout) row.findViewById(R.id.bubbleLayout);
						row.setTag(viewHolderEventOther);
					}else {
						viewHolderEventOther = (ViewHolderEventOther) row.getTag();
					}
					final Event eventOther=((MessageEvent)e).getEvent();
					viewHolderEventOther.eventDate.setText(eventOther.getTimestampDate());
					viewHolderEventOther.eventLocation.setText("at " + eventOther.getLocation());
					viewHolderEventOther.eventTitle.setText(eventOther.getTitle());
					viewHolderEventOther.timestamp.setText(e.getCreatedAtDate());
					viewHolderEventOther.ivUser.setImageUrl(e.getSender().getPhoto(),
							VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
					viewHolderEventOther.ivUser.setDefaultImageResId(R.drawable.me);
					viewHolderEventOther.name.setText(e.getSender().getFirstName());
					viewHolderEventOther.ivAddToCalendar.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View view) {
							addEventToCalendar(eventOther,view.getContext());
						}
					});
					viewHolderEventOther.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(final View view) {
							Engine.getEventById(view.getContext(), eventOther.getId(), new RequestTemplate.ServiceCallback() {
								@Override
								public void execute(JSONObject obj) {
									try {
										Event e = Converter.convertEvent(obj.getJSONObject("data"));
										showEventDetails(e,view.getContext());
									} catch (JSONException e1) {
										e1.printStackTrace();
									}
								}
							});
						}
					});
					break;
				case TYPE_POLL_ME:
					ViewHolderPollMe viewHolderPollMe;
					if (row==null){
						row = inflater.inflate(R.layout.row_chatpoll_me, null);
						viewHolderPollMe = new ViewHolderPollMe();
						viewHolderPollMe.pollTitle = (TextView) row.findViewById(R.id.tvPollTitle);
						viewHolderPollMe.timestamp = (TextView) row.findViewById(R.id.tvTime);
						viewHolderPollMe.bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
						row.setTag(viewHolderPollMe);
					}else{
						viewHolderPollMe=(ViewHolderPollMe) row.getTag();
					}
					final Poll pollMe=((MessagePoll)e).getPoll();
					viewHolderPollMe.pollTitle.setText(((MessagePoll)e).getPoll().getTitle());
					viewHolderPollMe.timestamp.setText(e.getCreatedAtDate());
					viewHolderPollMe.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(final View view) {
							Engine.getPollById(view.getContext(), pollMe.getId(), new RequestTemplate.ServiceCallback() {
								@Override
								public void execute(JSONObject obj) {
									try {
										Poll p = Converter.convertPoll(obj.getJSONObject("data"));
										showPollDetails(p,view.getContext());
									} catch (JSONException e1) {
										e1.printStackTrace();
									}
								}
							});
						}
					});
					break;
				case TYPE_POLL_OTHER:
					ViewHolderPollOther viewHolderPollOther;

					if (row==null){
						row = inflater.inflate(R.layout.row_chatpoll_other, null);
						viewHolderPollOther=new ViewHolderPollOther();
						viewHolderPollOther.pollTitle = (TextView) row.findViewById(R.id.tvPollTitle);
						viewHolderPollOther.timestamp = (TextView) row.findViewById(R.id.tvTime);
						viewHolderPollOther.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
						viewHolderPollOther.name = (TextView) row.findViewById(R.id.tvName);
						viewHolderPollOther.bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
						row.setTag(viewHolderPollOther);
					}else{
						viewHolderPollOther=(ViewHolderPollOther) row.getTag();
					}
					final Poll pollOther=((MessagePoll)e).getPoll();

					viewHolderPollOther.pollTitle.setText(((MessagePoll)e).getPoll().getTitle());
					viewHolderPollOther.timestamp.setText(e.getCreatedAtDate());
					viewHolderPollOther.ivUser.setImageUrl(e.getSender().getPhoto(),
							VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
					viewHolderPollOther.ivUser.setDefaultImageResId(R.drawable.me);
					viewHolderPollOther.name.setText(e.getSender().getFirstName());
					viewHolderPollOther.bubbleLayout.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(final View view) {
							Engine.getPollById(view.getContext(), pollOther.getId(), new RequestTemplate.ServiceCallback() {
								@Override
								public void execute(JSONObject obj) {
									try {
										Poll p = Converter.convertPoll(obj.getJSONObject("data"));
										showPollDetails(p,view.getContext());
									} catch (JSONException e1) {
										e1.printStackTrace();
									}
								}
							});
						}
					});
					break;
				default:
					//any other type
			}
		}


		return row;
	}

	void addEventToCalendar(Event e, Context c){
		Intent intent = new Intent(Intent.ACTION_INSERT)
				.setData(CalendarContract.Events.CONTENT_URI)
				.putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, e.getTimestamp()*1000)
				/*.putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime.getTimeInMillis())*/
				.putExtra(CalendarContract.Events.TITLE, e.getTitle())
				.putExtra(CalendarContract.Events.DESCRIPTION, e.getDetails())
				.putExtra(CalendarContract.Events.EVENT_LOCATION, e.getLocation())
				.putExtra(CalendarContract.Events.AVAILABILITY, CalendarContract.Events.AVAILABILITY_BUSY);
				/*.putExtra(Intent.EXTRA_EMAIL, "rowan@example.com,trevor@example.com");*/
		c.startActivity(intent);
	}

	void showEventDetails(final Event e, final Context c){

		final Dialog dialog = new Dialog(c);
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Event Detail");

		dialog.setContentView(R.layout.dialog_event_detail);
		TextView tvTitle = (TextView) dialog.findViewById(R.id.tvTitle);
		TextView tvDate = (TextView) dialog.findViewById(R.id.tvDate);
		TextView tvTime = (TextView) dialog.findViewById(R.id.tvTime);
		TextView tvLocation = (TextView) dialog.findViewById(R.id.tvLocation);
		final RadioGroup radioGroup = (RadioGroup) dialog.findViewById(R.id.rgEvent);
		final RadioButton rbGoing = (RadioButton) dialog.findViewById(R.id.rbGoing);
		final RadioButton rbNotGoing = (RadioButton) dialog.findViewById(R.id.rbNotGoing);
		final RadioButton rbInterested = (RadioButton) dialog.findViewById(R.id.rbInterested);
		Button btnChatRoom = (Button) dialog.findViewById(R.id.btnChatRoom);
		Button btnOK = (Button) dialog.findViewById(R.id.btnOK);
		ImageView ivAddToCalendar = (ImageView) dialog.findViewById(R.id.ivAddToCalendar);

		tvTitle.setText(e.getTitle());
		tvDate.setText(Functions.convertSecondToAnyFormat(e.getTimestamp(),"dd MMMM yyyy"));
		tvTime.setText(Functions.convertSecondToAnyFormat(e.getTimestamp(),"kk:mm"));
		tvLocation.setText(e.getLocation());
		ivAddToCalendar.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				addEventToCalendar(e,c);
			}
		});

		if (meID==e.getCreated_by().getId()){
			radioGroup.setVisibility(View.GONE);
		}

		final int rsvp = e.getRSVPByParticipantID(User.getUser().getID());

		if (rsvp==2){
			rbGoing.setChecked(true);
		}else if (rsvp==-1){
			rbNotGoing.setChecked(true);
		}else if (rsvp==1){
			rbInterested.setChecked(true);
		}
		btnChatRoom.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent i = new Intent(view.getContext(), ChattingActivity.class);
				i.putExtra("idThread",e.getThread().getId());
				view.getContext().startActivity(i);
			}
		});

		btnOK.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				RequestTemplate.ServiceCallback dismissDialog = new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						dialog.dismiss();
					}
				};

				int newRSVP=0;

				if (radioGroup.getCheckedRadioButtonId()==rbGoing.getId()){
					newRSVP=2;
				}else if (radioGroup.getCheckedRadioButtonId()==rbNotGoing.getId()){
					newRSVP=-1;
				}else if (radioGroup.getCheckedRadioButtonId()==rbInterested.getId()){
					newRSVP=1;
				}else {
					newRSVP=0;
				}
				if (meID==e.getCreated_by().getId()){
					if (newRSVP!=rsvp){
						Functions.showAlert(c,"Event", "You created this Event, by default you are listed as going and it can't be changed");
					}
					dismissDialog.execute(null);
				}else {
					Engine.changeRSVPStatus(c, e.getId(), newRSVP, dismissDialog);
				}

			}
		});
		dialog.show();

	}

	void showPollDetails(final Poll p, final Context c){

		final Dialog dialog = new Dialog(c);
		//dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setTitle("Poll Detail");

		dialog.setContentView(R.layout.dialog_poll_detail);
		TextView tvTitle = (TextView) dialog.findViewById(R.id.tvTitle);
		TextView tvQuestion = (TextView) dialog.findViewById(R.id.tvQuestion);
		final RadioGroup radioGroup = (RadioGroup) dialog.findViewById(R.id.rgPoll);
		Button btnOK = (Button) dialog.findViewById(R.id.btnOK);

		tvTitle.setText(p.getTitle());
		tvQuestion.setText(p.getQuestion());

		final List<RadioButton> radioButtons = new ArrayList<>();
		String myAnswer = p.alreadyAnswer(meID);
		for (Poll.PollOption opt:p.getOptions()) {
			RadioButton rb = new RadioButton(c);
			rb.setText(opt.getName());
			rb.setTag(opt);
			if (myAnswer!=null){
				rb.setEnabled(false);
				if (myAnswer.equalsIgnoreCase(opt.getValue())){
					rb.setChecked(true);
				}
			}
			radioButtons.add(rb);
			radioGroup.addView(rb);
		}
		

		btnOK.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				RequestTemplate.ServiceCallback dismissDialog = new RequestTemplate.ServiceCallback() {
					@Override
					public void execute(JSONObject obj) {
						dialog.dismiss();
					}
				};
				Poll.PollOption selectedOpt = null;
				for (int i = 0; i <radioButtons.size() ; i++) {
					if (radioGroup.getCheckedRadioButtonId()==radioButtons.get(i).getId()){
						selectedOpt = (Poll.PollOption)radioButtons.get(i).getTag();
					}
				}
				if (selectedOpt!=null){
					Engine.postPollAnswer(c, p.getId(),selectedOpt.getValue(),dismissDialog);
				}

			}
		});
		dialog.show();

	}

	@Override
	public Filter getFilter() {
		return super.getFilter();
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
		TextView name, eventTitle, eventDate, eventLocation, timestamp;
		ImageView ivAddToCalendar;
		LinearLayout bubbleLayout;
	}
	private class ViewHolderEventMe{
		TextView eventTitle, eventDate, eventLocation, timestamp;
		ImageView ivAddToCalendar;
		LinearLayout bubbleLayout;
	}

	private class ViewHolderPollOther{
		NetworkImageView ivUser;
		TextView name, pollTitle, timestamp;
		LinearLayout bubbleLayout;
	}
	private class ViewHolderPollMe{
		TextView pollTitle, timestamp;
		LinearLayout bubbleLayout;
	}
}