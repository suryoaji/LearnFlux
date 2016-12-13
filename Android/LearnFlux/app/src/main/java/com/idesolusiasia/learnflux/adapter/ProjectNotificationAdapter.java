package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.idesolusiasia.learnflux.R;

/**
 * Created by Kuroko on 12/13/2016.
 */

public class ProjectNotificationAdapter extends RecyclerView.Adapter<ProjectNotificationAdapter.NotificationHolder> {
    Context mContext;

    public ProjectNotificationAdapter(Context context){
        this.mContext =  context;
    }

    @Override
    public NotificationHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view= LayoutInflater.from(parent.getContext()).inflate(R.layout.row_project_notification,null);
        NotificationHolder ntV = new NotificationHolder(view);
        return ntV;
    }

    @Override
    public void onBindViewHolder(NotificationHolder holder, int position) {

    }

    @Override
    public int getItemCount() {
        return 0;
    }

    public class NotificationHolder extends RecyclerView.ViewHolder {
        public NotificationHolder(View itemView) {
            super(itemView);
        }
    }
}
