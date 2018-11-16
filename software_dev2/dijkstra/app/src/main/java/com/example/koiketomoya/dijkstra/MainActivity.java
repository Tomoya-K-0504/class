package com.example.koiketomoya.dijkstra;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import com.example.koiketomoya.dijkstra.BoardView;
import com.example.koiketomoya.dijkstra.Solver;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void reset(View view) {
        ((BoardView)findViewById(R.id.boardView)).reset();
    }
    public void solve(View view) {
        ((BoardView)findViewById(R.id.boardView)).solve(this);
    }
}
