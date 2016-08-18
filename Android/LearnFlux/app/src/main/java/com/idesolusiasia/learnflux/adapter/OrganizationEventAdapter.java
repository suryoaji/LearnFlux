package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Event;
import com.idesolusiasia.learnflux.entity.EventChatBubble;
import com.idesolusiasia.learnflux.entity.Group;

import java.util.ArrayList;
import java.util.List;

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

	}

	@Override
	public int getItemCount() {
		return event.size();
	}

	public class OrgTileHolder extends RecyclerView.ViewHolder {
		public TextView tvTitle, tvDate, tvTime, tvLocation, tvDescription;
		public OrgTileHolder(View itemView) {
			super(itemView);
			tvTitle = (TextView) itemView.findViewById(R.id.tvTitle);
			tvDate = (TextView) itemView.findViewById(R.id.tvDate);
			tvTime = (TextView) itemView.findViewById(R.id.tvTime);
			tvLocation = (TextView) itemView.findViewById(R.id.tvLocation);
			tvDescription = (TextView)itemView.findViewById(R.id.tvDescription);
		}
	}
}