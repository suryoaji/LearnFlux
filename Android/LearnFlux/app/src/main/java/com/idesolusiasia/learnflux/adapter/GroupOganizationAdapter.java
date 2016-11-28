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
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 11/15/2016.
 */

public class GroupOganizationAdapter extends RecyclerView.Adapter<GroupOganizationAdapter.OrgTileHolder> {
    List<Group> organizations;
    public List<Object> connection;
    private Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    public GroupOganizationAdapter(Context context, ArrayList<Group> orgs){
        this.organizations = orgs;
        this.context= context;
    }

    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_connectionorg, null);
        OrgTileHolder rcv = new OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        final Group org= organizations.get(position);
        String url = "http://lfapp.learnflux.net/v1/image?key=";
     /*   if(org.getImage()== null){
            holder.image.setDefaultImageResId(R.drawable.company1);
        }else {
            holder.image.setImageUrl(url, imageLoader);
        }*/
        Animation animation = AnimationUtils.loadAnimation(context,
                R.anim.popup_enter);
        if(org.getImage()!=null) {
                     Ion.with(context)
                    .load(url+org.getImage())
                    .addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
                    .withBitmap().animateLoad(animation)
                    .intoImageView(holder.image);
        }else{
            holder.image.setImageResource(R.drawable.company1);
        }
        holder.txt1.setText(org.getName());
        holder.txt2.setText(org.getAccess());
        holder.add.setVisibility(View.GONE);
    }

    @Override
    public int getItemCount() {
        return organizations.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        ImageView image;
        TextView txt1, txt2;
        ImageView add;
        public OrgTileHolder(View itemView) {
            super(itemView);
            image = (ImageView) itemView.findViewById(R.id.imageOrgConnection);
            txt1 = (TextView)itemView.findViewById(R.id.titleOrgConnection);
            txt2 = (TextView)itemView.findViewById(R.id.StatusOrgConnection);
            add = (ImageView)itemView.findViewById(R.id.joinGroup);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    final int pos = getAdapterPosition();
                    Intent l = new Intent(view.getContext(), GroupDetailActivity.class);
                    l.putExtra("clickOrganization","Profile");
                    l.putExtra("plusButton","hide");
                    l.putExtra("id", organizations.get(pos).getId());
                    l.putExtra("title",organizations.get(pos).getName());
                    l.putExtra("type", organizations.get(pos).getType());
                    l.putExtra("img", organizations.get(pos).getImage());
                    l.putExtra("color", Functions.generateRandomPastelColor());
                    view.getContext().startActivity(l);
                }
            });
        }
    }
}
