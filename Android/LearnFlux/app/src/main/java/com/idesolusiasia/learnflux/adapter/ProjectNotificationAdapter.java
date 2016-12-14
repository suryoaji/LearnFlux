package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.graphics.Color;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;

import java.util.ArrayList;

/**
 * Created by Kuroko on 12/13/2016.
 */

public class ProjectNotificationAdapter extends RecyclerView.Adapter<ProjectNotificationAdapter.NotificationHolder> {
    Context mContext;
    ArrayList<String> notif = new ArrayList<>();
    public ProjectNotificationAdapter(Context context, ArrayList<String>notify){
        this.mContext =  context;
        this.notif = notify;
    }

    @Override
    public NotificationHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view= LayoutInflater.from(parent.getContext()).inflate(R.layout.row_project_notification,null);
        NotificationHolder ntV = new NotificationHolder(view);
        return ntV;
    }

    @Override
    public void onBindViewHolder(NotificationHolder holder, int position) {
        holder.notifTitle.setText(notif.get(position));
    }

    @Override
    public int getItemCount() {
        return notif.size();
    }

    public class NotificationHolder extends RecyclerView.ViewHolder {
        TextView notifTitle;
        public NotificationHolder(View itemView) {
            super(itemView);
            notifTitle = (TextView)itemView.findViewById(R.id.projectNotifTitle);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    int pos = getAdapterPosition();

                }
            });
        }
    }
}
