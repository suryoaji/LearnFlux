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
import android.widget.ProgressBar;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.ChattingActivity;
import com.idesolusiasia.learnflux.GroupDetailActivity;
import com.idesolusiasia.learnflux.OrgDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 8/15/2016.
 */
public class InterestGroupAdapter extends RecyclerView.Adapter<InterestGroupAdapter.OrgTileHolder> {
    private List<Group> organizations;
    private Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();

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
    public void onBindViewHolder(OrgTileHolder holder, final int position) {
        final Group org= organizations.get(position);
        final String url = "http://lfapp.learnflux.net/v1/image?key=";
        holder.tvName.setText(org.getName());
       /* if(org.getImage()==null) {
            holder.ivLogo.setDefaultImageResId(R.drawable.organization);
        }else {
            holder.ivLogo.setImageUrl(url+org.getImage(), imageLoader);
        }*/
        String pos = url+org.getImage();
        Animation animation = AnimationUtils.loadAnimation(context,
                R.anim.popup_enter);
        if(org.getImage()!=null) {
            Ion.with(context)
                    .load(pos)
                    .addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
                    .withBitmap().animateLoad(animation)
                    .intoImageView(holder.ivLogo);
        }else{
            holder.ivLogo.setImageResource(R.drawable.company1);
        }
        holder.tvImageMessage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(context, ChattingActivity.class);
                i.putExtra("idThread", org.getThread().getId());
                i.putExtra(("name"), org.getName());
                context.startActivity(i);
            }
        });
        holder.tvImageEvent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent l = new Intent(context, OrgDetailActivity.class);
                l.putExtra("clickOrganization","Event");
                l.putExtra("id", org.getId());
                l.putExtra("type",org.getType());
                l.putExtra("title",org.getName());
                context.startActivity(l);
            }
        });
        holder.tvImageActivities.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent activity = new Intent(context, OrgDetailActivity.class);
                activity.putExtra("id", org.getId());
                activity.putExtra("type", org.getType());
                activity.putExtra("title", org.getName());
                activity.putExtra("clickOrganization", "Activity");
                context.startActivity(activity);
            }
        });

    }

    @Override
    public int getItemCount() {
        return organizations.size();
    }

    public class OrgTileHolder extends RecyclerView.ViewHolder {
        TextView tvName, tvLastSeen, tvCountMessage, tvCountEvent, tvCountActivities;
        ImageView ivLogo;
        ImageView tvImageMessage, tvImageEvent, tvImageActivities;
        public OrgTileHolder(View itemView) {
            super(itemView);
            tvName = (TextView) itemView.findViewById(R.id.tvName);
            tvLastSeen = (TextView) itemView.findViewById(R.id.tvLastSeen);
            tvCountMessage = (TextView) itemView.findViewById(R.id.tvCountMessage);
            tvCountEvent = (TextView) itemView.findViewById(R.id.tvCountEvent);
            tvCountActivities = (TextView) itemView.findViewById(R.id.tvCountActivities);
            ivLogo = (ImageView) itemView.findViewById(R.id.ivLogo);
            tvImageMessage = (ImageView) itemView.findViewById(R.id.imageView4);
            tvImageEvent = (ImageView) itemView.findViewById(R.id.imageView5);
            tvImageActivities = (ImageView)itemView.findViewById(R.id.imageView8);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    final int pos = getAdapterPosition();
                    Intent i = new Intent(view.getContext(), GroupDetailActivity.class);
                    i.putExtra("plusButton", "hide");
                    i.putExtra("id", organizations.get(pos).getId());
                    i.putExtra("title",organizations.get(pos).getName());
                    i.putExtra("type", organizations.get(pos).getType());
                    i.putExtra("color", Functions.generateRandomPastelColor());
                    i.putExtra("img", organizations.get(pos).getImage());
                    i.putExtra("clickOrganization", "Default");
                    view.getContext().startActivity(i);
                }
            });
        }
    }
}
