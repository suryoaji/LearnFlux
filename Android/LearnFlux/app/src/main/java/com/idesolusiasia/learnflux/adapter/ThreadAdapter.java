package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.RoundedImageView;
import com.idesolusiasia.learnflux.entity.Thread;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.util.List;

/**
 * Created by NAIT ADMIN on 12/04/2016.
 */
public class ThreadAdapter extends ArrayAdapter<Thread> {
	public List<Thread> threadList =null;
	int page;

	public ThreadAdapter(Context context, List<Thread> objects) {
		super(context, R.layout.row_chatroom, objects);
		this.threadList =objects;
		page=2;
	}

	public Thread getItem(int i){
		if (threadList !=null && threadList.size()>0 && i>=0){
			return threadList.get(i);
		}else return null;
	}

	public void clearSelection(){
		for (Thread t:threadList) {
			t.setSelected(false);
		}
	}

	public View getView(int position, View conView, ViewGroup parent){
		//Log.i("Response","masuk getView");
		View row=conView;
		LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		if (row==null){
			row=inflater.inflate(R.layout.row_chatroom,null);
		}
		final Thread e = threadList.get(position);
		if(e != null){
			RoundedImageView ivThread = (RoundedImageView) row.findViewById(R.id.ivRoundPic);
			TextView tvTitle = (TextView) row.findViewById(R.id.tvChatRoomTitle);
			TextView tvLastMessage = (TextView) row.findViewById(R.id.tvLastMessage);
			TextView tvDate = (TextView) row.findViewById(R.id.tvDate);
			LinearLayout bubbleLayout = (LinearLayout) row.findViewById(R.id.bubbleLayout);
			CheckBox checkBox = (CheckBox) row.findViewById(R.id.checkBox);

			if (e.isSelected()){
				bubbleLayout.setBackgroundColor(Color.parseColor("#FFCDCDCD"));
				/*checkBox.setVisibility(View.VISIBLE);
				checkBox.setChecked(true);*/
			}else {
				bubbleLayout.setBackgroundColor(Color.parseColor("#00ffffff"));
				/*checkBox.setVisibility(View.GONE);
				checkBox.setChecked(false);*/
			}

			if (e.getImage()!=null){
				ImageLoader imageLoader= VolleySingleton.getInstance(conView.getContext()).getImageLoader();
				imageLoader.get(e.getImage(), ImageLoader.getImageListener(ivThread,R.drawable.me,R.drawable.me));
			}

			if (e.getTitle()!=null){
				tvTitle.setText(e.getTitle());
			}
			if (e.getLastMessage()!=null){
				String message = e.getLastMessage().getBody();
				String date = e.getLastMessage().getCreatedAtDate();
				tvDate.setText(date);
				tvLastMessage.setText(message);
			}
		}
		return row;
	}
}
