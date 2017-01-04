package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.activity.GroupDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/4/2016.
 */

public class MyProfileOrganizationAdapter extends RecyclerView.Adapter<MyProfileOrganizationAdapter.OrgTileHolder> {
    List<Group> organizations;
    private Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();

    public MyProfileOrganizationAdapter(Context context, ArrayList<Group> orgs){
        this.organizations = orgs;
        this.context= context;
    }
    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_myprofileorganization, null);
        MyProfileOrganizationAdapter.OrgTileHolder rcv = new MyProfileOrganizationAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(final OrgTileHolder holder, int position) {
        final Group org= organizations.get(position);
        final String url = "http://lfapp.learnflux.net/v1/image?key=";
        if(org.getImage()==null){
            holder.image.setDefaultImageResId(R.drawable.company1);
        }else {
            holder.image.setImageUrl(url+org.getImage(), imageLoader);
        }

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
            image = (NetworkImageView) itemView.findViewById(R.id.organizationImage);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    Intent i = new Intent(v.getContext() , GroupDetailActivity.class);
                    i.putExtra("id", organizations.get(pos).getId());
                    i.putExtra("plusButton","hide");
                    i.putExtra("clickOrganization", "Default");
                    i.putExtra("color", Functions.generateRandomPastelColor());
                    i.putExtra("title",organizations.get(pos).getName());
                    i.putExtra("type", organizations.get(pos).getType());
                    i.putExtra("img", organizations.get(pos).getImage());
                    v.getContext().startActivity(i);
                }
            });
        }
    }
}
