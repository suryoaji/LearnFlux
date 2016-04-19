package com.idesolusiasia.learnflux.adapter;

import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.ChatsActivity;
import com.idesolusiasia.learnflux.R;

/**
 * Created by NAIT ADMIN on 12/04/2016.
 */
public class TileViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
	public TextView text;
	public ImageView image;

	public TileViewHolder(View itemView) {
		super(itemView);
		itemView.setOnClickListener(this);
		text = (TextView) itemView.findViewById(R.id.tileText);
		image = (ImageView) itemView.findViewById(R.id.tileImage);
	}

	@Override
	public void onClick(View view) {
		Toast.makeText(view.getContext(), text.getText() + " clicked", Toast.LENGTH_SHORT).show();
		//Toast.makeText(view.getContext(), "Clicked Position = " + getAdapterPosition(), Toast.LENGTH_SHORT).show();
		if (text.getText().toString().equalsIgnoreCase("chat")){
			Intent i = new Intent(view.getContext(),ChatsActivity.class);
			view.getContext().startActivity(i);
		}
	}



}
