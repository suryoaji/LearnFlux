package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.provider.CalendarContract;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.ChattingActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.EventChatBubble;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Converter;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONException;
import org.json.JSONObject;

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
	public void onBindViewHolder(OrgTileHolder holder, int position) {

		final Event ev = event.get(position);
		holder.tvTitle.setText(ev.getTitle());
		holder.tvLocation.setText(ev.getLocation());
		holder.tvDescription.setText(ev.getDetails());
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

	}

	@Override
	public int getItemCount() {
		return event.size();
	}

	public class OrgTileHolder extends RecyclerView.ViewHolder {
		public TextView tvTitle, tvDate, tvTime, tvLocation, tvDescription;
		public ImageView addEvent, toChat;
		public OrgTileHolder(View itemView) {
			super(itemView);
			tvTitle = (TextView) itemView.findViewById(R.id.tvTitle);
			tvDate = (TextView) itemView.findViewById(R.id.tvDate);
			tvTime = (TextView) itemView.findViewById(R.id.tvTime);
			tvLocation = (TextView) itemView.findViewById(R.id.tvLocation);
			tvDescription = (TextView)itemView.findViewById(R.id.tvDescription);
			addEvent = (ImageView)itemView.findViewById(R.id.ivAddEvent);
			toChat = (ImageView)itemView.findViewById(R.id.ivInvite);
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
					i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					c.startActivity(i);
				}catch (JSONException e){
					e.printStackTrace();
				}
			}
		});
	}
}