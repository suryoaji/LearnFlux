package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.GroupDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;

import java.util.ArrayList;

/**
 * Created by Ide Solusi Asia on 11/9/2016.
 */

public class SearchInterestGroup extends RecyclerView.Adapter<SearchInterestGroup.OrgTileHolder> {
    public Context mContext;
    public ArrayList<Group>groups = new ArrayList<>();
    ImageLoader imageLoader = VolleySingleton.getInstance(mContext).getImageLoader();
    public SearchInterestGroup(Context context, ArrayList<Group>grops){
            this.mContext=context;
            this.groups=grops;
    }


    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutiView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_connectionorg,null);
        OrgTileHolder rcv =new OrgTileHolder(layoutiView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        final Group org = groups.get(position);
        String url="http://lfapp.learnflux.net/v1/image?key=";
        holder.txt1.setText(org.getName());
        Animation animation = AnimationUtils.loadAnimation(mContext,
                R.anim.popup_enter);
        if(org.getImage()!=null) {
            Ion.with(mContext)
                    .load(url+org.getImage())
                    .addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
                    .withBitmap().animateLoad(animation)
                    .intoImageView(holder.image);
        }else{
            holder.image.setImageResource(R.drawable.company1);
        }
    }

    @Override
    public int getItemCount() {
        return groups.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        ImageView image;
        TextView txt1, txt2;
        ImageView joinGrp;
        public OrgTileHolder(View itemView) {
            super(itemView);
            image = (ImageView) itemView.findViewById(R.id.imageOrgConnection);
            txt1 = (TextView)itemView.findViewById(R.id.titleOrgConnection);
            txt2 = (TextView)itemView.findViewById(R.id.StatusOrgConnection);
            joinGrp = (ImageView)itemView.findViewById(R.id.joinGroup);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    Intent i = new Intent(v.getContext() , GroupDetailActivity.class);
                    i.putExtra("id", groups.get(pos).getId());
                    i.putExtra("plusButton","show");
                    i.putExtra("clickOrganization", "Default");
                    i.putExtra("title",groups.get(pos).getName());
                    i.putExtra("type", groups.get(pos).getType());
                    i.putExtra("img", groups.get(pos).getImage());
                    v.getContext().startActivity(i);
                }
            });
        }
    }
}
