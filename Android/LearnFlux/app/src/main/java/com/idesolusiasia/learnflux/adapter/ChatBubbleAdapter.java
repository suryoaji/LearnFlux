package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
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
	public static final int TYPE_PLAIN_ME = 0;
	public static final int TYPE_PLAIN_OTHER = 1;
	public static final int TYPE_EVENT_ME = 2;
	public static final int TYPE_EVENT_OTHER = 3;
	public static final int TYPE_POLL_ME = 4;
	public static final int TYPE_POLL_OTHER = 5;

	public ChatBubbleAdapter(Context context, List<Message> objects) {
		super(context, R.layout.row_plainbubble_other, objects);
		this.chatBubbles=objects;
	}

	@Override
	public int getViewTypeCount() {
		return 6;
	}

	@Override
	public int getItemViewType(int position) {
		String type = chatBubbles.get(position).getType();
		boolean me = (chatBubbles.get(position).getSender().getId()==meID);
		/*if (type.equalsIgnoreCase("message")){
			if (me){
				return TYPE_PLAIN_ME;
			}else{
				return TYPE_PLAIN_OTHER;
			}
		}else if (type.equalsIgnoreCase("event")){
			if (me){
				return TYPE_EVENT_ME;
			}else{
				return TYPE_EVENT_OTHER;
			}
		}else{
			if (me){
				return TYPE_POLL_ME;
			}else{
				return TYPE_POLL_OTHER;
			}
		}*/

		if (me){
			return TYPE_PLAIN_ME;
		}else{
			return TYPE_PLAIN_OTHER;
		}
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
				viewHolder.timestamp.setText(e.getCreatedAtDate());

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
				viewHolder.timestamp.setText(e.getCreatedAtDate());
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