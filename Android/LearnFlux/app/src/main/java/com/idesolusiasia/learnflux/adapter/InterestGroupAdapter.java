package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.GroupDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/15/2016.
 */
public class InterestGroupAdapter extends RecyclerView.Adapter<InterestGroupAdapter.OrgTileHolder> {
    List<Group> organizations;
    private Context context;


    public InterestGroupAdapter(Context context, ArrayList<Group> orgs) {
        this.organizations = orgs;
        this.context = context;
    }
    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.grid_organization, null);
        OrgTileHolder rcv = new OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        final Group org= organizations.get(position);
        holder.tvName.setText(org.getName());
        holder.ivLogo.setDefaultImageResId(R.drawable.organization);
    }

    @Override
    public int getItemCount() {
        return organizations.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        public TextView tvName, tvLastSeen, tvCountMessage, tvCountEvent, tvCountActivities;
        public NetworkImageView ivLogo;
        public OrgTileHolder(View itemView) {
            super(itemView);
            tvName = (TextView) itemView.findViewById(R.id.tvName);
            tvLastSeen = (TextView) itemView.findViewById(R.id.tvLastSeen);
            tvCountMessage = (TextView) itemView.findViewById(R.id.tvCountMessage);
            tvCountEvent = (TextView) itemView.findViewById(R.id.tvCountEvent);
            tvCountActivities = (TextView) itemView.findViewById(R.id.tvCountActivities);
            ivLogo = (NetworkImageView) itemView.findViewById(R.id.ivLogo);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    final int pos = getAdapterPosition();
                    Toast.makeText(view.getContext(), tvName.getText() + " clicked", Toast.LENGTH_SHORT).show();
                    Intent i = new Intent(view.getContext(), GroupDetailActivity.class);
                    i.putExtra("id", organizations.get(pos).getId());
                    i.putExtra("title",organizations.get(pos).getName());
                    i.putExtra("type", organizations.get(pos).getType());
                    view.getContext().startActivity(i);
                }
            });
        }
    }
}
