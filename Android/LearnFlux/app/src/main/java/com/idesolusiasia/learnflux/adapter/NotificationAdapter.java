package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Notification;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/26/2016.
 */

public class NotificationAdapter extends RecyclerView.Adapter<NotificationAdapter.OrgTileHolder> {
    private Context mContext;
    private List<Notification>mNotification = new ArrayList<>();

    public NotificationAdapter(Context context, List<Notification>notification){
        this.mContext=context;
        this.mNotification= notification;

    }

    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.dialog_notifme, null);
        NotificationAdapter.OrgTileHolder rcv = new NotificationAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
            final Notification n = mNotification.get(position);
            holder.message.setText(n.getMessage());
            holder.from.setText(n.getRef());
    }

    @Override
    public int getItemCount() {

        return mNotification.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        TextView message, from;
        public OrgTileHolder(View itemView) {
            super(itemView);
            message = (TextView)itemView.findViewById(R.id.notifMessage);
            from = (TextView)itemView.findViewById(R.id.notifFrom);
        }
    }
}
