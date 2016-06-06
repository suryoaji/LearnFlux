package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.R;

import java.util.List;

/**
 * Created by NAIT ADMIN on 12/04/2016.
 */
public class TileRecyclerViewAdapter extends RecyclerView.Adapter<TileViewHolder> {
	private List<String> itemList;
	private Context context;

	public TileRecyclerViewAdapter(Context context, List<String> itemList) {
		this.itemList = itemList;
		this.context = context;
	}

	@Override
	public TileViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

		View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.grid_organization, null);
		TileViewHolder rcv = new TileViewHolder(layoutView);
		return rcv;
	}

	@Override
	public void onBindViewHolder(TileViewHolder holder, int position) {
		holder.tvName.setText(itemList.get(position));

	}

	@Override
	public int getItemCount() {
		return this.itemList.size();
	}
}
