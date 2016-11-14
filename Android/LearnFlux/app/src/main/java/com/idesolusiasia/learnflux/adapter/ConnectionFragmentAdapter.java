package com.idesolusiasia.learnflux.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.idesolusiasia.learnflux.GroupDetailActivity;
import com.idesolusiasia.learnflux.R;
import com.idesolusiasia.learnflux.entity.Group;
import com.idesolusiasia.learnflux.util.Functions;
import com.idesolusiasia.learnflux.util.VolleySingleton;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ide Solusi Asia on 10/4/2016.
 */

public class ConnectionFragmentAdapter extends RecyclerView.Adapter<ConnectionFragmentAdapter.OrgTileHolder> {
    List<Group> organizations;
    private Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    public ConnectionFragmentAdapter(Context context, ArrayList<Group> orgs){
        this.organizations = orgs;
        this.context= context;
    }

    @Override
    public OrgTileHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View layoutView = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_connectionorg, null);
        ConnectionFragmentAdapter.OrgTileHolder rcv = new ConnectionFragmentAdapter.OrgTileHolder(layoutView);
        return rcv;
    }

    @Override
    public void onBindViewHolder(OrgTileHolder holder, int position) {
        final Group org= organizations.get(position);
        String url = "http://lfapp.learnflux.net/v1/image?key="+org.getImage();
        if(org.getImage()== null){
            holder.image.setDefaultImageResId(R.drawable.company1);
        }else {
            holder.image.setImageUrl(url, imageLoader);
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
        NetworkImageView image;
        TextView txt1, txt2;
        ImageView add;
        public OrgTileHolder(View itemView) {
            super(itemView);
            image = (NetworkImageView) itemView.findViewById(R.id.imageOrgConnection);
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
