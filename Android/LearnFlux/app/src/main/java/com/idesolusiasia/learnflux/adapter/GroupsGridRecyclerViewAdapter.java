package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.GroupDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.util.Functions;

import java.util.List;

/**
 * Created by NAIT ADMIN on 01/07/2016.
 */

public class GroupsGridRecyclerViewAdapter extends RecyclerView.Adapter<GroupsTileHolder> {
	private List<Group> groups;
	private Context context;

	public GroupsGridRecyclerViewAdapter(Context context, List<Group> itemList) {
		this.groups = itemList;
		this.context = context;
	}

	@Override
	public GroupsTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {

		View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.grid_groups, null);
		GroupsTileHolder rcv = new GroupsTileHolder(layoutView);
		return rcv;
	}

	@Override
	public void onBindViewHolder(GroupsTileHolder holder, int position) {
		holder.tvGroupName.setText(groups.get(position).getName().toUpperCase());
		holder.tvGroupDetail.setText(groups.get(position).getDetail().toUpperCase());

		Typeface type=Typeface.createFromAsset(context.getAssets(), context.getString(R.string.font_groups_grid));
		holder.tvGroupName.setTypeface(type);
		holder.tvGroupDetail.setTypeface(type);


		holder.layout.setBackgroundColor(Functions.generateRandomPastelColor());

	}

	@Override
	public int getItemCount() {
		return this.groups.size();
	}
}
class GroupsTileHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
	public TextView tvGroupName, tvGroupDetail;
	public LinearLayout layout;

	public GroupsTileHolder(View itemView) {
		super(itemView);
		itemView.setOnClickListener(this);
		tvGroupName = (TextView) itemView.findViewById(R.id.tvGroupName);
		tvGroupDetail = (TextView) itemView.findViewById(R.id.tvGroupDetail);
		layout = (LinearLayout) itemView.findViewById(R.id.layoutGroupsGrid);

	}

	@Override
	public void onClick(View view) {
		Toast.makeText(view.getContext(), tvGroupName.getText() + " clicked", Toast.LENGTH_SHORT).show();
		Intent i = new Intent(view.getContext(), GroupDetailActivity.class);
		view.getContext().startActivity(i);
		//Toast.makeText(view.getContext(), "Clicked Position = " + getAdapterPosition(), Toast.LENGTH_SHORT).show();
		/*if (text.getText().toString().equalsIgnoreCase("chat")){
			Intent i = new Intent(view.getContext(),ChatsActivity.class);
			view.getContext().startActivity(i);
		}*/
	}
}