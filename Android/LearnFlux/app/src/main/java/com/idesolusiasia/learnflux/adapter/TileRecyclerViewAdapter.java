package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NAIT ADMIN on 12/04/2016.
 */
public class TileRecyclerViewAdapter extends RecyclerView.Adapter<TileViewHolder> {
	private List<String> itemTitle;
	private List<Integer> itemImage;

	public TileRecyclerViewAdapter(Context context) {
		this.itemTitle=new ArrayList<>();
		this.itemImage=new ArrayList<>();
		itemTitle.add("Activities");
		itemImage.add(R.drawable.activities);
		itemTitle.add("Organization");
		itemImage.add(R.drawable.organization);
		itemTitle.add("Chat");
		itemImage.add(R.drawable.chatting);
		itemTitle.add("Settings");
		itemImage.add(R.drawable.settings);

	}

	@Override
	public TileViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

		View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_mosaic_tile, null);
		TileViewHolder rcv = new TileViewHolder(layoutView);
		return rcv;
	}

	@Override
	public void onBindViewHolder(TileViewHolder holder, int position) {
		holder.text.setText(itemTitle.get(position));
		holder.image.setImageResource(itemImage.get(position));
	}

	@Override
	public int getItemCount() {
		return this.itemImage.size();
	}
}
