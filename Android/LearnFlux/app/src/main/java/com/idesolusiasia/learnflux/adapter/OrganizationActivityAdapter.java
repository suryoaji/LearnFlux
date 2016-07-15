package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Activity;

import java.util.List;

/**
 * Created by NAIT ADMIN on 17/06/2016.
 */
public class OrganizationActivityAdapter extends ArrayAdapter<Activity> {
	public List<Activity> threadList =null;
	int page;

	public OrganizationActivityAdapter(Context context, List<Activity> objects) {
		super(context, R.layout.row_activities, objects);
		this.threadList =objects;
		page=2;
	}

	public Activity getItem(int i){
		if (threadList !=null && threadList.size()>0 && i>=0){
			return threadList.get(i);
		}else return null;
	}

	public View getView(int position, View conView, ViewGroup parent){
		//Log.i("Response","masuk getView");
		View row=conView;
		LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		if (row==null){
			row=inflater.inflate(R.layout.row_activities,null);
		}
		final Activity e = threadList.get(position);
		if(e != null){
			ImageView ivInvite = (ImageView) row.findViewById(R.id.ivInvite);
			ImageView ivAddCalendar = (ImageView) row.findViewById(R.id.ivAddToCalendar);

			TextView tvTitle = (TextView) row.findViewById(R.id.tvTitle);
			TextView tvDay = (TextView) row.findViewById(R.id.tvDay);
			TextView tvMonth = (TextView) row.findViewById(R.id.tvMonth);
			TextView tvYear = (TextView) row.findViewById(R.id.tvYear);
			TextView tvTime = (TextView) row.findViewById(R.id.tvTime);
			final TextView tvDescription = (TextView) row.findViewById(R.id.tvDescription);
			final TextView tvSeeMore = (TextView) row.findViewById(R.id.tvSeeMore);

			if (e.getTitle()!=null){
				tvTitle.setText(e.getTitle());
			}
			if (e.getDescription()!=null){
				tvDescription.setText(e.getDescription());
				tvDescription.post(new Runnable() {
					@Override
					public void run() {
						int a = tvDescription.getLineCount();
						if (a>2){
							tvSeeMore.setVisibility(View.VISIBLE);
							tvDescription.setMaxLines(2);
						}
					}
				});
			}

			tvSeeMore.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					tvDescription.setMaxLines(Integer.MAX_VALUE);
					tvSeeMore.setVisibility(View.GONE);
				}
			});

			if (e.getTitle()!=null){
				tvTitle.setText(e.getTitle());
			}


		}
		return row;
	}
}