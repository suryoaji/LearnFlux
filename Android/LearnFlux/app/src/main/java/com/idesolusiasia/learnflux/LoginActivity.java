package com.idesolusiasia.learnflux;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.TextView;

import com.idesolusiasia.learnflux.entity.User;
import com.idesolusiasia.learnflux.util.Engine;
import com.idesolusiasia.learnflux.util.RequestTemplate;

import org.json.JSONObject;

public class LoginActivity extends AppCompatActivity{
    private EditText etPassword, etUsername;
    private View mLoginFormView;
	TextView tvRegister;
	SharedPreferences sharedPref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

	    sharedPref = getApplicationContext().getSharedPreferences("com.idesolusiasia.learnflux",MODE_PRIVATE);
	    String username = sharedPref.getString("username","");
	    String password = sharedPref.getString("password","");
	    if ((!username.equals(""))||(!TextUtils.isEmpty(username))){
		    User.getUser().setPassword(password);
            User.getUser().setUsername(username);
		    Engine.login(this, username, password, new RequestTemplate.ServiceCallback() {
			    @Override
			    public void execute(JSONObject obj) {
				    Engine.getMe(LoginActivity.this);
				    Intent i = new Intent(LoginActivity.this, HomeActivity.class);
				    i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
				    startActivity(i);
			    }
		    }, null);
	    }

        etUsername = (EditText) findViewById(R.id.username);
        etPassword = (EditText) findViewById(R.id.password);

        TextView mEmailSignInButton = (TextView) findViewById(R.id.email_sign_in_button);
        mEmailSignInButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptLogin();
            }
        });

        mLoginFormView = findViewById(R.id.login_form);

	    tvRegister = (TextView) findViewById(R.id.tvRegister);
	    tvRegister.setOnClickListener(new OnClickListener() {
		    @Override
		    public void onClick(View view) {
			    Intent i = new Intent(LoginActivity.this, RegisterActivity.class);
			    startActivity(i);
		    }
	    });
    }


    private void attemptLogin() {
        // Reset errors.
        etUsername.setError(null);
        etPassword.setError(null);

        // Store values at the time of the login attempt.
        final String username = etUsername.getText().toString();
        final String password = etPassword.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid password, if the user entered one.
        if (!TextUtils.isEmpty(password) && !isPasswordValid(password)) {
            etPassword.setError(getString(R.string.error_invalid_password));
            focusView = etPassword;
            cancel = true;
        }

        // Check for a valid email address.
        if (TextUtils.isEmpty(username)) {
            etUsername.setError(getString(R.string.error_field_required));
            focusView = etUsername;
            cancel = true;
        }

        if (cancel) {
            focusView.requestFocus();
        } else {

	        Engine.login(this, username, password, new RequestTemplate.ServiceCallback() {
		        @Override
		        public void execute(JSONObject obj) {

			        SharedPreferences.Editor editor = sharedPref.edit();
			        editor.putString("username",username);
			        editor.putString("password",password);
			        editor.commit();
			        User.getUser().setUsername(username);
			        User.getUser().setPassword(password);

			        Engine.getMe(LoginActivity.this);
			        Intent i = new Intent(LoginActivity.this, HomeActivity.class);
			        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
			        startActivity(i);
		        }
	        },null);
        }
    }

    private boolean isPasswordValid(String password) {
        //TODO: Replace this with your own logic
        return password.length() > 4;
    }

    @Override
    public void onBackPressed() {
        finish();
    }
}

