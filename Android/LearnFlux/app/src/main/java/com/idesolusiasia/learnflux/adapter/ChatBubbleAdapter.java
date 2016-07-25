package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Message;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.util.List;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class ChatBubbleAdapter extends ArrayAdapter<Message> implements Filterable{

	public List<Message> chatBubbles=null;
	int meID = User.getUser().getID();
	int page;

	public ChatBubbleAdapter(Context context, List<Message> objects) {
		super(context, R.layout.row_plainbubble_other, objects);
		this.chatBubbles=objects;
		page=2;
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

		if(e != null){
			Log.i("ME ID",String.valueOf(meID));
			LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

			if (e.getSender().getId()==meID) {
				row = inflater.inflate(R.layout.row_plainbubble_me, null);

				ViewHolderPlainMe viewHolder = new ViewHolderPlainMe();
				viewHolder.message = (TextView) row.findViewById(R.id.tvMessage);
				viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
				viewHolder.ivImportant = (ImageView) row.findViewById(R.id.ivImportant);

				/*if (((PlainChatBubble) e).isImportant()) {
					viewHolder.ivImportant.setVisibility(View.VISIBLE);
					viewHolder.ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
					viewHolder.message.setTextColor(Color.parseColor("#FF0000"));
				} else {
					viewHolder.ivImportant.setVisibility(View.GONE);
				}*/

				viewHolder.message.setText(e.getBody());
				viewHolder.timestamp.setText(e.getCreatedAt());

			} else {
				row = inflater.inflate(R.layout.row_plainbubble_other, null);

				ViewHolderPlainOther viewHolder = new ViewHolderPlainOther();
				viewHolder.message = (TextView) row.findViewById(R.id.tvMessage);
				viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);
				viewHolder.ivUser = (NetworkImageView) row.findViewById(R.id.ivPhoto);
				viewHolder.name = (TextView) row.findViewById(R.id.tvName);
				viewHolder.ivImportant = (ImageView) row.findViewById(R.id.ivImportant);

				/*if (((PlainChatBubble) e).isImportant()) {
					viewHolder.ivImportant.setVisibility(View.VISIBLE);
					viewHolder.ivImportant.setColorFilter(Color.parseColor("#FF0000"), PorterDuff.Mode.SRC_ATOP);
					viewHolder.message.setTextColor(Color.parseColor("#FF0000"));
				} else {
					viewHolder.ivImportant.setVisibility(View.GONE);
				}*/

				viewHolder.ivImportant.setVisibility(View.GONE);
				viewHolder.message.setText(e.getBody());
				viewHolder.timestamp.setText(e.getCreatedAt());
				viewHolder.ivUser.setImageUrl(e.getSender().getPhoto(),
						VolleySingleton.getInstance(getContext().getApplicationContext()).getImageLoader());
				viewHolder.ivUser.setDefaultImageResId(R.drawable.me);
				viewHolder.name.setText(e.getSender().getFirstName());
			}

		}
		return row;
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
}