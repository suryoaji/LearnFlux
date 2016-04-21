package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.ChatBubble;
import com.idesolusiasia.learnflux.entity.PlainChatBubble;

import java.util.List;

/**
 * Created by NAIT ADMIN on 21/04/2016.
 */
public class ChatBubbleAdapter extends ArrayAdapter<ChatBubble>{

	int layoutResourceId;
	List<ChatBubble> chatBubbles=null;
	int page;

	public ChatBubbleAdapter(Context context, int resource, List<ChatBubble> objects) {
		super(context, resource, objects);
		layoutResourceId=resource;
		this.chatBubbles=objects;
		page=2;
	}

	public ChatBubble getItem(int i){
		if (chatBubbles!=null && chatBubbles.size()>0 && i>=0){
			return chatBubbles.get(i);
		}else return null;
	}
	public View getView(int position, View conView, ViewGroup parent){
		//Log.i("Response","masuk getView");
		View row=conView;
		if(row==null){
			LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			row = inflater.inflate(layoutResourceId,null);
		}

		ChatBubble e = chatBubbles.get(position);
		if(e != null){

			if (e.getType().equalsIgnoreCase("plain")){
				if (e.getSender().equalsIgnoreCase("me")){
					ViewHolderPlainMe viewHolder = new ViewHolderPlainMe();
					viewHolder.message = (TextView) row.findViewById(R.id.tvMessage);
					viewHolder.timestamp = (TextView) row.findViewById(R.id.tvTime);

					viewHolder.message.setText(((PlainChatBubble) e).getMessage());
					viewHolder.timestamp.setText(((PlainChatBubble) e).getMessage());

				}else{

				}
			}else if (e.getType().equalsIgnoreCase("event")){
				if (e.getSender().equalsIgnoreCase("me")){

				}else{

				}
			}
			else if (e.getType().equalsIgnoreCase("poll")){
				if (e.getSender().equalsIgnoreCase("me")){

				}else{

				}
			}
			/*ViewHolder viewHolder = new ViewHolder();
			viewHolder.ivAgent = (NetworkImageView) row.findViewById(R.id.iv_agent);
			viewHolder.nameAgent = (TextView) row.findViewById(R.id.tvName_agent);
			viewHolder.areaAgent = (TextView) row.findViewById(R.id.tvArea_agent);
			viewHolder.specializationAgent = (TextView) row.findViewById(R.id.tvSpecialization_agent);


			if (viewHolder.ivAgent!=null){
				viewHolder.ivAgent.setDefaultImageResId(R.drawable.agent_2);
			}*/

		}

		return row;
	}

	private class ViewHolderPlainOther{
		NetworkImageView ivUser;
		TextView name, message, timestamp;
	}
	private class ViewHolderPlainMe{
		TextView message, timestamp;
	}
	private class ViewHolderEventOther{
		NetworkImageView ivUser;
		ImageView btnAddToCalendar;
		LinearLayout bubbleLayout;
		TextView name, title, timestamp, eventTime, location;
	}
	private class ViewHolderEventMe{
		ImageView btnAddToCalendar;
		LinearLayout bubbleLayout;
		TextView title, timestamp, eventTime, location;
	}
	private class ViewHolderPollOther{
		NetworkImageView ivUser;
		LinearLayout bubbleLayout;
		TextView name, question, timestamp;
	}
	private class ViewHolderPollMe{
		LinearLayout bubbleLayout;
		TextView question, timestamp;
	}
}