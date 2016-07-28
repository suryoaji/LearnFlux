package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.OrgDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Organizations;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by NAIT ADMIN on 12/04/2016.
 */
public class OrganizationGridRecyclerViewAdapter extends RecyclerView.Adapter<OrgTileHolder> {
	private List<Organizations> itemList;
	private Context context;

	public OrganizationGridRecyclerViewAdapter(Context context, List<Organizations> itemList) {
		this.itemList = itemList;
		this.context = context;
	}

	@Override
	public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {

		View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.grid_organization, null);
		OrgTileHolder rcv = new OrgTileHolder(layoutView);
		return rcv;
	}

	@Override
	public void onBindViewHolder(OrgTileHolder holder, int position) {
		holder.tvName.setText(itemList.get(position).getName());
		if(itemList.get(position).getThumb().equalsIgnoreCase("")){
			holder.ivLogo.setImageResource(R.drawable.organization);
		}else{
			Picasso.with(context).load(itemList.get(position).getThumb()).into(holder.ivLogo);
		}

	}

	@Override
	public int getItemCount() {
		return this.itemList.size();
	}
}

class OrgTileHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
	public TextView tvName, tvLastSeen, tvCountMessage, tvCountEvent, tvCountActivities;
	public NetworkImageView ivLogo;

	public OrgTileHolder(View itemView) {
		super(itemView);
		itemView.setOnClickListener(this);
		tvName = (TextView) itemView.findViewById(R.id.tvName);
		tvLastSeen = (TextView) itemView.findViewById(R.id.tvLastSeen);
		tvCountMessage = (TextView) itemView.findViewById(R.id.tvCountMessage);
		tvCountEvent = (TextView) itemView.findViewById(R.id.tvCountEvent);
		tvCountActivities = (TextView) itemView.findViewById(R.id.tvCountActivities);
		ivLogo = (NetworkImageView) itemView.findViewById(R.id.ivLogo);
	}

	@Override
	public void onClick(View view) {
		Toast.makeText(view.getContext(), tvName.getText() + " clicked", Toast.LENGTH_SHORT).show();
		Intent i = new Intent(view.getContext(), OrgDetailActivity.class);
		view.getContext().startActivity(i);
		//Toast.makeText(view.getContext(), "Clicked Position = " + getAdapterPosition(), Toast.LENGTH_SHORT).show();
		/*if (text.getText().toString().equalsIgnoreCase("chat")){
			Intent i = new Intent(view.getContext(),ChatsActivity.class);
			view.getContext().startActivity(i);
		}*/
	}
}