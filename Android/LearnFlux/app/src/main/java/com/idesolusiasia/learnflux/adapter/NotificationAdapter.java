package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.idesolusiasia.learnflux.MyProfileActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Notification;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONObject;

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
            holder.addNotif.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(final View view) {
                    Engine.joinGroup(view.getContext(), n.getRef(), "join", new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            Toast.makeText(view.getContext(),"Successfull",Toast.LENGTH_SHORT).show();
                            Intent i = new Intent(view.getContext(), MyProfileActivity.class);
                            view.getContext().startActivity(i);
                        }
                    });
                }
            });
    }

    @Override
    public int getItemCount() {

        return mNotification.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        TextView message, from;
        ImageView addNotif;
        public OrgTileHolder(View itemView) {
            super(itemView);
            message = (TextView)itemView.findViewById(R.id.notifMessage);
            from = (TextView)itemView.findViewById(R.id.notifFrom);
            addNotif = (ImageView)itemView.findViewById(R.id.addNotification);
        }
    }
}
