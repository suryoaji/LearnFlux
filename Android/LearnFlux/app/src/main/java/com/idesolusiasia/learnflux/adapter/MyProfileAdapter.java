package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/4/2016.
 */

public class MyProfileAdapter extends RecyclerView.Adapter<MyProfileAdapter.OrgTileHolder> {
    List<Group> organizations;
    private Context context;
    public MyProfileAdapter(Context context, ArrayList<Group> orgs){
        this.organizations = orgs;
        this.context= context;
    }
    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_rowinterestchoose, null);
        MyProfileAdapter.OrgTileHolder rcv = new MyProfileAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        final Group org= organizations.get(position);
        //holder.image.setDefaultImageResId(R.drawable.lasalle_logo);
        holder.name.setText(org.getName());
    }

    @Override
    public int getItemCount() {
        return organizations.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        NetworkImageView image;
        TextView name;
        public OrgTileHolder(View itemView) {
            super(itemView);
          //  image = (NetworkImageView) itemView.findViewById(R.id.organizationImage);
            name = (TextView)itemView.findViewById(R.id.nameOfInterest);
        }
    }
}
