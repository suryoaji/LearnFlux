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
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.model.GlideUrl;
import com.bumptech.glide.load.model.LazyHeaders;
import com.idesolusiasia.learnflux.ChattingActivity;
import com.idesolusiasia.learnflux.GroupDetailActivity;
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
import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;


/**
 * Created by Ide Solusi Asia on 10/17/2016.
 */

public class ContactAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder>
       {
    private List<Object>theContact;
    public Context context;
    ImageLoader imageLoader = VolleySingleton.getInstance(context).getImageLoader();
    private final int CONTACT =0 , GROUP=1;

    public ContactAdapter(Context c, List<Object>alphabet)
    {
        this.context=c;
        this.theContact=alphabet;
    }

   @Override
   public int getItemViewType(int position) {
       if (theContact.get(position) instanceof Contact) {
           return CONTACT;
       } else if (theContact.get(position) instanceof Group) {
           return GROUP;
       }
       return -1;
   }
    @Override
    public int getItemCount() {
        return theContact.size() ;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup viewGroup, int viewType) {

        RecyclerView.ViewHolder viewHolder;
        LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());


        switch (viewType) {
            case CONTACT:
                View v1 = inflater.inflate(R.layout.row_recycleindividual, viewGroup, false);
                viewHolder = new ViewHolder1(v1);
                break;
            case GROUP:
                View v2 = inflater.inflate(R.layout.row_connectionorg, viewGroup, false);
                viewHolder = new ViewHolder2(v2);
                break;
            default:
                View v = inflater.inflate(android.R.layout.simple_list_item_1, viewGroup, false);
                viewHolder = new RecyclerViewSimpleTextViewHolder(v);
                break;
        }
      return  viewHolder;
    }

           @Override
           public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
               switch (holder.getItemViewType()) {
                   case CONTACT:
                       ViewHolder1 vh1 = (ViewHolder1) holder;
                       configureViewHolder1(vh1, position);
                       break;
                   case GROUP:
                       ViewHolder2 vh2 = (ViewHolder2) holder;
                       configureViewHolder2(vh2, position);
                       break;
                   default:
                       RecyclerViewSimpleTextViewHolder vh = (RecyclerViewSimpleTextViewHolder) holder;
                       configureDefaultViewHolder(vh, position);
                       break;
               }
           }
           private void configureDefaultViewHolder(RecyclerViewSimpleTextViewHolder vh, int position) {
            //   vh.getLabel().setText((CharSequence) theContact.get(position));
           }
           private void configureViewHolder1(ViewHolder1 vh1, int position) {
               String url="http://lfapp.learnflux.net";
               final Contact contact = (Contact) theContact.get(position);
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

           private void configureViewHolder2(ViewHolder2 vh2, int position) {
               final Group group =(Group)theContact.get(position);
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
               if(group!=null){
                   vh2.gettitle2().setText(group.getName());
                   if (group.getImage() == null) {
                       vh2.getcircular2().setImageResource(R.drawable.company1);
                   }else{
                       GlideUrl glideUrl = new GlideUrl(url+group.getImage(), new LazyHeaders.Builder()
                               .addHeader("Authorization", "Bearer "+User.getUser().getAccess_token())
                               .build());
                       Glide.with(context).load(glideUrl)
                               .diskCacheStrategy(DiskCacheStrategy.ALL)
                               .skipMemoryCache(true).dontAnimate()
                               .into( vh2.getcircular2());
                              /* Ion.with(context)
                               .load(url+group.getImage())
                               .addHeader("Authorization", "Bearer " + User.getUser().getAccess_token())
                               .withBitmap()
                               .intoImageView( vh2.getcircular2());*/
                   }
               }
               vh2.getStats().setText(group.getAccess());
           }

/*    public String getTextToShowInBubble(int pos) {
        List<String>names = new ArrayList<>();
        for(Object c : theContact){
            names.addAll(c.getClass(cont));
        }
        if (pos < 0 || pos >= theContact.size())
            return null;
        final Contact contact = (Contact) theContact.get(pos);
        final Group group =(Group)theContact.get(pos);
        String name = contact.getFirst_name()+group.getName();
        if (name == null || name.length() < 1)
            return null;

        return theContact.get(pos).substring(0, 1);
    }*/
    private class ViewHolder1 extends RecyclerView.ViewHolder {
        TextView title; CircularNetworkImageView circular;
      ImageView addF;
      public ViewHolder1(View itemView) {
          super(itemView);
          title = (TextView)itemView.findViewById(R.id.individualName);
          circular = (CircularNetworkImageView)itemView.findViewById(R.id.circularImage);
          addF = (ImageView)itemView.findViewById(R.id.imageadd);
          itemView.setOnClickListener(new View.OnClickListener() {
              @Override
              public void onClick(final View v) {
                  int pos = getAdapterPosition();
                  final Contact cto = (Contact) theContact.get(pos);
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
    private class ViewHolder2 extends RecyclerView.ViewHolder{
        TextView title2; ImageView circular2;
        ImageView add;
        TextView stats;
        public ViewHolder2(View itemView) {
            super(itemView);
            title2 = (TextView)itemView.findViewById(R.id.titleOrgConnection);
            circular2 = (ImageView)itemView.findViewById(R.id.imageOrgConnection);
            add = (ImageView)itemView.findViewById(R.id.joinGroup);
            stats = (TextView)itemView.findViewById(R.id.StatusOrgConnection);
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    final Group gr = (Group)theContact.get(pos);
                    Intent l = new Intent(v.getContext(), GroupDetailActivity.class);
                    l.putExtra("clickOrganization","Profile");
                    l.putExtra("plusButton","hide");
                    l.putExtra("id", gr.getId());
                    l.putExtra("title",gr.getName());
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

        public TextView getStats(){
            return stats;
        }
        public void setStats(TextView stats){
            this.stats=stats;
        }
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
