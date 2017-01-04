package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.idesolusiasia.learnflux.activity.ChattingActivity;
import com.idesolusiasia.learnflux.activity.GroupDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.component.CircularNetworkImageView;
import com.idesolusiasia.learnflux.entity.Contact;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.RequestTemplate;
import com.idesolusiasia.learnflux.util.VolleySingleton;
import com.koushikdutta.ion.Ion;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/4/2016.
 */

public class ConnectionFragmentAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    public List<Object>connection;
    private Context context;
    Animation animation;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    private final int CONTACT=0, GROUP=1;

    public ConnectionFragmentAdapter(Context context, ArrayList<Object> orgs){
        this.connection = orgs;
        this.context= context;
    }

    @Override
    public int getItemViewType(int position) {
        if(connection.get(position)instanceof Contact){
            return CONTACT;
        }else if(connection.get(position)instanceof Group){
            return GROUP;
        }
        return -1;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolder;
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        switch (viewType) {
            case CONTACT:
                View v1 = inflater.inflate(R.layout.row_recycleindividual, parent, false);
                viewHolder = new ConnectionFragmentAdapter.ViewHolderUser(v1);
                break;
            case GROUP:
                View v2 = inflater.inflate(R.layout.row_connectionorg, parent, false);
                viewHolder = new ConnectionFragmentAdapter.ViewHolderGroup(v2);
                break;
            default:
                View v = inflater.inflate(android.R.layout.simple_list_item_1, parent, false);
                viewHolder = new ConnectionFragmentAdapter.RecyclerViewSimpleTextViewHolder(v);
                break;
        }
        return  viewHolder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        switch (holder.getItemViewType()) {
            case CONTACT:
                ViewHolderUser vh1 = (ViewHolderUser) holder;
                configureViewHolder1(vh1, position);
                break;
            case GROUP:
                ViewHolderGroup vh2 = (ViewHolderGroup) holder;
                configureViewHolder2(vh2, position);
                break;
            default:
               RecyclerViewSimpleTextViewHolder vh = (RecyclerViewSimpleTextViewHolder) holder;
                configureDefaultViewHolder(vh, position);
                break;
        }
    }
    private void configureViewHolder1(ViewHolderUser vh1, int position) {
        String url="http://lfapp.learnflux.net";
        final Contact contact = (Contact) connection.get(position);
        vh1.getAddF().setVisibility(View.GONE);
        if (contact != null) {
            vh1.gettitle().setText(contact.getFirst_name());
            if(contact.get_links().getProfile_picture()==null){
                vh1.getcircular().setDefaultImageResId(R.drawable.user_profile);
            }else {
                vh1.getcircular().setImageUrl(url + contact.get_links().getProfile_picture().getHref(), imageLoader);
            }
        }
    }

    private void configureViewHolder2(ViewHolderGroup vh2, int position) {
        final Group group =(Group)connection.get(position);
        String url="http://lfapp.learnflux.net/v1/image?key=";
        vh2.getAdd().setVisibility(View.GONE);
        /*if(group !=null) {
            vh2.gettitle2().setText(group.getName());
            if (group.getImage() == null) {
                vh2.getcircular2().setDefaultImageResId(R.drawable.company1);
            } else {
                vh2.getcircular2().setImageUrl(url + group.getImage(), imageLoader);
            }
        }*/

        if(group !=null) {
            vh2.gettitle2().setText(group.getName());
            if (group.getImage() == null) {
                Ion.with(context)
                        .load(url+group.getImage())
                        .addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
                        .withBitmap()
                        .intoImageView( vh2.getcircular2());
            }
            else{
                vh2.getcircular2().setImageResource(R.drawable.company1);
        }
        }
        vh2.getStats().setText(group.getAccess());
    }
    @Override
    public int getItemCount() {
        return connection.size();
    }
    private class ViewHolderUser extends RecyclerView.ViewHolder {
        TextView title; CircularNetworkImageView circular;
        ImageView addF;
        public ViewHolderUser(View itemView) {
            super(itemView);
            title = (TextView)itemView.findViewById(R.id.individualName);
            circular = (CircularNetworkImageView)itemView.findViewById(R.id.circularImage);
            addF = (ImageView)itemView.findViewById(R.id.imageadd);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(final View v) {
                    int pos = getAdapterPosition();
                    final Contact cto = (Contact) connection.get(pos);
                    int []ids = new int[]{cto.getId()};
                    Engine.createThread(v.getContext(), ids, cto.getFirst_name() ,new RequestTemplate.ServiceCallback() {
                        @Override
                        public void execute(JSONObject obj) {
                            try {
                                String id = obj.getJSONObject("data").getString("id");
                                Intent i = new Intent(v.getContext(), ChattingActivity.class);
                                i.putExtra("idThread", id);
                                i.putExtra("name", cto.getFirst_name());
                                v.getContext().startActivity(i);
                            }catch (JSONException e){
                                e.printStackTrace();
                            }
                        }
                    });
                }
            });

        }
        public ImageView getAddF() {
            return addF;
        }

        public void setAddF(ImageView addF) {
            this.addF = addF;
        }


        public TextView gettitle() {
            return title;
        }

        public void settitle(TextView title) {
            this.title = title;
        }
        public CircularNetworkImageView getcircular() {
            return circular;
        }

        public void setcircular(CircularNetworkImageView circular) {
            this.circular = circular;
        }
    }
    private class ViewHolderGroup extends RecyclerView.ViewHolder {
        TextView title2;
        ImageView circular2;
        ImageView add;
        TextView stats;

        public ViewHolderGroup(View itemView) {
            super(itemView);
            title2 = (TextView) itemView.findViewById(R.id.titleOrgConnection);
            circular2 = (ImageView) itemView.findViewById(R.id.imageOrgConnection);
            add = (ImageView) itemView.findViewById(R.id.joinGroup);
            stats = (TextView) itemView.findViewById(R.id.StatusOrgConnection);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    final Group gr = (Group) connection.get(pos);
                    Intent l = new Intent(v.getContext(), GroupDetailActivity.class);
                    l.putExtra("clickOrganization", "Profile");
                    l.putExtra("plusButton", "hide");
                    l.putExtra("id", gr.getId());
                    l.putExtra("title", gr.getName());
                    l.putExtra("type", gr.getType());
                    l.putExtra("img", gr.getImage());
                    l.putExtra("color", Functions.generateRandomPastelColor());
                    v.getContext().startActivity(l);
                }
            });
        }

        public ImageView getAdd() {
            return add;
        }

        public void setAdd(ImageView add) {
            this.add = add;
        }

        public TextView gettitle2() {
            return title2;
        }

        public void settitle2(TextView title2) {
            this.title2 = title2;
        }

        public ImageView getcircular2() {
            return circular2;
        }

        public void setcircular2(ImageView circular2) {
            this.circular2 = circular2;
        }

        public TextView getStats() {
            return stats;
        }

        public void setStats(TextView stats) {
            this.stats = stats;
        }
    }
    private void configureDefaultViewHolder(RecyclerViewSimpleTextViewHolder vh, int position) {
        //   vh.getLabel().setText((CharSequence) theContact.get(position));
    }
    public class RecyclerViewSimpleTextViewHolder extends RecyclerView.ViewHolder {

        private TextView label1;


        public RecyclerViewSimpleTextViewHolder(View v) {
            super(v);
            label1 = (TextView) v.findViewById(R.id.textView);
        }

        public TextView getLabel() {
            return label1;
        }

        public void setLabel1(TextView label1) {
            this.label1 = label1;
        }
    }
}
