package com.example.koiketomoya.dijkstra;

import android.graphics.PointF;
import com.example.koiketomoya.dijkstra.MyPoint;

public class SearchNode {
    double priority;
    MyPoint point;

    public SearchNode(double priority, MyPoint point) {
        this.priority = priority;
        this.point = point;
    }

    double getPriority() {
        return priority;
    }
}