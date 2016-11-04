package com.idesolusiasia.learnflux.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.provider.CalendarContract;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.ChatsActivity;
import com.idesolusiasia.learnflux.ChattingActivity;
import com.idesolusiasia.learnflux.OrgDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.EventChatBubble;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by NAIT ADMIN on 17/06/2016.
 */
public class OrganizationEventAdapter extends RecyclerView.Adapter<OrganizationEventAdapter.OrgTileHolder>{
	public List<Event>	event;
	private Context context;
	public boolean setFirstSelection =true;


	public OrganizationEventAdapter(Context context, ArrayList<Event> orgs) {
		this.event = orgs;
		this.context = context;
	}
	@Override
	public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
		View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_events,null);
		OrgTileHolder rcv = new OrgTileHolder(layoutView);
		return rcv;
	}

	@Override
	public void onBindViewHolder(final OrgTileHolder holder, int position) {
		final Event ev = event.get(position);
		if (ev.getGetEventByGroupRSVP() != 2) {
			holder.toChat.setEnabled(false);
			holder.toChat.setClickable(false);
			holder.toChat.setColorFilter(Color.GRAY);
			holder.addEvent.setEnabled(false);
			holder.addEvent.setClickable(false);
			holder.addEvent.setColorFilter(Color.GRAY);
		}
		holder.tvTitle.setText(ev.getTitle());
		holder.tvLocation.setText(ev.getLocation());
		if (ev.getDetails() != null) {
			holder.tvDescription.setText(ev.getDetails());
			holder.tvDescription.post(new Runnable() {
				@Override
				public void run() {
					int a = holder.tvDescription.getLineCount();
					if (a > 2) {
						holder.tvSeeMore.setVisibility(View.VISIBLE);
						holder.tvDescription.setMaxLines(2);
					}
				}
			});
		}

		holder.tvSeeMore.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				holder.tvDescription.setMaxLines(Integer.MAX_VALUE);
				holder.tvSeeMore.setVisibility(View.GONE);
			}
		});
		if (User.getUser().getID() != ev.getCreated_by().getId()) {
			holder.editEvent.setVisibility(View.GONE);
		} else {
			holder.editEvent.setVisibility(View.VISIBLE);
		}
		holder.tvTime.setText(Functions.convertSecondToAnyFormat(ev.getTimestamp(), "kk:mm"));
		holder.tvDay.setText(Functions.convertSecondToAnyFormat(ev.getTimestamp(), "dd"));
		holder.tvMonth.setText(Functions.convertSecondToAnyFormat(ev.getTimestamp(), "MMM"));
		holder.tvYear.setText(Functions.convertSecondToAnyFormat(ev.getTimestamp(), "yyyy"));
		holder.addEvent.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				addEventToCalendar(ev, context);
			}
		});
		holder.toChat.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				getEventsID(ev, context);
			}
		});

		if (ev.getGetEventByGroupRSVP() == 0) {
			holder.spinner.setSelection(0, false);
		} else if (ev.getGetEventByGroupRSVP() == 1) {
			holder.spinner.setSelection(2, false);
		} else if (ev.getGetEventByGroupRSVP() == 2) {
			holder.spinner.setSelection(1, false);
		} else {
			holder.spinner.setSelection(3, false);
		}
		holder.spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
				setFirstSelection=false;
				int newRSVP = 0;
				String yes = holder.spinner.getSelectedItem().toString();
					if (yes.equalsIgnoreCase("Not Going")) {
						//this position for not going
						newRSVP = -1;
						holder.toChat.setEnabled(false);
						holder.toChat.setClickable(false);
						holder.toChat.setColorFilter(Color.GRAY);
						holder.addEvent.setEnabled(false);
						holder.addEvent.setClickable(false);
						holder.addEvent.setColorFilter(Color.GRAY);
						getChange(context, ev, newRSVP,position);
					} else if (yes.equalsIgnoreCase("Going")) {
						//this position for going
						newRSVP = 2;
						holder.toChat.setEnabled(true);
						holder.toChat.setClickable(true);
						holder.toChat.setColorFilter(Color.parseColor("#8bc34a"));
						holder.addEvent.setEnabled(true);
						holder.addEvent.setClickable(true);
						holder.addEvent.setColorFilter(Color.parseColor("#8bc34a"));
						getChange(context, ev, newRSVP,position);
					} else if (yes.equalsIgnoreCase("Interested")) {
						//this position for interested
						newRSVP = 1;
						holder.toChat.setEnabled(false);
						holder.toChat.setClickable(false);
						holder.toChat.setColorFilter(Color.GRAY);
						holder.addEvent.setEnabled(false);
						holder.addEvent.setClickable(false);
						holder.addEvent.setColorFilter(Color.GRAY);
						getChange(context, ev, newRSVP,position);
					} else {
						//this position for not selected
						newRSVP = 0;
					}
				}
			@Override
			public void onNothingSelected(AdapterView<?> adapterView) {

			}
		});
	}
	@Override
	public int getItemViewType(int position) {

		return position;
	}

	public void getChange(Context c, Event e, int rspv, final int pos){
		Engine.changeRSVPStatus(c, e.getId(), rspv, new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				Toast.makeText(context, "Successful", Toast.LENGTH_SHORT).show();
				notifyItemChanged(pos);
				/*Intent intent = ((Activity) context).getIntent();
				((Activity) context).setResult(((Activity) context).RESULT_OK,
						intent);
				((Activity) context).finish();*/

			}
		});
	}
	@Override
	public int getItemCount() {
		return event.size();
	}

	public class OrgTileHolder extends RecyclerView.ViewHolder {
		public TextView tvTitle,tvTime, tvLocation, tvDescription, tvMonth, tvDay, tvYear,tvSeeMore;
		public ImageView addEvent, toChat, editEvent;
		public Spinner spinner;
		public OrgTileHolder(View itemView) {
			super(itemView);
			tvTitle = (TextView) itemView.findViewById(R.id.tvTitle);
			tvTime = (TextView) itemView.findViewById(R.id.tvTime);
			tvMonth = (TextView)itemView.findViewById(R.id.tvMonth);
			editEvent = (ImageView)itemView.findViewById(R.id.imageButton);
			tvDay = (TextView)itemView.findViewById(R.id.tvDay);
			tvYear = (TextView)itemView.findViewById(R.id.tvYear) ;
			tvLocation = (TextView) itemView.findViewById(R.id.tvLocation);
			tvDescription = (TextView)itemView.findViewById(R.id.tvDescription);
			addEvent = (ImageView)itemView.findViewById(R.id.ivAddEvent);
			toChat = (ImageView)itemView.findViewById(R.id.ivInvite);
			spinner = (Spinner)itemView.findViewById(R.id.spinner);
			tvSeeMore = (TextView) itemView.findViewById(R.id.tvSeeMore);
		}
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
	void getEventsID(Event e, final Context c){
		Engine.getEventById(c, e.getId(), new RequestTemplate.ServiceCallback() {
			@Override
			public void execute(JSONObject obj) {
				try{
					Event e= Converter.convertEvent(obj.getJSONObject("data"));
					Intent i = new Intent(c, ChattingActivity.class);
					i.putExtra("idThread", e.getThread().getId());
					i.putExtra("name", e.getTitle());
					i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					Log.i("Event: ",e.getThread().getId());
					c.startActivity(i);
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
}