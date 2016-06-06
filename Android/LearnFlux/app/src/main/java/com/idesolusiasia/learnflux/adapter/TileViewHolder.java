package com.idesolusiasia.learnflux.adapter;

import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.OrgDetailActivity;
import com.idesolusiasia.learnflux.R;

/**
 * Created by NAIT ADMIN on 12/04/2016.
 */
public class TileViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
	public TextView tvName, tvLastSeen, tvCountMessage, tvCountEvent, tvCountActivities;
	public ImageView ivLogo;

	public TileViewHolder(View itemView) {
		super(itemView);
		itemView.setOnClickListener(this);
		tvName = (TextView) itemView.findViewById(R.id.tvName);
		tvLastSeen = (TextView) itemView.findViewById(R.id.tvLastSeen);
		tvCountMessage = (TextView) itemView.findViewById(R.id.tvCountMessage);
		tvCountEvent = (TextView) itemView.findViewById(R.id.tvCountEvent);
		tvCountActivities = (TextView) itemView.findViewById(R.id.tvCountActivities);
		ivLogo = (ImageView) itemView.findViewById(R.id.ivLogo);
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
